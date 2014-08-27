var scriptURI = fl.scriptURI.split("/");
scriptURI = scriptURI.slice(0, scriptURI.length - 2);
scriptURI.push("standalone");
scriptURI.push("spriteEditor.jsfl");
scriptURI = scriptURI.join("/");

fl.runScript(scriptURI)

var document = fl.getDocumentDOM();
updateFrameItemsFromTileMap(document);
