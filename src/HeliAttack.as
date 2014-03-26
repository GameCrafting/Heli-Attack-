package {

import com.RootScreen;

import flash.display.Sprite;
import starling.core.Starling;
import starling.events.Event;

public class HeliAttack extends Sprite {

    private var _startling:Starling

    public function HeliAttack() {
        super();

        _startling=new Starling(RootScreen,stage);
        _startling.addEventListener(Event.ROOT_CREATED, onRootCreated);
    }


    private function onRootCreated(event:Event):void {

    }
}
}
