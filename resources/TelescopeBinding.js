class TLJS {
  static eventsWithInteractions = {
    "tap": "click",
    "cxttap": "rightClick",
    "mouseover": "mouseOver",
    "mouseout": "mouseOut"
  }

  static getWebSocket(wsPortOrNull, webSocketMapOrNull) {
    const webSocketMap = webSocketMapOrNull || this.webSocketMap
    const wsPort = wsPortOrNull || "1701"
    if (!this.__webSocketMap.has(wsPort)) {
      TLJS.__initWebSocketOnPort(wsPort, webSocketMap)
    }
    return webSocketMap.get(wsPort)
  }

  static resetWebSocket(wsPortOrNull, webSocketMapOrNull) {
    const webSocketMap = webSocketMapOrNull || this.webSocketMap
    const wsPort = wsPortOrNull || "1701"
    TLJS.__initWebSocketOnPort(wsPort, webSocketMap)
  }

  static get webSocketMap() {
    if (!this.__webSocketMap) {
      this.__webSocketMap = new Map()
    }
    return this.__webSocketMap
  }

  static get wsProtocol() {
    if (location.protocol === "https:") {
      return "wss://"
    } else {
      return "ws://"
    }
  }

  static __initWebSocketOnPort(wsPort, webSocketMap) {
    const websocket = new WebSocket(TLJS.wsProtocol + location.hostname + ":" + wsPort + "/ws-TLCytoscape")
    websocket.onclose = function (evt) {
      TLJS.singleton.onClose(evt)
    }
    websocket.onmessage = function (evt) {
      TLJS.singleton.onMessage(evt)
    }
    websocket.onerror = function (evt) {
      TLJS.singleton.onError(evt)
    }
    websocket.onopen = function (evt) {
      const instance = TLJS.singleton
      instance.sendGenerationCommand(instance.visusWaitingConnectToGenerate)
    }
    webSocketMap.set(wsPort, websocket)
  }

  static get singleton() {
    if (!this.__singleton) {
      this.__singleton = new TLJS()
    }
    return this.__singleton
  }

  static initVisus() {
    TLJS.singleton.initVisus()
  }

  constructor() {
    this.visus = new WeakMap()
    this.commandsAction = new Map()
    this.visusWaitingConnectToGenerate = []
    this.waitingDivByVisu = {}
    this.toNotifyMessage = {}
    this.id = 0
    this.timeoutId=null
    this.setUpCommand()
  }

  initVisus(htmlElement) {
    let idsNeedGeneration = []
    for (let visuElement of (htmlElement || document).getElementsByClassName("visualization")) {
      const container = visuElement.parentNode
      if (!this.visus.has(container)) {
        this.waitingDivByVisu[container.getAttribute("id")] = container.getElementsByClassName("tlWaiting")[0]
        const visu = cytoscape({
          pixelRatio: 1,
          container: visuElement,
          layout: {name: "preset"},
        })
        this.visus.set(container, visu)
        idsNeedGeneration.push(container.id)
        this.parametrizeInteractionsListenerForVisu({visuId: container.id, visu})
      }
    }
    this.sendGenerationCommand(idsNeedGeneration)
  }

  parametrizeInteractionsListenerForVisu(visuWithId) {
    visuWithId.protectDoubleFire = {}
    const evtFunction = this.createEventFunction(visuWithId)
    const evtFunctionWithDelais = this.delaisEvtFunction(evtFunction)
    visuWithId.visu.on("tap mouseout cxttap", evtFunction)
    visuWithId.visu.on("mouseover", evtFunctionWithDelais)
    visuWithId.visu.on("free", "node", this.createDragEventFunction(visuWithId))
  }

  createDragEventFunction(visuWithId) {
    const that = this
    return function (evt) {
      //We only send a moveNode command if it is not considered as a drop
      if (!that.isDropActionOnANode(visuWithId, evt.cy.elements(), this.renderedPosition(), evt.target))
        that.sendCommand([{id: visuWithId.visuId, nodeId: evt.target.id(), command: "moveNode", position: evt.target.position()}], false);
    }
  }

  isDropActionOnANode(visuWithId, candidates, pos, droppedNode) {
    var target;

    for (let i = 0; i < candidates.length; i++) {
      var node = candidates[i];
      var bound = node.renderedBoundingBox();
      if (node != droppedNode && bound.x1 < pos.x && bound.x2 > pos.x && bound.y1 < pos.y && bound.y2 > pos.y) {
        //here we found a node correctly positionned and *WARNING* we keep the last one so with the closest zIndex
        target = node;
      }
    }

    // if we found a target and this one has a drop interaction then we request the server
    if (target && target.dropInteraction) {
      this.sendCommand([{id: visuWithId.visuId, nodeId: droppedNode.id(), command: "dropNode", targetNode: target.id()}]);
      return true;
    } else
      return false;
  }

  // I manage the events I receive from Cytoscape to send to Telescope.
  // I implement some mecanism to make the management of the events better for the user.
  // First, I implement a mecanisme to avoid to double fire an event.
  // Second, I implement an mecanisme to workaround a bug where cytoscape do not send a mouse out event sometimes.
  // To do that, I keep the current mouseover event and when I mouseover another element, I send an emulated mouseout event for this saved event to the websocket if there was no mouseout event received before.
  // This allows TelescopeCytoscape to not accumulate mouse over interactions when we do not receive a mouse out event.
  createEventFunction(visuWithId) {
    const that = this
    return function (evt) {
      that.clearOverInteraction()
      var visu = visuWithId.visu
      if (evt.target.id != null && !visuWithId.protectDoubleFire[evt.type] && (!visu.animated() || (evt.type == "mouseout"))) {
        // Sometimes cytoscape fail to send a mouseout event. This can cause multiple tooltip to stay visible when they should not.
        // In order to improve the usability of Telescope, when we go over of any element, we also hide the other tooltips that are visible and that should show on a mouse over.
        if (evt.type == "mouseover") {
          visu.elements().each(function (element) {
            var qtipAPI = element.qtip("api")
            if (element != evt.target && qtipAPI && qtipAPI.tooltip && qtipAPI.tooltip.is(":visible") && qtipAPI.options.show.event == "mouseover") {
              qtipAPI.hide()
            }
          })
        }

        // Server interaction processing
        if (!((!evt.target["mouseOverInteraction"]) && ((evt.type == "mouseover") || (evt.type == "mouseout")))) {
          visuWithId.protectDoubleFire[evt.type] = true
          setTimeout(function () {
            visuWithId.protectDoubleFire[evt.type] = false
          }, self.reactTime * 4)

          // If we have a mouseout event and a previously saved mouseover event, we remove the saved event.
          if ((evt.type == "mouseout") && visu.currentOveredElement != null && visu.currentOveredElement.target.id() == evt.target.id()) {
            visu.currentOveredElement = null
          }

          // If we receive a mouseover event, we discard the potentially saved mouseover event for which we did not received a mouseout event from cytoscape. Then save the new mouseover event.
          if (evt.type == "mouseover") {
            if (visu.currentOveredElement != null) {
              that.sendCommand([{
                id: visuWithId.visuId,
                drawableId: visu.currentOveredElement.target.id(),
                command: "interaction",
                kind: (TLJS.eventsWithInteractions["mouseout"])
              }])
              visu.currentOveredElement = null
            }
            visu.currentOveredElement = evt
          }

          that.sendCommand([{
            id: visuWithId.visuId,
            drawableId: evt.target.id(),
            command: "interaction",
            kind: (TLJS.eventsWithInteractions[evt.type])
          }])
          // menu management
          if (evt.type == "cxttap" && evt.target["menu"]) {
            that.displayMenuForElement(evt.target, visuWithId.visuId, {
              x: evt.originalEvent.clientX,
              y: evt.originalEvent.clientY
            })
            visu.container().style.cursor = ""
          }
        }
      }
    }
  }

  delaisEvtFunction(evtFunction) {
    const that = this
    return function (evt) {
      that.clearOverInteraction();
      that.timeoutId = setTimeout(function() {
        evt.target.onmouseover= null;
        evtFunction(evt);
      }, self.reactTime);
    }
  }

  clearOverInteraction(){
    if(this.timeoutId!=null){
      clearTimeout(this.timeoutId);
      this.timeoutId=null;
    }
  }

  sendGenerationCommand(visusIds, port) {
    const websocket = TLJS.getWebSocket(port)
    if (websocket.readyState == 0) {
      this.visusWaitingConnectToGenerate = this.visusWaitingConnectToGenerate.concat(visusIds)
    } else {
      const messages = visusIds.reduce((acc, id) => {
        if (document.getElementById(id) != null) {
          acc.push({id, command: "generate"})
        }
        return acc
      }, [])
      websocket.send(JSON.stringify(messages))
      this.visusWaitingConnectToGenerate = []
    }
  }

  sendCommand(jsonArr, progress, port) {
    if (progress !== false) // strict equality to accept null as true value for progress
      for (var i = 0; i < jsonArr.length; i++)
        this.visuWithId(jsonArr[0].id).container().style.cursor = "progress"
    TLJS.getWebSocket(port).send(JSON.stringify(jsonArr))
  }


  // I am called when the websocket has an error event
  onError(evt) {
    this.tryReconnect = false
  }

  // I am called when the websocket is closing.
  onClose(evt) {
    this.tryReconnect = this.tryReconnect && this.pageHaveVisu()
    if (this.tryReconnect) {
      TLJS.resetWebSocket(visus)
    }
  }

  onMessage(evt) {
    const commands = JSON.parse(evt.data)
    const toUpdate = {}
    const needNotify = {}
    commands.forEach(command => {
      if (command.visuId) {
        needNotify[command.visuId] = true
      }
      const visu = this.visuWithId(command.visuId)
      if (this.commandsAction.has(command.command)) {
        this.commandsAction.get(command.command)(command, visu, toUpdate)
      } else {
        console.log("unsupported command: " + command.command)
      }
    })
    //customize in one visu rendering all element toUpdate
    this.customizeAll(toUpdate)
    Object.keys(needNotify).forEach(visuId => {
      this.notifyMessageEnd(needNotify[visuId])
      this.visuWithId(visuId).container().style.cursor = ""
    })
    this.notifyMessageEnd("onAll")
  }

  notifyMessageEnd(visuId) {
    if (this.toNotifyMessage[visuId] != null)
      for (let i = 0; i < this.toNotifyMessage[visuId].length; i++) {
        this.toNotifyMessage[visuId][i]()
      }
  }

  //Return true if the page has at least one visualization
  pageHaveVisu() {
    return this.visus.size > 0
  }

  static visuWithId(aVisuId) {
    return this.singleton.visuWithId(aVisuId)
  }

  visuWithId(aVisuId) {
    return this.visus.get(document.getElementById(aVisuId))
  }

  toBatchCommand(command, visu, toUpdate) {
    toUpdate[command.visuId] = toUpdate[command.visuId] || []
    toUpdate[command.visuId].push(command)
  }

  customizeAll(toUpdate) {
    const visuIDs = Object.keys(toUpdate)
    for (var i = 0; i < visuIDs.length; i++) {
      const cmds = toUpdate[visuIDs[i]]
      const visu = this.visuWithId(visuIDs[i])
      visu.startBatch()
      for (var j = 0; j < cmds.length; j++) {
        this.commandsActionBatch[cmds[j].command](cmds[j], visu)
      }
      visu.endBatch()
    }
  }

  removeWaitingForVisuId(aVisuId) {
    try {
      this.waitingDivByVisu[aVisuId].parentNode.removeChild(this.waitingDivByVisu[aVisuId])
      this.waitingDivByVisu[aVisuId] = null
    } catch (err) {
      //Here the waiting has been removed a previous time
      console.log(err)
    }
  }

  customizeElement(element, commandParametersForElement) {
    // here we define the attribute for mouse over to avoid sending request to the server if unnecessary
    if ((commandParametersForElement.mouseOverInteraction !== null))
      element["mouseOverInteraction"] = commandParametersForElement.mouseOverInteraction
    // here we define the attribute for mouse over to avoid sending request to the server if unnecessary
    if ((commandParametersForElement.dropInteraction !== null))
      element["dropInteraction"] = commandParametersForElement.dropInteraction
    // here we define a popup if the element has one
    if (commandParametersForElement.popUp) {
      element.popUp = commandParametersForElement.popUp
      element.qtip(commandParametersForElement.popUp)
    }
    // here we define a menu if element has one
    if (commandParametersForElement.menu) {
      element["menu"] = commandParametersForElement.menu
    }
  }

  addStaticLegendEntry(visuId, html) {
    var div = document.getElementById(visuId + "legend")
    if (!div) {
      var legendInfoId = "legend" + this.id
      this.id++
      div = $("<div>", {id: visuId + "legend", class: "tlLegend"})
        .html("<span style=\"font-weight:bold;\">Legend</span> <div style=\"float: right; margin-left: 15px;\"><span id=\"" + legendInfoId + "\" style=\"cursor: help; margin-right: 5px;\">�</span><div style=\"display: none\"><strong>Box selection</strong><hr>It is possible to move multiple nodes at a time in the visualization by maintaining the SHIFT key (or three finger swipe on tablet) while doing a box selection. You can then move the selected node in group. You can cancel the selection by clicking somewhere in the visualization.</div><img data-fold style=\"cursor: pointer;\" src=\"/files/CYSFileLibrary/arrowUp.png\" onclick=\"TLJS.toggleLegend(this);\"></div><table></table>")[0]
      document.getElementById(visuId).appendChild(div)
      $("#" + legendInfoId).qtip({
        content: {
          text: $("#" + legendInfoId).next()
        }
      })
    }

    div.getElementsByTagName("table")[0].insertRow(-1).innerHTML = html
  }

  setUpCommand() {
    this.commandsAction.set("add", (command, visu) => {
      // Since v3.3.0 of cytoscape, it is not possible anymore to create a node with a style in the parameters.
      // Here we create one stylesheet for each element and my add the related class to objet to create.
      // Performance wise, it is betten than creating the nodes then applying a style bypass to each of them.
      // Maybe in the future we can do better but it would mean a good refactoring of the connector.
      // We would need to group the nodes to add and update by stylesheet. This mean that the multiple add command would no longer be a simple composite and actions should keep state to keep the list of stylesheets.
      let elementClass
      command.parameters.forEach(parameter => {
        elementClass = "element" + this.id
        this.id++
        visu.style().selector("." + elementClass).css(parameter.style)
        parameter.style = null
        parameter.classes = [elementClass]
      })

      const elements = visu.add(command.parameters)
      for (let elementId = 0; elementId < elements.length; elementId++) {
        this.customizeElement(elements[elementId], command.parameters[elementId])
      }
    })

//just register visu to remove cursor progress
    let toBatchCommand = this.toBatchCommand.bind(this)
    this.commandsAction.set("acknoledgeReceipt", toBatchCommand)
    this.commandsActionBatch = {}
    this.commandsActionBatch.acknoledgeReceipt = function () {
    }

    this.commandsAction.set("remove", toBatchCommand)
    this.commandsActionBatch.remove = function (command, visu) {
      visu.remove(visu.getElementById(command.nodeId))
    }

    this.commandsAction.set("positioning", (command, visu) => {
      visu.layout(command.layout).run()
    })

    this.commandsAction.set("customize", toBatchCommand)
    this.commandsActionBatch.customize = function (command, visu) {
      let element = visu.getElementById(command.elementId)
      element.style(command.style)
      element.mouseOverInteraction = command.mouseOverInteraction
    }

    this.commandsAction.set("addStaticLegendEntry", (command) => {
      this.addStaticLegendEntry(command.visuId, command.html)
    })

    this.commandsAction.set("removeLegend", (command) => {
      $("#" + command.visuId + "legend").find("table").children().remove()
    })

    this.commandsAction.set("refreshNode", (command, visu) => {
      visu.$("#" + command.data.id).changeData(command)
    })

    this.commandsAction.set("callbackUrl", (command, visu) => {
      sendCallBack(command.callbackUrl, command.openInNewTab)
    })

// Called when we execute a Seaside ajax callback interaction
    this.commandsAction.set("ajax", (command, visu) => {
      $(command.cssQuery).load(command.callbackUrl)
    })

    this.commandsAction.set("generated", (command) => {
      this.removeWaitingForVisuId(command.visuId)
    })

    this.commandsAction.set("error", (command) => {
      if (handleServerError[command.detail]) {
        handleServerError[command.detail](command)//usefull to display messages
      } else if (this.waitingDivByVisu[command.visuId] != null) {
        this.waitingDivByVisu[command.visuId].innerHTML = "An error has occured."
        notify("An error has occured")
        console.log("message error have no display")
        console.log(command)
      }
      onError()//generic handle Error
    })
  }

  static toggleLegend(button) {
    var table = $(button.parentNode.parentNode.getElementsByTagName("table")[0])
    if (button.dataset.fold) {
      table.fadeIn()
      button.setAttribute("src", "/files/CYSFileLibrary/arrowUp.png")
      button.dataset.fold = ""
    } else {
      table.fadeOut()
      button.setAttribute("src", "/files/CYSFileLibrary/arrowDown.png")
      button.dataset.fold = "true"
    }
  }

  static disableUserNotification() {
    notify = function (message) {
      console.log(message)
    }
  }

  static notifyMessageEnd(visuId) {
    this.singleton.notifyMessageEnd()
  }

  notifyMessageEnd(visuId) {
    if (this.toNotifyMessage[visuId] != null)
      for (let i = 0; i < this.toNotifyMessage[visuId].length; i++) {
        this.toNotifyMessage[visuId][i]()
      }
  }

  static enableUserNotification() {
    this.singleton.enableUserNotification()
  }

  enableUserNotification() {
    function showNotification(message) {
      new Notification(message)
    }

    if (!("Notification" in window)) {
      TLJS.disableUserNotification()
    } else if (Notification.permission === "granted") {
      notify = showNotification
    } else if (Notification.permission !== "denied") {
      Notification.requestPermission(function (permission) {
        if (permission === "granted") {
          notify = showNotification
        } else {
          TLJS.disableUserNotification()
        }
      })
    } else {
      TLJS.disableUserNotification()
    }
  }

  static onMessageEnd(callback, id) {
    this.singleton.onMessageEnd(callback, id)
  }

  onMessageEnd(callback, id) {
    if (id != null) {
      if (this.toNotifyMessage[id] == null)
        this.toNotifyMessage[id] = []
      this.toNotifyMessage[id].push(callback)
    } else {
      this.onMessageEnd(callback, "onAll")
    }
  }

  static useExternalTrigger(evt, visuId, triggerId) {
    return this.singleton.useExternalTrigger(evt, visuId, triggerId)
  }

  useExternalTrigger(evt, visuId, triggerId) {
    this.sendCommand([{
      id: visuId,
      command: "externalTrigger",
      triggerId: triggerId,
      kind: (TLJS.eventsWithInteractions[evt.type] || evt.type)
    }])
  }

}

window.addEventListener("load", () => {
  console.log("loaded")
  TLJS.initVisus()
}, false)


var notify
TLJS.enableUserNotification()


function changeData(command) {
  let self = this
  if (command.style) {
    self.style(command.style)
  }
  visu = self.cy()
  newNode = {
    group: self.group(),
    position: self.position(),
    data: command.data,
    style: self.style()
  }
  edges = self.connectedEdges()
  children = self.children()
}


cytoscape("collection", "changeData", changeData)

console.warn("telescope is deprecated. Use TLJS instead.")
let telescope = TLJS


visuWithId = function (id) {
  console.log("visuWithId is deprecated. Use telescope.visuWithId instead.")
  return telescope.visuWithId(id)
}

telescope.loadVisuIn = (htmlElement) => {
  TLJS.singleton.initVisus(htmlElement)
}
