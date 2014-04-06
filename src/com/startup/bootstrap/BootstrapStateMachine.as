/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 10:28

 */
package com.startup.bootstrap {
import com.common.sateMachine.StateMachine;
import com.common.sateMachine.data.StateId;
import com.common.sateMachine.state.GameState;
import com.common.sateMachine.state.InitialState;
import com.common.sateMachine.state.MainMenuState;
import com.common.sateMachine.transition.FromInitialToMainMenuStateTransition;

import org.robotlegs.core.IInjector;

public class BootstrapStateMachine {


    public function BootstrapStateMachine(injector:IInjector) {

        injector.mapSingleton(StateMachine);
        var stateMachine:StateMachine=injector.getInstance(StateMachine);
        var stateTypeList:Array=[InitialState,MainMenuState,GameState];

        var currentStateType:Class;
        for(var i:int=0;i<stateTypeList.length;i++){
            currentStateType=stateTypeList[i];
            stateMachine.createState(currentStateType);
        }

        stateMachine.changeActiveState(StateId.INITIAL);

        var stateTransitionTypeList:Array=[FromInitialToMainMenuStateTransition];
        var currentStateTransitionType:Class;

        for(i = 0;i<stateTransitionTypeList.length;i++){
            currentStateTransitionType=stateTransitionTypeList[i];
            stateMachine.createTransition(currentStateTransitionType);
        }





    }
}
}
