/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 10:46

 */
package com.startup.controller {
import com.common.sateMachine.StateMachine;
import com.common.sateMachine.data.StateId;

import org.robotlegs.mvcs.StarlingCommand;

public class StartApplicationCommand extends StarlingCommand {

    [Inject]
    public var stateMachine:StateMachine;

    public function StartApplicationCommand() {
        super();
    }

    override public function execute():void {
        stateMachine.changeActiveState(StateId.MAIN_MENU);
    }
}
}
