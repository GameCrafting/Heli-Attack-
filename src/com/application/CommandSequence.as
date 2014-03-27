/**
 * Created by Wheeler on 27.03.2014.
 */
package com.application {
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class CommandSequence extends AsyncCommand {

    private var _commandTypeList:Vector.<Class>
    private var _currentCommand:Object;



    public function CommandSequence() {
        super();
        _commandTypeList=new Vector.<Class>();
    }

    public function addCommand(type:Class):void
    {
       _commandTypeList.push(type);
    }


    override protected function startExecution():void {
          advanceQueue();
    }

    public function advanceQueue():void
    {
        if(_currentCommand) return;

        if(!_commandTypeList.length){
            onCommandComplete();
            return;
        }
        var currentCommandType:Class=_commandTypeList.shift();
        var currentCommandInstance:Object=new currentCommandType();
        injector.injectInto(currentCommandInstance);
        var waitForResponse:Boolean=(currentCommandInstance is AsyncCommand);
        if(waitForResponse){
            subscribe();
        }
        currentCommandInstance.execute();
        if(!waitForResponse){
            advanceQueue();
        }

    }

    private function onAsyncCommandComplete(event:AsyncCommandEvent):void {
        if(event.command!=_currentCommand) return;
        var mappedParamsCurrent:Array=event.params;
        var mappedParamsLastLast:Array=[];



    }


    private function mapParams(value:Array):Array
    {
        var paramsLast:Array=[];
        var length:int=(value)?value.length:0;
        var currentParam:Object;
        var currentParamType:Class;
        for(var i:int=0;i<length;i++){
            currentParam=value[i];
            currentParamType=getDefinitionByName(getQualifiedClassName(currentParam)) as Class;
            if(injector.hasMapping(currentParamType)) continue;

        }
    }
    private function removeParams(value:Array):void
    {

    }





    private function onAsyncCommandError(event:AsyncCommandEvent):void {

    }

    private function subscribe():void
    {
        eventDispatcher.addEventListener(AsyncCommandEvent.COMMAND_COMPLETE,onAsyncCommandComplete);
        eventDispatcher.addEventListener(AsyncCommandEvent.COMMAND_ERROR,onAsyncCommandError);
    }
    private function unSubscribe():void
    {
        eventDispatcher.removeEventListener(AsyncCommandEvent.COMMAND_COMPLETE,onAsyncCommandComplete);
        eventDispatcher.removeEventListener(AsyncCommandEvent.COMMAND_ERROR,onAsyncCommandError);
    }

}
}
