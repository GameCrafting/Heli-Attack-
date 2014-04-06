/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 05.04.14
 * Time: 17:05

 */
package com.common.resource.data {
import flash.utils.Dictionary;

public class ResourceReferenceGroup {

    static private const DEFAULT_SHARED_GROUP_ID:String="default_group";

    private var _resourceReferenceCountDictTaggedByResourceInstance:Dictionary;
    private var _resourceInstanceDict:Dictionary;
    private var _resourceIdDictTaggedByResourceInstance:Dictionary;


    public function ResourceReferenceGroup() {

        _resourceReferenceCountDictTaggedByResourceInstance=new Dictionary();
        _resourceInstanceDict=new Dictionary();
        _resourceIdDictTaggedByResourceInstance=new Dictionary();
    }
    public function containsResourceInstance(resourceId:String,resourceType:String,sharedGroupId:String=null):Boolean
    {
        var resourceInstance:Object=getResourceInstance(resourceId,resourceType,sharedGroupId);
        var result:Boolean=(resourceInstance!=null);
        return result;
    }

    public function saveResourceInstance(resourceId:String,resourceType:String,sharedGroupId:String,resource:Object):void
    {
        sharedGroupId=(sharedGroupId)?sharedGroupId:DEFAULT_SHARED_GROUP_ID;
        var key:String=getSharedResourceKey(resourceId,resourceType,sharedGroupId);
        _resourceInstanceDict[key]=resource;
        _resourceIdDictTaggedByResourceInstance[resource]=resourceId;
    }

    public function getResourceInstance(resourceId:String,resourceType:String,sharedGroupId:String=null):Object
    {
        sharedGroupId=(sharedGroupId)?sharedGroupId:DEFAULT_SHARED_GROUP_ID;
        var key:String=getSharedResourceKey(resourceId,resourceType,sharedGroupId);
        var result:Object=_resourceInstanceDict[key];
        return result;
    }
    public function removeResourceInstance(value:Object):void
    {
        for(var p:Object in _resourceInstanceDict){
            if(_resourceInstanceDict[p]!=value) continue;
            _resourceInstanceDict[p]=null;
            delete _resourceInstanceDict[p];
        }
        delete _resourceIdDictTaggedByResourceInstance[value];
        delete _resourceReferenceCountDictTaggedByResourceInstance[value];
    }

    public function getResourceIdByInstance(resource:Object):String
    {
        var result:String=(_resourceIdDictTaggedByResourceInstance[resource]!=undefined)?_resourceIdDictTaggedByResourceInstance[resource]:"";
        return result
    }

    public function getResourceReferenceCount(resource:Object):int
    {
        var result:int=(_resourceReferenceCountDictTaggedByResourceInstance[resource]!=undefined)?_resourceReferenceCountDictTaggedByResourceInstance[resource]:0;
        return result;

    }
    public function setResourceReferenceCount(resource:Object,count:int):void
    {
        _resourceReferenceCountDictTaggedByResourceInstance[resource]=count;
    }


    private function getSharedResourceKey(resourceId:String,resourceType:String,sharedGroupId:String):String
    {
        var result:String=sharedGroupId+"||"+resourceType+"||"+resourceId;
        return result;
    }


}
}
