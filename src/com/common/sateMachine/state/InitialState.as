/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 10:32

 */
package com.common.sateMachine.state {
import com.common.sateMachine.data.StateBase;
import com.common.sateMachine.data.StateId;

public class InitialState extends StateBase {


    public function InitialState() {
        super(StateId.INITIAL);
    }
}
}
