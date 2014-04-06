/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 11:51

 */
package com.common.layer {
import com.root.RootScreen;

import flash.utils.Dictionary;

import starling.display.Sprite;

public class LayerGroup {

    private var _rootScreen:RootScreen;
    private var _layerDict:Dictionary;
    private var _layerList:Vector.<Sprite>



    public function LayerGroup() {
        _layerDict=new Dictionary();
        _layerList=new Vector.<Sprite>();
    }

    public function init(rootScreen:RootScreen):void
    {
        _rootScreen=rootScreen;
    }

    public function getLayerByName(value:String):Sprite
    {
        var result:Sprite=_layerDict[value];
        return result;
    }

    public function addLayer(layerName:String):Sprite
    {
        var result:Sprite=getLayerByName(layerName);
        if(result) return result;
        result=new Sprite();
        result.name=layerName;

        _rootScreen.addChild(result);
        _layerDict[layerName]=result;
        _layerList.push(result);

        return result
    }

}
}
