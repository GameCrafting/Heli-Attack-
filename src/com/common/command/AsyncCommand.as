/**
 * Created by Wheeler on 27.03.2014.
 */
package com.common.command {
import com.common.*;

import org.robotlegs.mvcs.StarlingCommand;

public class AsyncCommand extends StarlingCommand {
    public function AsyncCommand() {
        super();
    }


    override public function execute():void {
        commandMap.detain(this);
        startExecution();

    }
    public function cancel():void
    {
        onCommandCancel();
    }


    protected function startExecution():void
    {

    }

    protected function onCommandError(...params):void
    {
        var asyncCommandEvent:AsyncCommandEvent=new AsyncCommandEvent(AsyncCommandEvent.COMMAND_ERROR);
        asyncCommandEvent.command=this;
        asyncCommandEvent.params=params;
        dispatch(asyncCommandEvent)

        commandMap.release(this);
    }
    protected function onCommandComplete(...params):void
    {
        var asyncCommandEvent:AsyncCommandEvent=new AsyncCommandEvent(AsyncCommandEvent.COMMAND_COMPLETE);
        asyncCommandEvent.command=this
        asyncCommandEvent.params=params;
        dispatch(asyncCommandEvent);

        commandMap.release(this);
    }

    protected function onCommandCancel(...params):void
    {
        var asyncCommandEvent:AsyncCommandEvent=new AsyncCommandEvent(AsyncCommandEvent.COMMAND_CANCEL);
        asyncCommandEvent.command=this
        asyncCommandEvent.params=params;
        dispatch(asyncCommandEvent);

        commandMap.release(this);
    }


}
}
