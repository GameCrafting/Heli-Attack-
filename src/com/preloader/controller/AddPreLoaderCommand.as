/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 13:52

 */
package com.preloader.controller {
import com.common.layer.LayerGroup;
import com.common.layer.LayerName;
import com.preloader.model.PreLoaderModel;
import com.preloader.view.PreLoaderView;

import org.robotlegs.mvcs.StarlingCommand;

import starling.display.Sprite;

public class AddPreLoaderCommand extends StarlingCommand {

    [Inject]
    public var layerGroup:LayerGroup;
    [Inject]
    public var preLoaderModel:PreLoaderModel;

    public function AddPreLoaderCommand() {
        super();
    }

    override public function execute():void {
        var preLoaderView:PreLoaderView=new PreLoaderView();
        var layer:Sprite=layerGroup.getLayerByName(LayerName.PRE_LOADER);
        layer.addChild(preLoaderView);

    }
}
}
