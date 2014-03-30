/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 29.03.14
 * Time: 8:31
 * To change this template use File | Settings | File Templates.
 */
package com.startup.bootstrap {
import com.common.file.service.FileService;
import com.common.resource.service.ResourceService;

import org.robotlegs.core.IInjector;

public class BootstrapServices {
    public function BootstrapServices(injector:IInjector) {
        injector.mapSingleton(FileService);
        injector.mapSingleton(ResourceService);
    }
}
}
