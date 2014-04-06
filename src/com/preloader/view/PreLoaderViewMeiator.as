/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 13:20

 */
package com.preloader.view {
import org.robotlegs.mvcs.StarlingMediator;

public class PreLoaderViewMeiator extends StarlingMediator {
    public function PreLoaderViewMeiator() {
        super();
    }

    override public function onRegister():void {
        trace(this);
    }
}
}
