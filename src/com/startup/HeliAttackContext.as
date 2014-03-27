/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 25.03.14
 * Time: 22:41
 * To change this template use File | Settings | File Templates.
 */
package com.startup {
import com.startup.bootstrap.BootstrapCommands;
import com.startup.bootstrap.BootstrapValues;

import org.robotlegs.mvcs.StarlingContext;

import starling.core.Starling;

import starling.display.DisplayObjectContainer;

public class HeliAttackContext extends StarlingContext {


    public var heliAttack:HeliAttack;
    public var starling:Starling



    public function HeliAttackContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true) {
        super(contextView, autoStartup);
    }


    override public function startup():void {

        new BootstrapValues(this,injector);
        new BootstrapCommands(commandMap)
        super.startup();
    }
}
}
