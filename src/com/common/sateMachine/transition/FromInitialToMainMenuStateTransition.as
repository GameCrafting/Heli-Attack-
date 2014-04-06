/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 10:40

 */
package com.common.sateMachine.transition {
import com.common.sateMachine.data.StateId;
import com.common.sateMachine.data.StateTransition;
import com.startup.controller.ApplicationInitializationCommandSequence;

public class FromInitialToMainMenuStateTransition extends StateTransition {

    public function FromInitialToMainMenuStateTransition() {
        super(StateId.INITIAL,StateId.MAIN_MENU,ApplicationInitializationCommandSequence);
    }

}
}
