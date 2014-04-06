/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 05.04.14
 * Time: 23:22

 */
package com.common.sateMachine {
import com.common.sateMachine.data.StateBase;
import com.common.sateMachine.data.StateTransition;
import com.common.util.ListUtil;

import flash.utils.Dictionary;

import org.robotlegs.core.IInjector;

public class StateMachine {

    [Inject]
    public var injector:IInjector

    private var _stateDict:Dictionary;
    private var _transitionListDictTaggedBySourceStateId:Dictionary

    private var _activeState:StateBase;
    private var _activeStateId:String
    private var _activeTransition:StateTransition;




    public function StateMachine() {
        _stateDict = new Dictionary();
        _transitionListDictTaggedBySourceStateId = new Dictionary();
    }

    public function isActiveStateChangeEnable(targetStateId:String):Boolean
    {
        var targetState:StateBase=getStateById(targetStateId);
        var transitionExists:Boolean=((targetState)&&(_activeState)&&(targetState!=_activeState)&&(getTransitionByConnectedStates(_activeState.id,targetStateId)))
        var result:Boolean=((transitionExists)||((targetState!=_activeState)&&((!targetState)||(!_activeState))))
        return result;
    }

    public function changeActiveState(targetStateId:String):void
    {
        if(!isActiveStateChangeEnable(targetStateId)) return;
        var requiredTransition:StateTransition=(_activeState)?getTransitionByConnectedStates(_activeState.id,targetStateId):null;

        if(_activeTransition){

            if(     (_activeState)&&
                    (_activeTransition.sourceStateId==_activeState.id)&&
                    (_activeTransition.targetStateId==targetStateId))return;

            _activeTransition.cancel();
            _activeTransition=null;
        }
        if(_activeState){
            _activeState.onExit();
            _activeState=null;
            _activeStateId=null;
        }
        if(requiredTransition){
            _activeTransition=requiredTransition;
            _activeTransition.start(completeStateTransition,[targetStateId]);
        }else{
            completeStateTransition(targetStateId);
        }

    }

    private function completeStateTransition(targetStateId):void
    {
        _activeState=getStateById(targetStateId);
        _activeTransition=null;
        if(_activeState){
            _activeStateId=_activeState.id;
            _activeState.onEnter()
        }
        trace("STATE TRANSITION COMPLETE: "+_activeStateId);
    }


    public function createState(value:Class):void
    {
        if(!injector.hasMapping(value)){
            injector.mapClass(value,value);
        }
        var state:StateBase=injector.getInstance(value);
        addState(state);
    }


    public function addState(value:StateBase):void
    {
        _stateDict[value.id]=value;
        value.stateMachine=this;
    }

    public function getStateById(value:String):StateBase {
        var result:StateBase = _stateDict[value];
        return result;
    }

    public function createTransition(type:Class):void {
        if (!type) return;
        if (!injector.hasMapping(type)) {
            injector.mapClass(type, type);
        }
        var stateTransition:StateTransition = injector.getInstance(type);
        addTransition(stateTransition);
    }

    public function addTransition(value:StateTransition):void {
        var transitionList:Vector.<StateTransition>
        if (!_transitionListDictTaggedBySourceStateId[value.sourceStateId]) {
            transitionList = new Vector.<StateTransition>();
            _transitionListDictTaggedBySourceStateId[value.sourceStateId] = transitionList;
        }
        transitionList = _transitionListDictTaggedBySourceStateId[value.sourceStateId];
        if (transitionList.indexOf(value) >= 0) return;
        transitionList.push(value);
        value.stateMachine=this;
    }



    public function isTransitionExists(sourceStateId:String,targetStateId:String):Boolean
    {
        var stateTransition:StateTransition=getTransitionByConnectedStates(sourceStateId,targetStateId);
        var result:Boolean=(stateTransition!=null);
        return result;
    }

    public function getTransitionByConnectedStates(sourceStateId:String, targetStateId:String):StateTransition {
        var stateTransitionList:Vector.<StateTransition> = _transitionListDictTaggedBySourceStateId[sourceStateId];
        var result:StateTransition = getTransitionFromListByTargetStateId(stateTransitionList, targetStateId);
        return result;
    }


    private function getTransitionFromListByTargetStateId(transitionList:Vector.<StateTransition>, targetStateId:String):StateTransition {
        var result:StateTransition;
        var length:int = ListUtil.getLength(transitionList);
        var currentTransition:StateTransition;
        for (var i:int = 0; i < length; i++) {
            currentTransition = transitionList[i];
            if (currentTransition.targetStateId != targetStateId) continue;
            result = currentTransition;
            break;
        }
        return result;
    }


    public function get activeStateId():String {
        return _activeStateId;
    }
}
}
