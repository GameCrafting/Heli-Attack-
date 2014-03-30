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

    public function ResourceFactoryBase(type:String) {
        _type=type;
        _fileDataDictTaggedByResourceId=new Dictionary();

    }

    public function get type():String {
        return _type;
    }

    public function saveSourceFilesForResources(resourceIList:Array,fileDataList:Vector.<FileData>):void
    {
        var resourceId:String;
        for(var i:int=0;i<resourceIList.length;i++){
            resourceId=resourceIList[i];
            _fileDataDictTaggedByResourceId[resourceId]=fileDataList

        }
    }
    public function getSourceFilesByResourceId(resourceId:String):Vector.<FileData>
    {
        var result:Vector.<FileData>=_fileDataDictTaggedByResourceId[resourceId];
        return result;
    }


    public function containsSourceFilesForResource(resourceId:String):Boolean
    {
        var fileDataList:Vector.<FileData>=getSourceFilesByResourceId(resourceId);
        var result:Boolean=(fileDataList!=null);
        return result
    }
}
}
