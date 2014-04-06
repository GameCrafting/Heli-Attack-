/**
 * Created by Wheeler on 27.03.2014.
 */
package com.startup.bootstrap {
import com.preloader.controller.AddPreLoaderCommand;
import com.preloader.event.PreLoaderEvent;
import com.startup.controller.ApplicationInitializationCommandSequence;
import com.startup.controller.StartApplicationCommand;

import org.robotlegs.base.ContextEvent;
import org.robotlegs.core.ICommandMap;

public class BootstrapCommands {
    public function BootstrapCommands(commandMap:ICommandMap) {

        commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE,StartApplicationCommand,ContextEvent,true);
        commandMap.mapEvent(PreLoaderEvent.PRE_LOADING_STARTED,AddPreLoaderCommand,PreLoaderEvent);
    }
}
}
