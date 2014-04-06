/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 05.04.14
 * Time: 23:32

 */
package com.common.sateMachine.data {
import com.common.command.AsyncCommand;
import com.common.command.AsyncCommandEvent;
import com.common.dataTypes.ListenerGroup;
import com.common.sateMachine.StateMachine;

import flash.events.IEventDispatcher;

import org.robotlegs.core.IInjector;

public class StateTransition {

    [Inject]
    public var injector:IInjector
    [Inject]
    public var eventDispatcher:IEventDispatcher

    private var _sourceStateId:String;
    private var _targetStateId:String;
    private var _transitionCommandType:Class;

    public var stateMachine:StateMachine

    private var _onComplete:Function;
    private var _onCompleteParams:Array;
    private var _activeCommand:AsyncCommand





    public function StateTransition(sourceStateId:String,targetStateId:String,commandType:Class) {
        _sourceStateId=sourceStateId;
        _targetStateId=targetStateId;
        _transitionCommandType=commandType;
    }


    public function start(onComplete:Function,onCompleteParams:Array=null):void
    {
        _onComplete=onComplete;
        _onCompleteParams=onCompleteParams;

        var commandInstance:Object=(_transitionCommandType)?new _transitionCommandType():null;
        _activeCommand=commandInstance as AsyncCommand;
        if(_activeCommand){
           eventDispatcher.addEventListener(AsyncCommandEvent.COMMAND_COMPLETE,onCommandComplete)
        }
        if((commandInstance)&&(commandInstance.hasOwnProperty("execute"))){
            injector.injectInto(commandInstance);
            commandInstance.execute();
        }
        if(!_activeCommand){
            onTransitionComplete();
        }

    }
    public function cancel():void
    {
       if(_activeCommand){
           _activeCommand.cancel();
           eventDispatcher.removeEventListener(AsyncCommandEvent.COMMAND_COMPLETE,onCommandComplete);
           _activeCommand=null;

       }
    }

    private function onTransitionComplete():void
    {
        eventDispatcher.removeEventListener(AsyncCommandEvent.COMMAND_COMPLETE,onCommandComplete);
        _activeCommand=null;
        ListenerGroup.notifyListener(_onComplete,_onCompleteParams);
    }

    public function get sourceStateId():String {
        return _sourceStateId;
    }

    public function get targetStateId():String {
        return _targetStateId;
    }

    private function onCommandComplete(event:AsyncCommandEvent):void {
        if(event.command!=_activeCommand) return;
        eventDispatcher.removeEventListener(AsyncCommandEvent.COMMAND_COMPLETE,onCommandComplete);
        onTransitionComplete();
    }
}
}
