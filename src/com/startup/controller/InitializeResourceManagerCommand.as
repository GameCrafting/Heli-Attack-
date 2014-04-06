/**
 * Created by Wheeler on 27.03.2014.
 */
package com.startup.controller {
import com.common.command.AsyncCommand;
import com.common.configuration.model.ConfigurationModel;
import com.common.file.data.FileData;
import com.common.file.service.FileService;
import com.common.resource.service.ResourceService;
import com.common.util.ListUtil;

import flash.display.Stage;

public class InitializeResourceManagerCommand extends AsyncCommand {

    [Inject]
    public var fileService:FileService;
    [Inject]
    public var configurationModel:ConfigurationModel;
    [Inject]
    public var resourceService:ResourceService;

    [Inject]
    public var stage:Stage


    public function InitializeResourceManagerCommand() {
        super();
    }


    override protected function startExecution():void {
        var resourceMapURIList:Array = ListUtil.toArray(configurationModel.resourceMapUrlList);
        fileService.loadFileList(resourceMapURIList, null, onResourceMapFileListLoaded);

    }

    private function onResourceMapFileListLoaded(fileDataList:Vector.<FileData>):void {
        var currentFileData:FileData;
        var currentResourceMap:XML;

        for (var i:int = 0; i < fileDataList.length; i++) {
            currentFileData = fileDataList[i];
            currentResourceMap = new XML(currentFileData.data);
            resourceService.saveResourceInfo(currentResourceMap);

        }
        onCommandComplete();
    }


}
}
