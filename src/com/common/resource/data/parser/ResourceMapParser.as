/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 18:09

 */
package com.common.resource.data.parser {
import com.common.file.data.FileType;
import com.common.resource.data.factory.ResourceFactoryType;
import com.common.resource.service.ResourceService;
import com.common.util.ParseUtil;

import flash.utils.Dictionary;

public class ResourceMapParser {

    static private const NODE_NAME_ATLAS:String='atlas';
    static private const NODE_NAME_XML:String="xml";
    static private const NODE_NAME_ATLAS_IMAGE:String="image";
    static private const NODE_NAME_ATLAS_DESCRIPTION:String="description"
    static private const PROPERTY_NAME_ID:String="@id";
    static private const PROPERTY_NAME_URL:String="@url"


    private var _parseNodeMethodDict:Dictionary

    public function ResourceMapParser() {
        _parseNodeMethodDict=new Dictionary();
        _parseNodeMethodDict[NODE_NAME_ATLAS]=parseAtlasNode;
        _parseNodeMethodDict[NODE_NAME_XML]=parseXMLNode;
    }

    public function parse(source:XML,resourceService:ResourceService):void
    {
        var nodeList:XMLList=(source)?source.elements():null;
        var length:int=(nodeList)?nodeList.length():0;
        var currentNode:XML,currentNodeName:String,currentParseNodeMethod:Function;
        for(var i:int=0;i<length;i++){
            currentNode=nodeList[i];
            currentNodeName=currentNode.name();
            currentParseNodeMethod=_parseNodeMethodDict[currentNodeName];
            if(!currentParseNodeMethod) continue;
            currentParseNodeMethod(currentNode,resourceService);

        }

    }


    private function parseAtlasNode(sourceNode:XML,resourceService:ResourceService):void
    {
        var resourceId:String=ParseUtil.readString(sourceNode,PROPERTY_NAME_ID);
        var imageURL:String=ParseUtil.readChildNodeString(sourceNode,NODE_NAME_ATLAS_IMAGE,0,PROPERTY_NAME_URL);
        var descriptionURL:String=ParseUtil.readChildNodeString(sourceNode,NODE_NAME_ATLAS_DESCRIPTION,0,PROPERTY_NAME_URL);

        var resourceIdList:Array=[resourceId];
        var fileURLList:Array=[imageURL,descriptionURL];
        var fileTypeList:Array=[FileType.MEDIA,FileType.TEXT];

        resourceService.resourceLibraryData.addResourceInfo(resourceIdList,fileURLList,fileTypeList,ResourceFactoryType.TEXTURE_ATLAS_SOURCE_BASED);

    }

    private function parseXMLNode(nodeSource:XML,resourceService:ResourceService):void
    {
        var resourceId:String=ParseUtil.readString(nodeSource,PROPERTY_NAME_ID);
        var fileURL:String=ParseUtil.readString(nodeSource,PROPERTY_NAME_URL);

        var resourceIdList:Array=[resourceId];
        var fileURLList:Array=[fileURL];
        var fileTypeList:Array=[FileType.TEXT];

        resourceService.resourceLibraryData.addResourceInfo(resourceIdList,fileURLList,fileTypeList,ResourceFactoryType.XML_SOURCE_BASED);

    }
}
}
