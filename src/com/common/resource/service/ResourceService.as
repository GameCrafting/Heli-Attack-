/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 18:05

 */
package com.common.resource.service {
import com.common.file.service.FileService;
import com.common.resource.data.ResourceLibraryData;
import com.common.resource.data.factory.ResourceFactoryBase;
import com.common.resource.data.parser.ResourceMapParser;

public class ResourceService {

    [Inject]
    public var fileService:FileService;

    private var _resourceLibraryData:ResourceLibraryData;
    private var _resourceMapParser:ResourceMapParser;


    public function ResourceService() {
        _resourceLibraryData=new ResourceLibraryData();
        _resourceMapParser=new ResourceMapParser();
    }

    public function saveResourceInfo(source:XML):void
    {
        _resourceMapParser.parse(source,this);
    }

    public function isResourceRegistered(resourceId:String):Boolean
    {
        var resourceFactory:ResourceFactoryBase=_resourceLibraryData.getResourceFactoryByResourceId(resourceId);
        var result:Boolean=(resourceFactory!=null);
        return result;
    }


    public function isResourceLoaded(resourceId:String):Boolean
    {
        var resourceFactory:ResourceFactoryBase=_resourceLibraryData.getResourceFactoryByResourceId(resourceId);
        var result:Boolean=((resourceFactory)&&(resourceFactory.containsSourceFilesForResource(resourceId)))
        return result;
    }

    public function loadResource(resourceId:String,onComplete:Function,onCompletePosyParams:Array):void
    {
        if(!isResourceRegistered(resourceId)) return;
        if(isResourceLoaded(resourceId)){
            if(onComplete!=null){

            }
        }
    }

    public function get resourceLibraryData():ResourceLibraryData {
        return _resourceLibraryData;
    }
}
}
