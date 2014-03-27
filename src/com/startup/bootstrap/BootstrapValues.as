/**
 * Created by Wheeler on 27.03.2014.
 */
package com.startup.bootstrap {
import com.RootScreen;
import com.startup.HeliAttackContext;
import org.robotlegs.base.MediatorMap;

import org.robotlegs.core.IInjector;
import org.robotlegs.core.IMediatorMap;

import starling.animation.Juggler;

import starling.core.Starling;
import starling.display.DisplayObjectContainer;

public class BootstrapValues {



    public function BootstrapValues(heliAttackContext:HeliAttackContext,injector:IInjector) {

        var starling:Starling=heliAttackContext.starling;
        var juggler:Juggler=starling.juggler;
        var heliAttack:HeliAttack=heliAttackContext.heliAttack;
        var rootScreen:RootScreen=starling.root as RootScreen;

        injector.mapValue(Starling,starling);
        injector.mapValue(Juggler,juggler);
        injector.mapValue(HeliAttack,heliAttack);
        injector.mapValue(RootScreen, rootScreen);
        //injector.mapValue(DisplayObjectContainer,rootScreen);


    }
}
}
