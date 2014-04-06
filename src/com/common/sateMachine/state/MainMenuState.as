/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 10:33

 */
package com.common.sateMachine.state {
import com.common.sateMachine.data.StateBase;
import com.common.sateMachine.data.StateId;

public class MainMenuState extends StateBase {
    public function MainMenuState() {
        super(StateId.MAIN_MENU);
    }
}
}
