/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 13:18

 */
package com.root {
import org.robotlegs.mvcs.StarlingMediator;

import starling.animation.Juggler;

import starling.core.Starling;

public class RootScreenMediator extends StarlingMediator {

    [Inject]
    public var view:RootScreen;
    [Inject]
    public var starling:Starling;
    [Inject]
    public var juggler:Juggler;

    public function RootScreenMediator() {
        super();
    }

    override public function onRegister():void {
        starling.start();

    }
}
}
