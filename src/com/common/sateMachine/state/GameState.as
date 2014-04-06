/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 10:35

 */
package com.common.sateMachine.state {
import com.common.sateMachine.data.StateBase;
import com.common.sateMachine.data.StateId;

public class GameState extends StateBase {
    public function GameState() {
        super(StateId.GAME);
    }
}
}
