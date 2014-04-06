/**
 * Created by Wheeler on 27.03.2014.
 */
package com.common.command {
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


    override public function cancel():void {
        unSubscribe();
        if(_currentCommand){
            _currentCommand.cancel();
            _currentCommand=null;
        }
        _commandTypeList=null;
        onCommandCancel();
    }

    public function advanceQueue():void
    {
        if(_currentCommand) return;

        if(!_commandTypeList.length){
            onCommandComplete();
            return;
        }
        var currentCommandType:Class=_commandTypeList.shift();
        _currentCommand=new currentCommandType();
        injector.injectInto(_currentCommand);
        var waitForResponse:Boolean=(_currentCommand is AsyncCommand);
        if(waitForResponse){
            subscribe();
        }
        _currentCommand.execute();
        if(!waitForResponse){
            _currentCommand=null;
            advanceQueue();
        }

    }

    private function onAsyncCommandComplete(event:AsyncCommandEvent):void {
        if(event.command!=_currentCommand) return;
        unSubscribe();
        _currentCommand=null;
        advanceQueue();

    }


    private function onAsyncCommandError(event:AsyncCommandEvent):void {
        if(event.command!=_currentCommand) return;
        unSubscribe();
        onCommandError();
    }

    private function onAsyncCommandCancel(event:AsyncCommandEvent):void {
        if(event.command!=_currentCommand) return;
        unSubscribe();
        _currentCommand=null;
        advanceQueue();
    }



    private function subscribe():void
    {
        eventDispatcher.addEventListener(AsyncCommandEvent.COMMAND_COMPLETE,onAsyncCommandComplete);
        eventDispatcher.addEventListener(AsyncCommandEvent.COMMAND_ERROR,onAsyncCommandError);
        eventDispatcher.addEventListener(AsyncCommandEvent.COMMAND_CANCEL,onAsyncCommandCancel);
    }
    private function unSubscribe():void
    {
        eventDispatcher.removeEventListener(AsyncCommandEvent.COMMAND_COMPLETE,onAsyncCommandComplete);
        eventDispatcher.removeEventListener(AsyncCommandEvent.COMMAND_ERROR,onAsyncCommandError);
        eventDispatcher.removeEventListener(AsyncCommandEvent.COMMAND_CANCEL,onAsyncCommandCancel);
    }

}
}
