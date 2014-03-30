/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 30.03.14
 * Time: 16:22
 * To change this template use File | Settings | File Templates.
 */
package com.common.configuration.model {
import org.robotlegs.mvcs.Actor;

public class ConfigurationModel extends Actor {

    private var _resourceMapUrlList:Vector.<String>

    public function ConfigurationModel() {
        super();
        _resourceMapUrlList=new Vector.<String>()

    }

    public function get resourceMapUrlList():Vector.<String> {
        return _resourceMapUrlList;
    }
}
}
