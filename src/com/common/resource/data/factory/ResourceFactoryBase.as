/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 20:40

 */
package com.common.resource.data.factory {
import com.common.file.data.FileData;

import flash.utils.Dictionary;

public class ResourceFactoryBase {

    private var _type:String;
    private var _fileDataDictTaggedByResourceId:Dictionary;
    private var _resourceLoadedStateDictTaggedByResourceId:Dictionary;
    private var _sourceDict:Dictionary

    public function ResourceFactoryBase(type:String) {
        _type=type;
        _fileDataDictTaggedByResourceId=new Dictionary();
        _resourceLoadedStateDictTaggedByResourceId=new Dictionary();
        _sourceDict=new Dictionary();

    }

    public function get type():String {
        return _type;
    }

    public function saveSourceFilesForResources(resourceIList:Array,fileDataList:Vector.<FileData>):void
    {
        var resourceLoaded:Boolean=true;
        for(var i:int=0;i<fileDataList.length;i++){
            if(!fileDataList[i].failedToLoad) continue;
            resourceLoaded=false;
            break;
        }


        var resourceId:String;
        for(i=0;i<resourceIList.length;i++){
            resourceId=resourceIList[i];
            _fileDataDictTaggedByResourceId[resourceId]=fileDataList
            _resourceLoadedStateDictTaggedByResourceId[resourceId]=resourceLoaded;
        }
    }
    public function getSourceFilesByResourceId(resourceId:String):Vector.<FileData>
    {
        var result:Vector.<FileData>=_fileDataDictTaggedByResourceId[resourceId];
        return result;
    }

    public function isResourceLoadPerformed(resourceId:String):Boolean
    {
        var fileDataList:Vector.<FileData>=getSourceFilesByResourceId(resourceId);
        var result:Boolean=(fileDataList!=null);
        return result;
    }

    public function isResourcesLoaded(resourceId:String):Boolean
    {
        var result:Boolean=_resourceLoadedStateDictTaggedByResourceId[resourceId];
        return result;
    }
    public function removeResource(value:Object):void
    {

    }

    protected function saveSource(key:String,value:Object):void
    {
       _sourceDict[key]=value;
    }
    protected function getSource(key:String):Object
    {
        var result:Object=_sourceDict[key];
        return result;
    }


}
}
