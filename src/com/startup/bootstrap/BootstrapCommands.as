/**
 * Created by Wheeler on 27.03.2014.
 */
package com.startup.bootstrap {
import com.startup.controller.ApplicationInitializationCommandSequence;

import org.robotlegs.base.ContextEvent;
import org.robotlegs.core.ICommandMap;

public class BootstrapCommands {
    public function BootstrapCommands(commandMap:ICommandMap) {

        commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE,ApplicationInitializationCommandSequence,ContextEvent,true);
    }
}
}
