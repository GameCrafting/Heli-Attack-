/**
 * Created by Wheeler on 27.03.2014.
 */
package com.startup.controller {
import org.robotlegs.mvcs.StarlingCommand;

public class InitializeResourceManagerCommand extends StarlingCommand{
    public function InitializeResourceManagerCommand() {
        super();
    }

    override public function execute():void {
        super.execute();
        trace(this);
    }
}
}
