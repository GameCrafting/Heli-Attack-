/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 18:21

 */
package com.common.resource.data {
import com.common.dataTypes.ListenerGroup;
import com.common.file.data.FileData;
import com.common.resource.data.factory.ResourceFactoryBase;
import com.common.resource.data.factory.TextureAtlasBasedFactory;
import com.common.resource.data.factory.XMLBasedResourceFactory;
import com.common.util.ListUtil;

import flash.utils.Dictionary;

import starling.utils.formatString;

public class ResourceLibraryData {


    private var _resourceIdListDictTaggedByResourceId:Dictionary
    private var _fileURLListDictTaggedByResourceIdList:Dictionary;
    private var _fileTypeListDictTaggedByResourceIdList:Dictionary;
    private var _resourceFactoryTypeDictTaggedByResourceIdList:Dictionary;
    private var _resourceFactoryTaggedByFactoryType:Dictionary;
    private var _resourceLoadingStateDictTaggedByResourceIdList:Dictionary;
    private var _resourceLoadingListenerGroupDictTaggedByResourceIdList:Dictionary;
    private var _resourceListLoadingListenerGroupDict:Dictionary




    public function ResourceLibraryData() {

        _resourceIdListDictTaggedByResourceId=new Dictionary()
        _fileURLListDictTaggedByResourceIdList=new Dictionary();
        _fileTypeListDictTaggedByResourceIdList=new Dictionary();
        _resourceFactoryTypeDictTaggedByResourceIdList=new Dictionary();
        _resourceFactoryTaggedByFactoryType=new Dictionary();

        _resourceLoadingStateDictTaggedByResourceIdList=new Dictionary();
        _resourceLoadingListenerGroupDictTaggedByResourceIdList=new Dictionary();

        _resourceListLoadingListenerGroupDict=new Dictionary();

        addResourceFactory(TextureAtlasBasedFactory);
        addResourceFactory(XMLBasedResourceFactory);
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
    public function isResourceLoadingActive(resourceId:String):Boolean
    {
        var resourceIdList:Array=getResourceIdListByContainedResourceId(resourceId);
        var result:Boolean=_resourceLoadingStateDictTaggedByResourceIdList[resourceId];
        return result;
    }
    public function onResourceLoadingStarted(resourceId:String):void
    {
        var resourceIdList:Array=getResourceIdListByContainedResourceId(resourceId);
        _resourceLoadingStateDictTaggedByResourceIdList[resourceIdList]=true;
    }
    public function addResourceListLoadListener(resourceIdList:Array,value:Function,postParams:Array):void
    {
        var key:String=getResourceListLoadKey(resourceIdList);
        var listenerGroup:ListenerGroup=_resourceListLoadingListenerGroupDict[key];
        if(!listenerGroup){
            listenerGroup=new ListenerGroup();
            _resourceListLoadingListenerGroupDict[key]=listenerGroup;
        }
        listenerGroup.addListener(value,postParams);
    }

    public function addResourceLoadListener(resourceid:String,value:Function,postParams:Array):void
    {
        var resourceIdList:Array=getResourceIdListByContainedResourceId(resourceid);
        var listenerGroup:ListenerGroup=_resourceLoadingListenerGroupDictTaggedByResourceIdList[resourceIdList];
        if(!listenerGroup){
            listenerGroup=new ListenerGroup();
            _resourceLoadingListenerGroupDictTaggedByResourceIdList[resourceIdList]=listenerGroup;
        }
        listenerGroup.addListener(value,postParams);
    }

    public function removeResourceListLoadListener(value:Function,withAnyPostParams:Boolean=true,postParams:Array=null):void
    {
        for each(var listenerGroup:ListenerGroup in _resourceListLoadingListenerGroupDict){
            if(withAnyPostParams){
                listenerGroup.removeListener(value);
            }else{
                listenerGroup.removeListenerWithPostParams(value,postParams);
            }
        }
    }

    public function removeResourceLoadListener(value:Function,withAnyPostParams:Boolean=true,postParams:Array=null):void
    {
        for each(var listenerGroup:ListenerGroup in _resourceLoadingListenerGroupDictTaggedByResourceIdList){
            if(withAnyPostParams){
                listenerGroup.removeListener(value);
            }else{
                listenerGroup.removeListenerWithPostParams(value,postParams);
            }
        }
    }


    public function onResourceLoaded(resourceId:String):void
    {
        var resourceIdList:Array=getResourceIdListByContainedResourceId(resourceId);

        _resourceLoadingStateDictTaggedByResourceIdList[resourceIdList]=undefined;
        delete _resourceLoadingStateDictTaggedByResourceIdList[resourceIdList];

        var listenerGroup:ListenerGroup=_resourceLoadingListenerGroupDictTaggedByResourceIdList[resourceIdList];
        _resourceLoadingListenerGroupDictTaggedByResourceIdList[resourceIdList]=undefined;
        delete _resourceLoadingListenerGroupDictTaggedByResourceIdList[resourceIdList];
        if(listenerGroup){
            listenerGroup.notify();
            listenerGroup.destroy();
        }

        for(var resourceListLoadKey:String in _resourceListLoadingListenerGroupDict){
            if(!isResourceListWithKeyLoadPerformed(resourceListLoadKey)) continue;
            listenerGroup=_resourceListLoadingListenerGroupDict[resourceListLoadKey];
            listenerGroup.notify();
            listenerGroup.destroy();
            _resourceListLoadingListenerGroupDict[resourceListLoadKey]=null;
            delete _resourceListLoadingListenerGroupDict[resourceListLoadKey];
        }


    }


    private function getResourceListLoadKey(resourceIdList:Array):String
    {
        var length:int=ListUtil.getLength(resourceIdList);
        var resourceIdGroupList:Array=[];
        var resourceIdGroup:Array;
        for(var i:int=0;i<length;i++){
            resourceIdGroup=getResourceIdListByContainedResourceId(resourceIdList[i]);
            if(resourceIdGroupList.indexOf(resourceIdGroup)>=0) continue;
            resourceIdGroupList.push(resourceIdGroup);

        }
        var helper:Array=[];
        for (i = 0;i<resourceIdGroupList.length;i++){
            resourceIdGroup=resourceIdGroupList[i];
            if(!resourceIdGroup.length) continue;
            helper=helper.concat(resourceIdGroup[0]);
        }
        helper.sort();
        var result:String=helper.join(",");
        return result;
    }

    private function isResourceListWithKeyLoadPerformed(listKey:String):Boolean
    {
        var resourceIList:Array=listKey.split(",");
        var result:Boolean=true;
        var resourceId:String;
        var resourceFactory:ResourceFactoryBase
        for(var i:int=0;i<resourceIList.length;i++){
            resourceId=resourceIList[i];
            resourceFactory=getResourceFactoryByResourceId(resourceId);
            if((resourceFactory)&&(resourceFactory.isResourceLoadPerformed(resourceId))) continue;
            result=false;
            break;
        }

        return result;
    }
}
}
