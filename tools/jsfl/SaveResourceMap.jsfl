var params={}
params.sourceFolder="";
params.sourceFolderReplacement=""
params.resourceMapURI="";
params.atlasNodeName="atlas";
params.atlasImageNodeName="image";
params.atlasDescriptionNodeName="description";
params.xmlNodeName="xml";
params.idPropertyName="@id";
params.urlPropertyName="@url"




function saveResourceMap()
{
    var folderContent=getFolderContent(params.sourceFolder);

    var xmlFileReg=/\.xml$/i;
    var xmlFileList=[];
    extractElementsFromList(folderContent,xmlFileReg,xmlFileList);

    var imageFileReg=/\.(png|jpg|jpeg|gif)$/i;
    var imageFileList=[];
    extractElementsFromList(folderContent,imageFileReg,imageFileList);
    createNotExistingDescriptionFilesForImages(imageFileList,xmlFileList);


    applySourceFolderReplacement(imageFileList);
    applySourceFolderReplacement(xmlFileList);

    var result=<resourceMap/>;
    createAtlasesResourceMapDescription(imageFileList,xmlFileList,result);
    createXMLResourceMapDescription(xmlFileList,result);


    if(FLfile.exists(params.resourceMapURI)){
        FLfile.remove(params.resourceMapURI);
    }

    FLfile.write(params.resourceMapURI,result);




}

function applySourceFolderReplacement(sourceList)
{
    for(var i=0;i<sourceList.length;i++){
        sourceList[i]=sourceList[i].replace(params.sourceFolder,params.sourceFolderReplacement);
    }

}

function createXMLResourceMapDescription(xmlFileList,resultDescription)
{
    resultDescription=(resultDescription)?resultDescription:<data/>;
    var currentNode,xmlURI,xmlId;
    for(var i=0;i<xmlFileList.length;i++){
        xmlURI=xmlFileList[i];
        xmlId=xmlURI.split("/").pop();
        xmlId=xmlId.split(".");
        xmlId=xmlId.slice(0,xmlId.length-1).join(".");
        currentNode=<data/>;
        currentNode.setName(params.xmlNodeName);
        currentNode[params.idPropertyName]=xmlId;
        currentNode[params.urlPropertyName]=xmlURI;

        resultDescription.appendChild(currentNode);
    }

}

function createAtlasesResourceMapDescription(imageFileList,xmlFileList,resultDescription)
{
    resultDescription=(resultDescription)?resultDescription:<data/>;
    var imageURI,atlasName,atlasFolder;
    var index,xmlURI
    var atlasDescription;
    var childNode;

    for(var i=0;i<imageFileList.length;i++){
        imageURI=imageFileList[i]
        imageFileList.splice(i,1);
        i--;

        atlasName=getAtlasNameByComponentURI(imageURI);
        atlasFolder=getAtlasFolderByComponentURI(imageURI);

        index=getComponentIndexByAtlasName(xmlFileList,atlasName,atlasFolder)
        xmlURI=xmlFileList[index];
        xmlFileList.splice(index,1);


        atlasDescription=<data/>
        atlasDescription.setName(params.atlasNodeName);
        atlasDescription[params.idPropertyName]=atlasName;

        childNode=<data/>;
        childNode.setName(params.atlasImageNodeName);
        childNode[params.urlPropertyName]=imageURI;
        atlasDescription.appendChild(childNode);

        childNode=<data/>;
        childNode.setName(params.atlasDescriptionNodeName);
        childNode[params.urlPropertyName]=xmlURI;
        atlasDescription.appendChild(childNode);

        resultDescription.appendChild(atlasDescription);

    }

}




function createNotExistingDescriptionFilesForImages(imageFileList,xmlFileList)
{
    var imageURI,atlasFolder,atlasName,xmlURI;
    var processQueueXmlUriList=[];
    var processQueueImageUriList=[];

    for(var i=0;i<imageFileList.length;i++){
        imageURI=imageFileList[i];
        atlasFolder=getAtlasFolderByComponentURI(imageURI);
        atlasName=getAtlasNameByComponentURI(imageURI);
        xmlURI=atlasFolder+"/"+atlasName+".xml";
        if(xmlFileList.indexOf(xmlURI)>=0) continue;
        if(FLfile.exists(xmlURI)) continue;
        xmlFileList.push(xmlURI);
        processQueueImageUriList.push(imageURI);
        processQueueXmlUriList.push(xmlURI);

    }

    if(!processQueueImageUriList.length) return;
    var document=fl.createDocument("timeline");
    var library=document.library;
    var imageItem,imageElement;
    var imageDescription,imageName,childNode;

    for(var i=0;i<processQueueImageUriList.length;i++){
       imageURI=processQueueImageUriList[i];
       imageName=imageURI.split("/").pop();
       xmlURI=processQueueXmlUriList[i];
       document.importFile(imageURI);
       imageItem=library.items[0];
       document.selectAll();
       imageElement=document.selection[0];

       childNode=<SubTexture/>
       childNode["@name"]=getAtlasNameByComponentURI(imageURI);
       childNode["@x"]=0;
       childNode["@y"]=0;
       childNode["@width"]=imageElement.width;
       childNode["@height"]=imageElement.height;

       imageDescription=<TextureAtlas />;
       imageDescription["@imagePath"]=imageName;
       imageDescription.appendChild(childNode);

       library.selectAll();
       library.deleteItem();

       imageDescription=imageDescription.toXMLString();
       FLfile.write(xmlURI,imageDescription);


    }


    document.close(false);
}

function getComponentIndexByAtlasName(componentList,atlasName,atlasFolder)
{
    var result=-1;
    var currentAtlasName,currentAtlasFolder
    for(var i=0;i<componentList.length;i++){
        currentAtlasFolder=getAtlasFolderByComponentURI(componentList[i]);
        if(currentAtlasFolder!=atlasFolder) continue;
        currentAtlasName=getAtlasNameByComponentURI(componentList[i]);
        if(currentAtlasName!=atlasName) continue;
        result=i;
        break;

    }
    return result;
}



function getAtlasNameByComponentURI(componentURI)
{
    var result=componentURI.split("/").pop();
    result=result.split(".");
    result.pop();
    result=result.join(".");

    return result;
}

function getAtlasFolderByComponentURI(componentURI)
{
    var result=componentURI.split("/");
    result.pop();
    result=result.join("/");

    return result;
}



function extractElementsFromList(sourceList,testRegExp,resultList)
{
    resultList=(resultList)?resultList:[];
    var currentElement;
    for(var i=0;i<sourceList.length;i++){
       currentElement=sourceList[i];
       if(!testRegExp.test(currentElement)) continue;
       resultList.push(currentElement);
       sourceList.splice(i,1);
       i--;
    }
    return resultList;
}



function getFolderContent(pathURI)
{
    var result=[];
    if((!pathURI)||(!FLfile.exists(pathURI))) return result;
    var attributes=FLfile.getAttributes(pathURI);
    var isFolder=(attributes.indexOf("D")>=0);
    if(isFolder){
        var listFolder=FLfile.listFolder(pathURI);
        var childFileURI
        for(var i=0;i<listFolder.length;i++){
            childFileURI=pathURI+"/"+listFolder[i];
            result=result.concat(getFolderContent(childFileURI));
        }
    }else{
        result.push(pathURI);
    }

    return result;




}


