package {

import com.root.RootScreen;
import com.startup.HeliAttackContext;

import flash.display.Sprite;

import org.robotlegs.mvcs.Context;

import starling.core.Starling;
import starling.events.Event;
[SWF(width=550, height=400)]
public class HeliAttack extends Sprite {

    private var _startling:Starling;
    private var _context:HeliAttackContext

    public function HeliAttack() {
        super();

        _startling=new Starling(RootScreen,stage);
        _startling.addEventListener(Event.ROOT_CREATED, onRootCreated);
    }


    private function onRootCreated(event:Event):void {
        _startling.removeEventListener(Event.ROOT_CREATED, onRootCreated);

        var rootScreen:RootScreen=_startling.root as RootScreen;
        _context=new HeliAttackContext(rootScreen,false);
        _context.heliAttack=this;
        _context.starling=_startling;
        _context.startup();


    }
}
}
