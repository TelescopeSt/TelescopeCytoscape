<!--
git log --pretty="*%s ([%h](https://github.com/TelescopeSt/TelescopeCytoscape/commit/%H))" v2.2.1...HEAD --grep="Merge pull"
('Content' copyWithRegex: 'Merge pull request #[0-9]+ from [^/]+/[0-9]*' matchesReplacedWith: ' ') copyReplaceAll: '-' with: ' '
-->

# [v2.2.1](https://github.com/TelescopeSt/TelescopeCytoscape/compare/v2.2.0...v2.2.1) (2020-02-19)

## Bug fixes

*  Demo is broken because of API missmatch between Pharo 61 and 7 ([f1572e4](https://github.com/TelescopeSt/TelescopeCytoscape/commit/f1572e488df2110d8742c890acabe4552b0b4a0a))

# [v2.2.0](https://github.com/TelescopeSt/TelescopeCytoscape/compare/v2.1.1...v2.2.0) (2020-02-18)

## New features

* Explain new box selection feature of Cytoscape in the legend ([34b0fed](https://github.com/TelescopeSt/TelescopeCytoscape/commit/34b0fed7515348a42134815325d02332a6524121))

## Bug fixes 

It happend a lot that some mouse out events were missing and interactions where not reverted in that case. Now we try to invalidate those interactions when entering a new graphical element:
* Improve stability of tooltip on mouse over ([fc55898](https://github.com/TelescopeSt/TelescopeCytoscape/commit/fc55898bffad042d4854e275b1824763e50825cf))
* Better management of mouse out for most interactions ([5e5ac7a](https://github.com/TelescopeSt/TelescopeCytoscape/commit/5e5ac7a30fdee535fb72cff1c6e5a415062ffffe))
* Fix bug causing the first rendering of labels to not have the right style ([11aa649](https://github.com/TelescopeSt/TelescopeCytoscape/commit/11aa649d71d88d1deee8711a70b636f0d4f6e4eb))

## Cleanings

* Improve management of first animation ([979eb4f](https://github.com/TelescopeSt/TelescopeCytoscape/commit/979eb4fc1734857fe1365081315a6f2ef3fe1c60))

## Infrastructure

* Update Cytoscape from v3.2.6 to v3.14.0 ([11aa649](https://github.com/TelescopeSt/TelescopeCytoscape/commit/11aa649d71d88d1deee8711a70b636f0d4f6e4eb))
* Update Cytoscape-Qtip to v2.8.0 ([5e5ac7a](https://github.com/TelescopeSt/TelescopeCytoscape/commit/5e5ac7a30fdee535fb72cff1c6e5a415062ffffe))
* Update CI to not allow failure for Pharo 8 + add Pharo 9 as allowed failure

# [v2.1.1](https://github.com/TelescopeSt/TelescopeCytoscape/compare/v2.1.0...v2.1.1) (2019-11-01)

## Infrastructure

* Tests migrated from BabyMock 1 and 2 to Mocketry ([e36fb90](https://github.com/TelescopeSt/TelescopeCytoscape/commit/e36fb90fd9b172e9a7a0cfe7858621d720cca218))
* Refactore websocket usage to be able to share the web socket ([a5eb594](https://github.com/TelescopeSt/TelescopeCytoscape/commit/a5eb59423d577094f7f0cd55d8d90823e5d7d712))


# [v2.1.0](https://github.com/TelescopeSt/TelescopeCytoscape/compare/v2.0.2...v2.1.0) (2019-06-28)

## New features

* Add menu entry to open demo ([c322560](https://github.com/TelescopeSt/TelescopeCytoscape/commit/c322560a7fd4644feac09b6cb69a0458bb6f9ff0))
* Add menu entries to manage devdeployment modes ([1334494](https://github.com/TelescopeSt/TelescopeCytoscape/commit/13344947b4ab40cf8ca9401894c0eaca2d1c7879))
* Add nodesShapesAvailableForConnector for future Telescope feature ([448f107](https://github.com/TelescopeSt/TelescopeCytoscape/commit/448f1075acf560fb6b9a5166bc51871200d3af75))

## Bug fixes

* forCytoscape should be in Cytoscape ([4c0514a](https://github.com/TelescopeSt/TelescopeCytoscape/commit/4c0514ae666b602dd6b6ededdbcd31795f188237))
* Pharo 7 and 8 builds are failing ([c4daf76](https://github.com/TelescopeSt/TelescopeCytoscape/commit/c4daf766fe4c31c4fc1d4b96e53051d47bfcc449))

## Cleaning

* Classify methods ([abe3b60](https://github.com/TelescopeSt/TelescopeCytoscape/commit/abe3b605f491c8339c01ea31bbca17b85397c667))
* Removed node position storage ([5548c1f](https://github.com/TelescopeSt/TelescopeCytoscape/commit/5548c1f49c0500d913e99057cd8dc282c2a45057))
* TLCytoscapeConnector as undefined subclass responsibility ([b208094](https://github.com/TelescopeSt/TelescopeCytoscape/commit/b208094a37fd40050b5c2d640eaa085a4926c4e1))
* TLVirtualNode contains dead code ([87a458d](https://github.com/TelescopeSt/TelescopeCytoscape/commit/87a458d6a439c43180f5043c1c4f9c461a38a47c))
* Test class should not end with s ([124f063](https://github.com/TelescopeSt/TelescopeCytoscape/commit/124f063238f61bd1399e3252c466b09b764b44a4))
* Remove dead branch of if in TLVirtualNode ([b2a71ea](https://github.com/TelescopeSt/TelescopeCytoscape/commit/b2a71ea94bb7b63f895298a4180cc8cd0d8583a4))

## Infrastructure

* Add Pharo 8 to travis ([207dbfc](https://github.com/TelescopeSt/TelescopeCytoscape/commit/207dbfc5b2aa99e75ea8a20c0e1631939cdc302f))
* Add gitattribute file to ensure st files are Smalltalk ([fd78e3c](https://github.com/TelescopeSt/TelescopeCytoscape/commit/fd78e3cf5a5d613df779ecc83ed00cfc7a75d91e))
* Depend on master branch of NeoJSON ([4cb1a8c](https://github.com/TelescopeSt/TelescopeCytoscape/commit/4cb1a8c239bf22a189688191c8afcf736d5af785))
* Remove appveyor from CI since Telescope is OS independant and we have travis ([1e97381](https://github.com/TelescopeSt/TelescopeCytoscape/commit/1e97381cc2360d75d91d2bd161b862c0e0c24f95))

# [v2.0.2](https://github.com/TelescopeSt/TelescopeCytoscape/compare/v2.0.1...v2.0.2) (2018-12-17)

## Enhancements

* Use Github version of Sven's projects ([eaadbdb](https://github.com/TelescopeSt/TelescopeCytoscape/commit/eaadbdbc1d2ceb5047debb796eb0a61c1fd000b7))

# [v2.0.1](https://github.com/TelescopeSt/TelescopeCytoscape/compare/v2.0.0...v2.0.1) (2018-12-05)

## Enhancements

* Use WebBrowser to open visus in Pharo 7+ ([b02ace](https://github.com/TelescopeSt/TelescopeCytoscape/commit/b02ace1ed421fd08bc3380b84a2140c1d3c13f31))

# [v2.0.0](https://github.com/TelescopeSt/TelescopeCytoscape/compare/v1.0.0...v2.0.0) (2018-11-15)

## Infrastructure

* Migrate to Telescope v2. ([0e669c2](https://github.com/TelescopeSt/TelescopeCytoscape/commit/0e669c2fa72cdab825f2987923c54a64b050e7b6))
