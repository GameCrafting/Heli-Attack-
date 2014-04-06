/**
 * Created by Wheeler on 27.03.2014.
 */
package com.startup.controller {
import com.common.command.CommandSequence;

public class ApplicationInitializationCommandSequence extends CommandSequence {
    public function ApplicationInitializationCommandSequence() {
        super();
    }


    override protected function startExecution():void {
        addCommand(InitializeLayerGroupCommand);
        addCommand(InitializeConfigurationModelCommand);
        addCommand(AdvanceStartUpPreLoaderStateCommand);
        addCommand(InitializeResourceManagerCommand);

        super.startExecution();

    }
}
}
