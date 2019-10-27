# TelescopeCytoscape

Master [![Build Status](https://travis-ci.org/TelescopeSt/TelescopeCytoscape.svg?branch=master)](https://travis-ci.org/TelescopeSt/TelescopeCytoscape)|
Development [![Build Status](https://travis-ci.org/TelescopeSt/TelescopeCytoscape.svg?branch=development)](https://travis-ci.org/TelescopeSt/TelescopeCytoscape)

TelescopeCytoscape is a connector to render [Telescope](https://github.com/TelescopeSt/Telescope) visualization on web via [Seaside](https://github.com/SeasideSt/Seaside).

It uses [CytoscapeJs](http://js.cytoscape.org/) library and websockets to render and update the visualization.

<img src="https://raw.githubusercontent.com/TelescopeSt/TelescopeCytoscape/development/resources/cytoscape.gif">

# Documentation

## Version management 

This project use semantic versionning to define the releases. This mean that each stable release of the project will get associate a version number of the form `vX.Y.Z`. 

- **X** define the major version number
- **Y** define the minor version number 
- **Z** define the patch version number

When a release contains only bug fixes, the patch number increase. When the release contains new features backward compatibles, the minor version increase. When the release contains breaking changes, the major version increase. 

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

## Install TelescopeCytoscape

To install TelescopeCytoscape on your Pharo image you can just execute the following script:

```Smalltalk
    Metacello new
    	githubUser: 'TelescopeSt' project: 'TelescopeCytoscape' commitish: 'v2.x.x' path: 'src';
    	baseline: 'TelescopeCytoscape';
    	onWarningLog;
	onUpgrade: [ :e | e useIncoming ];
    	load
```

To add TelescopeCytoscape to your baseline just add this:

```Smalltalk
    spec
    	baseline: 'TelescopeCytoscape'
    	with: [ spec repository: 'github://TelescopeSt/TelescopeCytoscape:v2.x.x/src' ]
```

Note that you can replace the v1.x.x tag by a branch as #master or #development or a tag as #v1.0.0, #v1.? or #v1.0.x or a commit SHA.

## Getting started

### Open a simple visualization

If you wish to use TelescopeCytoscape only to create a see a visualization, you can create you visualization and send `open` or `openOnWeb` to it. 

```Smalltalk
	| visualization |
	visualization := TLVisualization fromEntities: (0 to: 359).
	visualization layout: ((TLLinearLayout maximumDimension: 300) angle: 360 atRandom).
	visualization styleSheet backgroundColor: ((MDLColor red property: #yourself gradientAt: 0) to: MDLColor yellow at: 360).
	visualization addInteraction: (TLCustomAction block: [ :node | visualization layout angle: node entity. visualization requireLayoutApplication ]) onClick.
	visualization addInteraction: (TLPopUpAction text: [ :e | 'Turn to an angle of ', e asString , '°' ]) onMouseOver.
	visualization open
```

This will use the first `ZincServerAdaptor` it found (if none it will open one on the port 8085) and open the visualization in an already defined Seaside application.

> Note: If your visualization does not work, verify that the port 8085 and 1701 are free. You can find bellow documentation to know how to change the port 1701 for the websocket. For the seaside adapter, open `World menu > Tools > Seaside Control Panel` and add and start an appropropriate `ZnZincServerAdaptor`

### Use TelescopeCytoscape in your Seaside application

The first thing to do in order to use TelescopeCytoscape with your Seaside application is to add its `FileLibrary` to it.

```Smalltalk
	(WAAdmin register: self asApplicationAt: 'myApplication')
		addLibrary: JQDeploymentLibrary;
		addLibrary: CYSFileLibrary
```

### Optional: Set the ports for the websocket 

It is possible to change the port the Cytoscape client and Telescope server will use.

The server port will be 1701 by default. It is possible to specify another port with this command:

```Smalltalk
TLCytoscapeWebSocketDelegate serverPort: 1701.
```

The client will by default use same port as the server. But it is possible to specify another port with this command:

```Smalltalk
TLCytoscapeWebSocketDelegate clientPort: 1701.
```

Changing the client port should be needed only in the case where you deploy an application over TLS and need to manage the encrypted communication via a reverse proxy such as nginx.

### Render a visualization in Seaside 

Once your Seaside application is setup you just need to use TLCytoscapeComponent to render a visualization.

**Example:**

```Smalltalk
renderContentOn: html
	| visu |
	(visu := TLVisualization fromEntities: (1 to: 40)) nodeLabel: #asString.
	(visu styleSheet > #connectDemo) color: Color orange; width: 2.
	visu addInteraction: ((TLConnectAction property: [ :n | (1 to: 40) copyWithout: n ] context: visu allNodes) connectToOrigin: #even; connectionStyle: #connectDemo; yourself) onMouseOver.
	html render: (TLCytoscapeComponent visualization: visu)
```

## Deploy an application using TelescopeCytoscape

Deploying a Seaside application with TelescopeCytoscape can be a little tricky because it uses WebSockets.

In order to help you with that we will give an example of nginx configuration.

### Deploy without certificate

Deploying without certificate is pretty easy since the websocket used will not be secured (`ws://`).

Here is an example of a nginx configuration:

```yalm
server {
  listen 80; #Since it's a web application, listen port 80
  listen [::]:80; #Same for IPv6
  server_name {Domaine name. Example mysite.com}; #Set your domaine name
  server_tokens off;  #Do not display nginx version for security reasons

  access_log /var/log/nginx/{log name}.log; #loging
  error_log /var/log/nginx/{error log name}.log; #error loging

  root {Path to the root. For example /srv/myApp/};

  location = / {
    try_files $uri $uri/index.html @proxy;
  }

  #use a proxy for your seaside application
  location @proxy {
    rewrite ^ /{Seaside application name. For example TelescopeDemo}$1 last;
  }

  location /{Seaside application name. For example TelescopeDemo} {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_pass http://127.0.0.1:{Port on which your ZincServerAdaptor listen. For example 8080};
  }

  # This is for the file libraries
  location /files {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_pass http://127.0.0.1:{Port on which your ZincServerAdaptor listen. For example 8080};
  }

}
```

### Deploy with certificate

When you deploy with a TLS certificate, you need to use a secure websocket (`wss://`) and the communication needs to be managed with you TLS certificate.

The easiest way to do that is to use a reverse proxy for the `WSS:// -> WS://` as we do for `HTTPS:// -> HTTP://`.

First we need to define a different port between the client and server side of the websocket. We can execute something like this in the Seaside application:

```Smalltalk
TLCytoscapeWebSocketDelegate 
	clientPort: 28341;
	serverPort: 28340
```

Then we need to configure nginx:


```yalm 
server {
  listen 80; #Since it's a web application, listen port 80
  listen [::]:80; #Same for IPv6
  server_name {Domaine name. Example mysite.com}; #Set your domaine name
  server_tokens off;  #Do not display nginx version for security reasons
  return 301 https://$server_name$request_uri; #Redirect HTTP -> HTTPS
}

server {
  listen 443 ssl http2; #Listen to port 443 for HTTPS
  listen [::]:443 ssl http2; #Same for IPv6
  server_name {Domaine name. Example mysite.com}; #Set your domaine name
  server_tokens off;  #Do not display nginx version for security reasons
  ssl_certificate {path to your public certificate key}.pem;
  ssl_certificate_key {path to your private certificate key}.pem;

  access_log /var/log/nginx/{log name}.log; #loging
  error_log /var/log/nginx/{error log name}.log; #error loging

  root {Path to the root. For example /srv/myApp/};

  location = / {
    try_files $uri $uri/index.html @proxy;
  }

  #use a proxy for your seaside application
  location @proxy {
    rewrite ^ /{Seaside application name. For example TelescopeDemo}$1 last;
  }

  location /{Seaside application name. For example TelescopeDemo} {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_pass http://127.0.0.1:{Port on which your ZincServerAdaptor listen. For example 8080};
  }

  # This is for the file libraries
  location /files {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_pass http://127.0.0.1:{Port on which your ZincServerAdaptor listen. For example 8080};
  }

}

server {
  listen 28341 ssl; #Listen on the client websocket port
  listen [::]:28341 ssl;
  server_name {domaine name};
  server_tokens off;
  ssl_certificate {path to your public certificate key}.pem;
  ssl_certificate_key {path to your private certificate key}.pem;

  location / {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_pass http://127.0.0.1:28340; #Redirect to the server port. This will manage the TLS.
  }
}
```

## Examples

You can find multiple examples when the application will be installed at the url: [http://localhost:8080/TelescopeDemo](http://localhost:8080/TelescopeDemo)

When you install in a plain Pharo image you need to start the seaside server first by opening `World menu > Tools > Seaside Control Panel` and adding and starting an appropropriate `ZnZincServerAdaptor`. If you do not use port 8080, change the port in the URL.

You can find a demo at: [https://demos.ferlicot.fr/TelescopeDemo](https://demos.ferlicot.fr/TelescopeDemo)

## Smalltalk versions compatibility

| TelescopeCytoscape version 	| Compatible Pharo versions 	|
|---------------------------	|---------------------------	|
| v1.x.x                | Pharo 61, 70                  |
| v2.x.x                | Pharo 61, 70, 80                  |
| development           | Pharo 61, 70, 80               	|

## Contact

If you have any question or problem do not hesitate to open an issue or contact cyril (a) ferlicot.me or guillaume.larcheveque (a) gmail.com

