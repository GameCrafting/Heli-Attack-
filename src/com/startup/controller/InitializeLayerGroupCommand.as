/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 12:05

 */
package com.startup.controller {
import com.root.RootScreen;
import com.common.layer.LayerGroup;
import com.common.layer.LayerName;

import org.robotlegs.mvcs.StarlingCommand;

public class InitializeLayerGroupCommand extends StarlingCommand {

    [Inject]
    public var layerGroup:LayerGroup;
    [Inject]
    public  var rootScreen:RootScreen

    public function InitializeLayerGroupCommand() {
        super();
    }


    override public function execute():void {
        rootScreen.layerGroup=layerGroup;
        layerGroup.init(rootScreen);
        var layerList:Array=[LayerName.LOCATION,LayerName.INTERFACE,LayerName.POPUP,LayerName.PRE_LOADER];
        var layerName:String;
        for(var i:int=0;i<layerList.length;i++){
            layerName=layerList[i];
            layerGroup.addLayer(layerName);
        }


    }
}
}
