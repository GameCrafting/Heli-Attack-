/**
 * Created by Wheeler on 27.03.2014.
 */
package com.common.command {
import flash.events.Event;


public class AsyncCommandEvent extends Event {

    static public const COMMAND_COMPLETE:String="async_command_complete";
    static public const COMMAND_CANCEL:String="async_command_cancel";
    static public const COMMAND_ERROR:String="command_error";

    public var command:AsyncCommand;
    public var params:Array



    public function AsyncCommandEvent(type:String, bubbles:Boolean = false, data:Object = null) {
        super(type, bubbles, data);
    }
}
}
