/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 18:05

 */
package com.common.resource.service {
import avmplus.factoryXml;

import com.common.dataTypes.ListenerGroup;
import com.common.file.data.FileData;
import com.common.file.service.FileService;
import com.common.resource.api.IBitmapDataFactory;
import com.common.resource.api.IBitmapFactory;
import com.common.resource.api.ITextureAtlasFactory;
import com.common.resource.api.IXMLFactory;
import com.common.resource.data.ResourceLibraryData;
import com.common.resource.data.ResourceReferenceGroup;
import com.common.resource.data.ResourceType;
import com.common.resource.data.ResourceType;
import com.common.resource.data.factory.ResourceFactoryBase;
import com.common.resource.data.parser.ResourceMapParser;
import com.common.util.ListUtil;

import flash.display.Bitmap;

import flash.display.BitmapData;

import starling.textures.TextureAtlas;

public class ResourceService {

    [Inject]
    public var fileService:FileService;

    private var _resourceLibraryData:ResourceLibraryData;
    private var _resourceMapParser:ResourceMapParser;
    private var _resourceReferenceGroup:ResourceReferenceGroup;


    public function ResourceService() {
        _resourceLibraryData=new ResourceLibraryData();
        _resourceMapParser=new ResourceMapParser();
        _resourceReferenceGroup=new ResourceReferenceGroup();
    }

    public function saveResourceInfo(source:XML):void
    {
        _resourceMapParser.parse(source,this);
    }

    public function isResourceRegistered(resourceId:String):Boolean
    {
        var resourceFactory:ResourceFactoryBase=_resourceLibraryData.getResourceFactoryByResourceId(resourceId);
        var result:Boolean=(resourceFactory!=null);
        return result;
    }

    public function isResourceListLoadPerformed(resourceIdList:Array):Boolean
    {
        var result:Boolean=true;
        var length:int=ListUtil.getLength(resourceIdList);
        for(var i:int=0;i<length;i++){
            if(isResourceLoadPerformed(resourceIdList[i])) continue;
            result=false;
            break;
        }

        return result
    }

    public function isResourceLoadPerformed(resourceId:String):Boolean
    {
        var resourceFactory:ResourceFactoryBase=_resourceLibraryData.getResourceFactoryByResourceId(resourceId);
        var result:Boolean=((resourceFactory)&&(resourceFactory.isResourceLoadPerformed(resourceId)));
        return result;
    }

    public function isResourceListLoaded(resourceIdList:Array):Boolean
    {
        var result:Boolean=true;
        var length:int=ListUtil.getLength(resourceIdList);
        for(var i:int=0;i<length;i ++){
            if(isResourceLoaded(resourceIdList[i])) continue;
            result=false;
            break;
        }

        return result;
    }

    public function isResourceLoaded(resourceId:String):Boolean
    {
        var resourceFactory:ResourceFactoryBase=_resourceLibraryData.getResourceFactoryByResourceId(resourceId);
        var result:Boolean=((resourceFactory)&&(resourceFactory.isResourcesLoaded(resourceId)));
        return result;
    }

    public function loadResourceList(resourceIdList:Array,onComplete:Function=null,onCompletePostParams:Array=null):void
    {
        if(isResourceListLoadPerformed(resourceIdList)){
            if(onComplete!=null){
                ListenerGroup.notifyListener(onComplete,null,onCompletePostParams);
            }
            return;
        }
        if((onComplete!=null)&&(resourceIdList.length>0)){
           _resourceLibraryData.addResourceListLoadListener(resourceIdList,onComplete,onCompletePostParams);
        }
        var resourceId:String
        for(var i:int=0;i<resourceIdList.length;i++){
            resourceId=resourceIdList[i];
            loadResource(resourceId);
        }

    }


    public function loadResource(resourceId:String,onComplete:Function=null,onCompletePostParams:Array=null):void
    {
        if(!isResourceRegistered(resourceId)) return;
        if(isResourceLoadPerformed(resourceId)){
            if(isResourceLoaded(resourceId)){
                if(onComplete!=null){
                    ListenerGroup.notifyListener(onComplete,null,onCompletePostParams);
                }
            }
            return;
        }
        if(onComplete!=null){
           _resourceLibraryData.addResourceLoadListener(resourceId,onComplete,onCompletePostParams);
        }
        if(!_resourceLibraryData.isResourceLoadingActive(resourceId)){
            _resourceLibraryData.onResourceLoadingStarted(resourceId);
            var urlList:Array=_resourceLibraryData.getResourceURLList(resourceId);
            var fileTypeList:Array=_resourceLibraryData.getResourceFileTypeList(resourceId);
            fileService.loadFileList(urlList,fileTypeList,onResourceSourceFileListLoaded,[resourceId]);
        }
    }

    public function removeResourceListLoadListener(value:Function,withAnyPostParams:Boolean=true,postParams:Array=null):void
    {
        _resourceLibraryData.removeResourceListLoadListener(value,withAnyPostParams,postParams);
    }

    public function removeResourceLoadListener(value:Function,withAnyPostParams:Boolean=true,postParams:Array=null):void
    {
        _resourceLibraryData.removeResourceLoadListener(value,withAnyPostParams,postParams);
    }

    public function getXML(resourceId:String,sharedInstance:Boolean=false,sharedGroupId:String=null):XML
    {
        var resourceFactory:IXMLFactory=_resourceLibraryData.getResourceFactoryByResourceId(resourceId) as IXMLFactory;
        var result:XML=getResource(resourceId,sharedInstance,sharedGroupId,ResourceType.XML,resourceFactory.getXMLInstance) as XML;
        return result;
    }
    public function getBitmapData(resourceId:String,shareInstance:Boolean=true,sharedGroup:String=null):BitmapData
    {
        var resourceFactory:IBitmapDataFactory=_resourceLibraryData.getResourceFactoryByResourceId(resourceId) as IBitmapDataFactory;
        var result:BitmapData=getResource(resourceId,shareInstance,sharedGroup,ResourceType.BITMAP_DATA,resourceFactory.getBitmapDataInstance) as BitmapData;
        return result;
    }
    public function getBitmap(resourceId:String,shareInstance:Boolean=false,sharedGroup:String=null):Bitmap
    {
        var resourceFactory:IBitmapFactory=_resourceLibraryData.getResourceFactoryByResourceId(resourceId) as IBitmapFactory;
        var result:Bitmap=getResource(resourceId,shareInstance,sharedGroup,ResourceType.BITMAP,resourceFactory.getBitmapInstance) as Bitmap

        return result;
    }
    public function getTextureAtlas(resourceId:String,sharedInstance:Boolean=true,sharedGroup:String=null):TextureAtlas
    {
        var resourceFactory:ITextureAtlasFactory=_resourceLibraryData.getResourceFactoryByResourceId(resourceId) as ITextureAtlasFactory;
        var result:TextureAtlas=getResource(resourceId,sharedInstance,sharedGroup,ResourceType.TEXTURE_ATLAS,resourceFactory.getTextureAtlasInstance) as TextureAtlas;

        return result;
    }

    public function decreaseResourceReferenceCount(resource:Object):void
    {
        var referenceCount:int=_resourceReferenceGroup.getResourceReferenceCount(resource);
        if(referenceCount<=0) return;
        referenceCount--;
        _resourceReferenceGroup.setResourceReferenceCount(resource,referenceCount);
        if(!referenceCount){
            var resourceId:String=_resourceReferenceGroup.getResourceIdByInstance(resource);
            _resourceReferenceGroup.removeResourceInstance(resource);
            var resourceFactory:ResourceFactoryBase=_resourceLibraryData.getResourceFactoryByResourceId(resourceId);
            if(resourceFactory){
                resourceFactory.removeResource(resource)
            }


        }
    }

    private function getResource(resourceId:String,sharedInstance:Boolean,sharedGroupId:String,resourceType:String,resourceFactoryMethod:Function):Object
    {
        var result:Object;
        if((!sharedInstance)||(!_resourceReferenceGroup.containsResourceInstance(resourceId,resourceType,sharedGroupId))){
            result=resourceFactoryMethod(resourceId);
            if(sharedInstance){
                _resourceReferenceGroup.saveResourceInstance(resourceId,resourceType,sharedGroupId,result);
                _resourceReferenceGroup.setResourceReferenceCount(result,0);
            }
        }
        if(sharedInstance){
            result=_resourceReferenceGroup.getResourceInstance(resourceId,resourceType,sharedGroupId);
            var referenceCount:int=_resourceReferenceGroup.getResourceReferenceCount(resourceId);
            referenceCount++;
            _resourceReferenceGroup.setResourceReferenceCount(result,referenceCount);
        }
        return result;
    }


    private function onResourceSourceFileListLoaded(fileDataList:Vector.<FileData>,resourceId:String):void
    {
        var resourceFactory:ResourceFactoryBase=_resourceLibraryData.getResourceFactoryByResourceId(resourceId);
        if(resourceFactory){
            var resourceIdList:Array=_resourceLibraryData.getResourceIdListByContainedResourceId(resourceId);
            resourceFactory.saveSourceFilesForResources(resourceIdList,fileDataList);
        }
        _resourceLibraryData.onResourceLoaded(resourceId);
    }

    public function get resourceLibraryData():ResourceLibraryData {
        return _resourceLibraryData;
    }
}
}
