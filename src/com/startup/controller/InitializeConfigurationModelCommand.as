/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 30.03.14
 * Time: 16:27
 * To change this template use File | Settings | File Templates.
 */
package com.startup.controller {
import com.common.configuration.model.ConfigurationModel;

import org.robotlegs.mvcs.Command;
import org.robotlegs.mvcs.StarlingCommand;

public class InitializeConfigurationModelCommand extends StarlingCommand {

    [Inject]
    public var configurationModel:ConfigurationModel


    public function InitializeConfigurationModelCommand() {
        super();
    }


    override public function execute():void {
        configurationModel.resourceMapUrlList.push("assets/xml/resourceMap.xml");
        trace(this);
    }
}
}
