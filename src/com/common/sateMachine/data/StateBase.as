/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 05.04.14
 * Time: 23:26

 */
package com.common.sateMachine.data {
import com.common.sateMachine.StateMachine;

public class StateBase {

    private var _id:String;
    public var stateMachine:StateMachine;


    public function StateBase(id:String = null) {
        _id = id;
    }

    public function onEnter():void {

    }

    public function onExit():void {

    }


    public function get id():String {
        return _id;
    }
}
}
