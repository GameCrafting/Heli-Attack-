/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 30.03.14
 * Time: 16:23
 * To change this template use File | Settings | File Templates.
 */
package com.startup.bootstrap {
import com.common.configuration.model.ConfigurationModel;
import com.preloader.model.PreLoaderModel;

import org.robotlegs.core.IInjector;

public class BootstrapModels {
    public function BootstrapModels(injector:IInjector) {

        injector.mapSingleton(ConfigurationModel)
        injector.mapSingleton(PreLoaderModel);
    }
}
}
