package {

import com.shared.constants.CommonConst;
import com.state.MenuState;

import flash.display.Sprite;
import flash.events.Event;

import org.flixel.FlxGame;

[SWF(width=550, height=400)]
public class HelliAttack extends Sprite {

    private var _gameInstance:FlxGame

    public function HelliAttack() {
        super();
        if (stage) {
            init();
        } else {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
    }


    private function init():void {
        _gameInstance = new FlxGame(CommonConst.SCREEN_WIDTH, CommonConst.SCREEN_HEIGHT, MenuState, 1, CommonConst.FRAME_RATE, CommonConst.STAGE_FRAME_RATE);
        addChild(_gameInstance);

    }


    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        init();
    }
}
}
