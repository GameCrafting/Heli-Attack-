fl.outputPanel.clear();

var sourceImageItemName = "image";
var tileMapItemName = "tileMap";
var frameItemName = "frame";
var jointItemName = "joint";
var frameFolderName = "frames";
var animationFolderName = "animations"
var compositionFolderName = "compositions";
var compositionElementTypeFrame = "frame"
var compositionElementTypeAnimation = "animation"
var compositionElementTypeComposition = "composition"
var compositionElementTypeJoint = "joint"


function resetDocument(document) {
    clearLibrary(document);
    importSourceImage(document);
    createFrameItem(document);
    createTileMapItem(document);
    createJointItem(document);

    var description = getDocumentDescriptionFromFile(document, true);
    var elementList = (description.frames.length() > 0) ? description.frames[0].elements("frame") : null;
    var length = (elementList) ? elementList.length() : 0;
    var currentNode;
    var frameName, sourceRect;
    for (var i = 0; i < length; i++) {
        currentNode = elementList[i];
        frameName = currentNode["@name"] + "";
        sourceRect = {};
        sourceRect.x = parseInt(currentNode["@x"]);
        sourceRect.y = parseInt(currentNode["@y"]);
        sourceRect.width = parseInt(currentNode["@width"]);
        sourceRect.height = parseInt(currentNode["@height"]);

        addTileMapFrameItem(document, frameName, sourceRect);
        addFrameItem(document, frameName, sourceRect);

    }

    var animationDescriptionSource = (description.animations.length() > 0) ? description.animations[0] : null;
    if (animationDescriptionSource) {
        addAnimationsFromDescription(document, animationDescriptionSource);
    }
    var compositionDescriptionSource = (description.compositions.length() > 0) ? description.compositions[0] : null;
    if (animationDescriptionSource) {
        setCompositionsDescription(document, animationDescriptionSource);
    }


}


function clearLibrary(document) {
    var library = document.library;
    library.selectAll();
    if (library.getSelectedItems().length > 0) {
        library.deleteItem();
    }
    library.newFolder(frameFolderName);
    library.newFolder(animationFolderName);
    library.newFolder(compositionFolderName);
}


function getDocumentDescriptionFromFile(document, autoCreate) {
    var descriptionURI = document.pathURI;
    descriptionURI = descriptionURI.split(".");
    descriptionURI[descriptionURI.length - 1] = "xml";
    descriptionURI = descriptionURI.join(".");

    var result;
    if (FLfile.exists(descriptionURI)) {
        result = FLfile.read(descriptionURI);
    } else if (autoCreate) {
        result = <document/>;
        result = result.toXMLString();
        FLfile.write(descriptionURI, result);
    }
    if (result) {
        result = new XML(result);
    }
    return result;
}

function saveDocument(document) {
    updateFrameItemsFromTileMap(document);
    var description = getDocumentDescriptionFromDocument(document);
    saveDocumentDescription(document, description);
}


function saveDocumentDescription(document, description) {
    var source = description.toXMLString();
    var descriptionURI = document.pathURI.split(".");
    descriptionURI[descriptionURI.length - 1] = "xml";
    descriptionURI = descriptionURI.join(".");

    FLfile.write(descriptionURI, source);

}

function getDocumentDescriptionFromDocument(document) {
    var result = <document/>;
    var framesDescription = getFramesDescription(document);
    result.appendChild(framesDescription);
    var animationsDescription = getAnimationsDescription(document);
    result.appendChild(animationsDescription);
    var compositionsDescription = getCompositionsDescription(document);
    result.appendChild(compositionsDescription);

    return result;
}

function getFramesDescription(document) {
    var result = <frames/>;
    validateTileMap(document);
    var tileMapElementList = getTileMapFrameElements(document);
    var element;
    var currentNode;
    for (var i = 0; i < tileMapElementList.length; i++) {
        element = tileMapElementList[i];
        currentNode = <frame/>;
        currentNode["@name"] = element.name;
        currentNode["@x"] = parseInt(element.x);
        currentNode["@y"] = parseInt(element.y);
        currentNode["@width"] = parseInt(element.width);
        currentNode["@height"] = parseInt(element.height);
        result.appendChild(currentNode);
    }

    return result;


}
function getAnimationsDescription(document) {
    var result = <animations/>;
    var itemList = getAnimationItemList(document);
    var item;
    var currentNode;
    for (var i = 0; i < itemList.length; i++) {
        item = itemList[i];
        currentNode = getAnimationDescription(item);
        result.appendChild(currentNode);
    }

    return result;


}


function createFrameItem(document) {
    var library = document.library;
    library.addNewItem("movie clip", frameItemName);
    library.editItem(frameItemName);

    var fill = document.getCustomFill("toolbar");
    fill.color = "#00ff0077";
    document.setCustomFill(fill);
    fl.getDocumentDOM().addNewRectangle({left: 0, top: 0, right: 100, bottom: 100}, 0, false, true);
    fl.getDocumentDOM().exitEditMode();

}


function addFrameItem(document, frameName, sourceRect) {
    var library = document.library;
    var itemName = getFrameItemName(frameName, sourceRect);
    library.addNewItem("movie clip", itemName);
    library.selectItem(itemName, true);
    var item = library.getSelectedItems()[0]
    reRenderFrameItem(document, item, sourceRect)

}
function reRenderFrameItem(document, item, sourceRect) {
    var library = document.library;
    library.editItem(item.name);
    fl.getDocumentDOM().selectAll();
    if (fl.getDocumentDOM().selection.length > 0) {
        fl.getDocumentDOM().deleteSelection();
    }


    var fill = document.getCustomFill("toolbar");
    fill.style = "bitmap";
    fill.bitmapPath = sourceImageItemName;
    var matrix = fill.matrix;
    matrix.a = 20;
    matrix.d = 20;
    fill.matrix = matrix;

    document.setCustomFill(fill);

    var fillRect = {};
    fillRect.left = sourceRect.x;
    fillRect.top = sourceRect.y;
    fillRect.right = sourceRect.x + sourceRect.width;
    fillRect.bottom = sourceRect.y + sourceRect.height;


    fl.getDocumentDOM().addNewRectangle(fillRect, 0, false, true);
    fl.getDocumentDOM().selectAll();
    var element = fl.getDocumentDOM().selection[0];
    element.x = element.width * 0.5;
    element.y = element.height * 0.5;


    fl.getDocumentDOM().exitEditMode();


}


function getFrameItemByFrameName(document, frameName) {
    var frameItemList = getFrameItemList(document);
    var result, item;
    var currentFrameName;
    for (var i = 0; i < frameItemList.length; i++) {
        item = frameItemList[i];
        currentFrameName = getFrameNameFromItem(item);
        if (currentFrameName != frameName) continue;
        result = item;
        break;
    }

    return result;
}

function getFrameItemBySourceRect(document, sourceRect) {
    var frameItemList = getFrameItemList(document);
    var result, item;
    var currentSourceRect;
    var dx, dy, dWidth, dHeight;
    var maxDelta = 2;

    for (var i = 0; i < frameItemList.length; i++) {
        item = frameItemList[i];
        currentSourceRect = getFrameSourceRectangleFromItem(item);
        dx = Math.abs(currentSourceRect.x - sourceRect.x);
        dy = Math.abs(currentSourceRect.y - sourceRect.y);
        dWidth = Math.abs(currentSourceRect.width - sourceRect.width);
        dHeight = Math.abs(currentSourceRect.height - sourceRect.height);
        if (dx >= maxDelta) continue;
        if (dy >= maxDelta) continue;
        if (dWidth >= maxDelta) continue;
        if (dHeight >= maxDelta) continue;
        result = item;
        break;

    }

    return result
}


function getFrameItemName(frameName, sourceRect) {
    var result = frameFolderName + "/" + frameName + "::" + [sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height].join("_");
    return result;
}


function getFrameNameFromItem(item) {
    var result = item.name.split("/").pop();
    result = result.split("::");
    if (result.length > 1) {
        result.pop();
    }
    result = result.join("::");
    return result

}
function getFrameSourceRectangleFromItem(item) {
    var helper = item.name.split("::");
    helper = (helper.length > 0) ? helper[helper.length - 1] : null;
    helper = (helper) ? helper.split("_") : [];

    var result = {};
    if (helper.length == 4) {
        result.x = parseInt(helper[0]);
        result.y = parseInt(helper[1]);
        result.width = parseInt(helper[2]);
        result.height = parseInt(helper[3]);
    } else {
        result.x = 0;
        result.y = 0;
        result.width = 0;
        result.height = 0;
    }

    return result;

}


function getFrameItemList(document) {
    var library = document.library;
    var result = [];
    var currentItem;
    for (var i = 0; i < library.items.length; i++) {
        currentItem = library.items[i];
        if (currentItem.name.indexOf(frameFolderName) != 0) continue;
        if (currentItem.itemType != "movie clip") continue;
        result.push(currentItem);
    }
    return result;
}

function updateFrameItemsFromTileMap(document) {
    validateTileMap(document);

    var tileMapElementList = getTileMapFrameElements(document);
    var processedFrameItemList = [];
    var element, elementSourceRect, frameName;
    var library = document.library;
    var item;
    var defaultItemName = frameFolderName + "/frameItem";
    var appropriateItemName

    for (var i = 0; i < tileMapElementList.length; i++) {
        element = tileMapElementList[i];
        frameName = element.name;

        elementSourceRect = {};
        elementSourceRect.x = element.x;
        elementSourceRect.y = element.y;
        elementSourceRect.width = element.width;
        elementSourceRect.height = element.height;

        item = getFrameItemByFrameName(document, frameName);
        if (!item) {
            item = getFrameItemBySourceRect(document, elementSourceRect);
            fl.trace(frameName);

        }
        if (!item) {
            library.addNewItem("movie clip", defaultItemName)
            library.selectItem(defaultItemName, true);
            item = library.getSelectedItems()[0];
        }
        processedFrameItemList.push(item);
        reRenderFrameItem(document, item, elementSourceRect);
        appropriateItemName = getFrameItemName(frameName, elementSourceRect).split("/").pop();
        library.selectItem(item.name, true);
        library.renameItem(appropriateItemName);
    }

    var availableItemList = getFrameItemList(document);
    var index;
    for (i = 0; i < availableItemList.length; i++) {
        item = availableItemList[i];
        index = processedFrameItemList.indexOf(item);
        if (index >= 0) continue;
        if (!library.itemExists(item.name)) continue;
        library.deleteItem(item.name);
    }


}


function validateTileMap(document) {
    roundTileMapFrameElements(document)
    validateTileMapFrameElementsNames(document);
}


function roundTileMapFrameElements(document) {
    var tileMapElementList = getTileMapFrameElements(document);
    var currentElement;
    for (var i = 0; i < tileMapElementList.length; i++) {
        currentElement = tileMapElementList[i];
        currentElement.x = Math.round(currentElement.x);
        currentElement.y = Math.round(currentElement.y);
        currentElement.width = Math.round(currentElement.width);
        currentElement.height = Math.round(currentElement.height);
    }
}


function validateTileMapFrameElementsNames(document) {
    var tileMapElementList = getTileMapFrameElements(document);
    var reservedNameList = [];
    var elementWithInvalidNameList = [];
    var currentElement;
    for (var i = 0; i < tileMapElementList.length; i++) {
        currentElement = tileMapElementList[i];
        if ((reservedNameList.indexOf(currentElement.name) >= 0) || (!currentElement.name)) {
            elementWithInvalidNameList.push(currentElement);
        } else {
            reservedNameList.push(currentElement.name);
        }
    }

    var namePrefix;
    var appropriateName;
    for (i = 0; i < elementWithInvalidNameList.length; i++) {
        currentElement = elementWithInvalidNameList[i]
        namePrefix = (currentElement.name) ? currentElement.name : "frame";
        appropriateName = getUniqueName(reservedNameList, namePrefix);
        reservedNameList.push(appropriateName);
        currentElement.name = appropriateName;
    }


}

function addTileMapFrameItem(document, frameName, sourceRect) {
    var library = document.library;
    library.editItem(tileMapItemName);

    var timeline = fl.getDocumentDOM().getTimeline();
    timeline.setSelectedLayers(0, true);
    library.addItemToDocument({x: 0, y: 0}, frameItemName);
    var elements = timeline.layers[0].frames[0].elements;
    var element = elements[elements.length - 1];
    element.name = frameName;
    element.width = sourceRect.width;
    element.height = sourceRect.height;
    element.x = sourceRect.x;
    element.y = sourceRect.y;
}


function getTileMapFrameElementByName(document, frameName) {
    var elementList = getTileMapFrameElements(document);
    var result, element, currentFrameName
    for (var i = 0; i < elementList.length; j++) {
        element = elementList[j];
        if (element.name != frameName) continue;
        result = element;
        break;
    }
    return element;

}

function getTileMapFrameElements(document) {
    var tileMapItem = getTileMapItem(document);
    var elementList = getItemTimelineContent(tileMapItem);
    var result = [];
    var element;
    var libraryItem;
    for (var i = 0; i < elementList.length; i++) {
        element = elementList[i];
        libraryItem = element.libraryItem;
        if (!isFrame(libraryItem)) continue;
        result.push(element);
    }

    return result;
}

function getItemTimelineContent(item) {
    var result = []
    var timeline = item.timeline;
    var layer, frame, element;
    for (var i = 0; i < timeline.layers.length; i++) {
        layer = timeline.layers[i];
        for (var j = 0; j < layer.frames.length; j++) {
            frame = layer.frames[j];
            for (var k = 0; k < frame.elements.length; k++) {
                element = frame.elements[k];
                result.push(element)
            }
        }
    }
    return result

}


function createJointItem(document) {
    var library = document.library;
    library.addNewItem("movie clip", jointItemName);
    library.editItem(jointItemName);

    var fill = document.getCustomFill("toolbar");
    fill.color = "#00ff0077";
    document.setCustomFill(fill);
    fl.getDocumentDOM().addNewOval({left: -10, top: -10, right: 10, bottom: 10}, 0, false, true);
    fl.getDocumentDOM().exitEditMode();
}


function createTileMapItem(document) {
    var library = document.library;
    library.addNewItem("movie clip", tileMapItemName);
    library.editItem(tileMapItemName)

    var timeline = document.getTimeline();
    timeline.addNewLayer();

    timeline.setSelectedLayers(1, true);
    library.addItemToDocument({x: 0, y: 0}, sourceImageItemName);

    var element = timeline.layers[1].frames[0].elements[0]
    element.x = 0;
    element.y = 0;


    var layer = timeline.layers[1];
    layer.name = "source";
    layer.locked = true;

    layer = timeline.layers[0];
    layer.name = 'frames';

}

function importSourceImage(document) {
    var imageURI = document.pathURI;
    imageURI = imageURI.split(".");
    imageURI[imageURI.length - 1] = "png";
    imageURI = imageURI.join(".");

    document.importFile(imageURI, true);
    var imageName = imageURI.split("/").pop();
    var library = document.library;
    library.selectItem(imageName, true);
    library.renameItem(sourceImageItemName);

}

function getTileMapItem(document) {
    var result = getItemByName(document, tileMapItemName)
    return result;
}

function getFrameItem(document) {
    var result = getItemByName(document, frameItemName);
    return result
}

function getSourceImageItem(document) {
    var result = getItemByName(document, sourceImageItemName);
    return result;
}

function getItemByName(document, itemName) {
    var library = document.library;
    var item, result;
    for (var i = 0; i < library.items.length; i++) {
        item = library.items[i];
        if (item.name != itemName) continue;
        result = item;
        break;
    }
    return result;
}

function getUniqueName(reservedNameList, namePattern) {
    var counterReg = /_[0-9]+$/
    if (counterReg.test(namePattern)) {
        namePattern = namePattern.replace(counterReg, "");
    }
    var result = namePattern;
    var counter = 1;
    while (reservedNameList.indexOf(result) >= 0) {
        result = namePattern + "_" + counter;
        counter++;
    }
    return result;


}

function warning(message) {
    fl.trace("Warning " + message);
}


function getAnimationItemList(document) {
    var library = document.library;
    var item;
    var result = [];
    for (var i = 0; i < library.items.length; i++) {
        item = library.items[i];
        if (!isAnimation(item)) continue;
        result.push(item);
    }
    return result;

}
function getAnimationByName(document, animationName) {
    var animationList = getAnimationItemList(document);
    var currentAnimationName;
    var item, result;

    for (var i = 0; i < animationList.length; i++) {
        item = animationList[i];
        currentAnimationName = item.name.split("/").pop();
        if (currentAnimationName != animationName) continue;
        result = item;
        break;
    }

    return result;

}


function getAnimationDescription(item) {
    var result = <animation/>;
    result["@name"] = item.name.split("/").pop();
    result["@namePath"] = item.name;


    var timeline = item.timeline;
    var frames = timeline.layers[0].frames;
    var element, elements;
    var currentNode;
    for (var i = 0; i < frames.length; i++) {
        elements = frames[i].elements;
        if (!elements.length) continue;
        element = elements[0];
        currentNode = <frame/>;
        currentNode["@x"] = element.x;
        currentNode["@y"] = element.y;
        currentNode["@source"] = getFrameNameFromItem(element.libraryItem);

        result.appendChild(currentNode)
    }

    return result
}

function addAnimationsFromDescription(document, description) {
    var library = document.library;
    var elementList = (description) ? description.elements("animation") : null;
    var length = (elementList) ? elementList.length() : 0;
    var currentNode;
    var frameElementList, frameNode, framesAmount, frameName, frameItem, frameElement;
    var animationName;
    var itemName;

    var timeline;
    for (var i = 0; i < length; i++) {
        currentNode = elementList[i];
        animationName = currentNode["@name"] + "";
        itemName = currentNode["@namePath"] + "";
        library.addNewItem("movie clip", itemName);
        library.editItem(itemName);
        timeline = fl.getDocumentDOM().getTimeline();

        frameElementList = currentNode.elements("frame");
        framesAmount = (frameElementList) ? frameElementList.length() : 0;
        if (framesAmount > timeline.layers[0].frames.length) {
            timeline.insertFrames(framesAmount - timeline.layers[0].frames.length);
        }
        timeline.convertToBlankKeyframes(0, framesAmount);
        for (var j = 0; j < framesAmount; j++) {
            frameNode = frameElementList[j];
            frameName = frameNode["@source"] + "";
            frameItem = getFrameItemByFrameName(document, frameName);
            timeline.setSelectedFrames(j, j + 1, true);
            library.addItemToDocument({x: 0, y: 0}, frameItem.name);
            frameElement = timeline.layers[0].frames[j].elements[0];
            frameElement.x = parseInt(frameNode["@x"]);
            frameElement.y = parseInt(frameNode["@y"]);
        }


        fl.getDocumentDOM().exitEditMode();

    }
}

function getCompositionByName(document, compositionName) {
    var compositionList = getCompositionItemList(document);
    var currentCompositionName;
    var item;
    var result;
    for (var i = 0; i < compositionList.length; i++) {
        item = compositionList[i];
        currentCompositionName = item.name.split("/").pop();
        if (currentCompositionName != compositionName) continue;
        result = item;
        break;
    }
    return result;

}


function getCompositionItemList(document) {
    var library = document.library;
    var result = [];
    var item;
    for (var i = 0; i < library.items.length; i++) {
        item = library.items[i];
        if (!isComposition(item)) continue;
        result.push(item);

    }
    return result;
}


function getCompositionsDescription(document) {
    var result = <compositions/>;
    var compositionItemList = getCompositionItemList(document);
    var compositionItem;
    var timeline, layer, frame, element, libraryItem;
    var frameNode;
    var compositionNode, layerNode, elementNode;
    var elementType;
    for (var i = 0; i < compositionItemList.length; i++) {
        compositionItem = compositionItemList[i];
        timeline = compositionItem.timeline;

        compositionNode = <composition/>
        compositionNode["@name"] = compositionItem.name.split("/").pop();
        compositionNode["@namePath"] = compositionItem.name;
        compositionNode["@layerCount"] = timeline.layerCount;
        result.appendChild(compositionNode);

        for (var j = 0; j < timeline.layers.length; j++) {
            layer = timeline.layers[j];
            layerNode = <layer/>;
            layerNode["@name"] = layer.name;
            layerNode["@frameCount"] = layer.frameCount;

            compositionNode.appendChild(layerNode);

            for (var k = 0; k < layer.frames.length; k++) {
                frame = layer.frames[k];
                frameNode = <frame/>
                layerNode.appendChild(frameNode);
                for (var l = 0; l < frame.elements.length; l++) {
                    element = frame.elements[l];
                    libraryItem = element.libraryItem;
                    if (!libraryItem) continue;
                    if (isFrame(libraryItem)) {
                        elementType = compositionElementTypeFrame;
                    } else if (isAnimation(libraryItem)) {
                        elementType = compositionElementTypeAnimation;
                    } else if (isComposition(libraryItem)) {
                        elementType = compositionElementTypeComposition;
                    } else if (isJoint()) {
                        elementType = compositionElementTypeJoint;
                    } else {
                        continue;
                    }
                    elementNode = <element/>;
                    elementNode["@type"] = elementType;
                    elementNode["@source"] = libraryItem.name.split("/").pop();
                    elementNode["@name"] = element.name;
                    elementNode["@x"] = element.x;
                    elementNode["@y"] = element.y;

                    frameNode.appendChild(elementNode);


                }
            }
        }

    }


    return result;

}

function setCompositionsDescription(document, source) {
    var library = document.library;


    var elementList = (source) ? source.elements("composition") : null;
    var length = (elementList) ? elementList.length() : 0;
    var compositionNode;
    var compositionItemName;
    var timeline, layerCount;
    var layer, layerNode, frameCount;
    var frameNode
    var elementNode,elementList,elementAmount;


    for (var i = 0; i < length; i++) {
        compositionNode = elementList[i];
        compositionItemName = compositionNode["@namePath"] + "";
        library.addNewItem("movie clip", compositionItemName);
        library.editItem(compositionItemName);
        timeline = fl.getDocumentDOM().getTimeline();
        layerCount = compositionNode["@layerCount"];
        for (var j = 0; j < layerCount - 1; j++) {
            timeline.addNewLayer();
        }
        for (j = 0; j < layerCount; j++) {
            timeline.setSelectedLayers(j, true)
            layerNode = compositionNode.layer[j];
            layer = timeline.layers[j];
            layer.name = layerNode["@name"] + "";
            frameCount = layerNode["@frameCount"]
            if (frameCount > 1) {
                timeline.insertFrames(frameCount - 1, false);
            }

            for (var k = 0; k < frameCount; k++) {
                frameNode=layerNode.frame[k];
            }

        }


        fl.getDocumentDOM().exitEditMode();

    }
}


function isComposition(item) {
    var result = ((item.name.indexOf(compositionFolderName) == 0) && (item.itemType == "movie clip"));
    return result;
}
function isAnimation(item) {
    var result = ((item.name.indexOf(animationFolderName) == 0) && (item.itemType == "movie clip"));
    return result;
}


function isFrame(item) {
    var result = ((item.name.indexOf(frameItemName) == 0) && (item.itemType == "movie clip"));
    return result;
}

function isJoint(item) {
    var result = (item.name == jointItemName);
    return result;
}

function getJointItem(document) {
    var result = getItemByName(document, jointItemName);
    return result;
}