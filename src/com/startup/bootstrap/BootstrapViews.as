/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 13:32

 */
package com.startup.bootstrap {
import com.preloader.view.PreLoaderView;
import com.preloader.view.PreLoaderViewMeiator;
import com.root.RootScreen;
import com.root.RootScreenMediator;

import org.robotlegs.core.IStarlingMediatorMap;

public class BootstrapViews {
    public function BootstrapViews(mediatorMap:IStarlingMediatorMap) {

        mediatorMap.mapView(RootScreen,RootScreenMediator);
        mediatorMap.mapView(PreLoaderView,PreLoaderViewMeiator);

    }
}
}
