/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 18:27

 */
package com.common.resource.data {
import flash.utils.Dictionary;

public class ResourceDefinitionBase {

    private var _resourceIdList:Array
    protected var _resourceURLListDict:Dictionary
    protected var _resourceFileTypeListDict:Dictionary;



    public function ResourceDefinitionBase() {
    }


    public function get resourceIdList():Array {
        return _resourceIdList;
    }
}


}
