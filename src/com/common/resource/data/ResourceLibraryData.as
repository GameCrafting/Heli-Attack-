/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 18:21

 */
package com.common.resource.data {
import com.common.file.data.FileData;
import com.common.resource.data.factory.ResourceFactoryBase;
import com.common.resource.data.factory.TextureAtlasBasedFactory;

import flash.utils.Dictionary;

public class ResourceLibraryData {


    private var _resourceIdListDictTaggedByResourceId:Dictionary
    private var _fileURLListDictTaggedByResourceIdList:Dictionary;
    private var _fileTypeListDictTaggedByResourceIdList:Dictionary;
    private var _resourceFactoryTypeDictTaggedByResourceIdList:Dictionary;
    private var _resourceFactoryTaggedByFactoryType:Dictionary;




    public function ResourceLibraryData() {

        _resourceIdListDictTaggedByResourceId=new Dictionary()
        _fileURLListDictTaggedByResourceIdList=new Dictionary();
        _fileTypeListDictTaggedByResourceIdList=new Dictionary();
        _resourceFactoryTypeDictTaggedByResourceIdList=new Dictionary();
        _resourceFactoryTaggedByFactoryType=new Dictionary();

        addResourceFactory(TextureAtlasBasedFactory);
    }

    public function addResourceFactory(factoryClass:Class):void
    {
        var resourceFactory:ResourceFactoryBase=new factoryClass();
        _resourceFactoryTaggedByFactoryType[resourceFactory.type]=resourceFactory;
    }

    public function addResourceInfo(resourceIdList:Array,fileURLList:Array,fileTypeList:Array,factoryType:String):void
    {
        var currentResourceId:String;
        for(var i:int=0;i<resourceIdList.length;i++){
            currentResourceId=resourceIdList[i];
            _resourceIdListDictTaggedByResourceId[currentResourceId]=resourceIdList;
        }
        _fileURLListDictTaggedByResourceIdList[resourceIdList]=fileURLList;
        _fileTypeListDictTaggedByResourceIdList[resourceIdList]=fileTypeList;
        _resourceFactoryTypeDictTaggedByResourceIdList[resourceIdList]=factoryType;

    }

    public function getResourceIdListByContainedResourceId(resourceId:String):Array
    {
        var result:Array=_resourceIdListDictTaggedByResourceId[resourceId];
        return result;
    }

    public function getResourceURLList(resourceId:String):Array
    {
        var resourceIdList:Array=getResourceIdListByContainedResourceId(resourceId);
        var result:Array=_fileURLListDictTaggedByResourceIdList[resourceIdList];

        return result;
    }
    public function getResourceFileTypeList(resourceId:String):Array
    {
        var resourceIdList:Array=getResourceIdListByContainedResourceId(resourceId);
        var result:Array=_fileTypeListDictTaggedByResourceIdList[resourceIdList];
        return result;
    }
    public function getResourceFactoryByFactoryType(factoryType:String):ResourceFactoryBase
    {
        var result:ResourceFactoryBase=_resourceFactoryTaggedByFactoryType[factoryType];
        return result;
    }

    public function getResourceFactoryByResourceId(resourceId:String):ResourceFactoryBase
    {
        var resourceIdList:Array=_resourceIdListDictTaggedByResourceId[resourceId];
        var factoryType:String=_resourceFactoryTypeDictTaggedByResourceIdList[resourceIdList];
        var resourceFactory:ResourceFactoryBase=getResourceFactoryByFactoryType(factoryType);
        return resourceFactory;
    }

}
}
