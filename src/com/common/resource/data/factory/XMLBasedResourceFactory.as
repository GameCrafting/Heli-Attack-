/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 01.04.14
 * Time: 22:13

 */
package com.common.resource.data.factory {
import com.common.file.data.FileData;
import com.common.resource.api.IXMLFactory;

public class XMLBasedResourceFactory extends ResourceFactoryBase implements IXMLFactory {



    public function XMLBasedResourceFactory() {
        super(ResourceFactoryType.XML_SOURCE_BASED);
    }


    override public function saveSourceFilesForResources(resourceIList:Array, fileDataList:Vector.<FileData>):void {
        super.saveSourceFilesForResources(resourceIList, fileDataList);
        var resourceId:String;
        var source:Object=(fileDataList.length>0)?fileDataList[0].data:null;
        if(!source) return;

        for(var i:int=0;i<resourceIList.length;i++){
            resourceId=resourceIList[i];
            saveSource(resourceId,source);
        }
    }

    public function getXMLInstance(resourceId:String):XML {

        var source:Object=getSource(resourceId);
        var result:XML=(source)?new XML(source):null;
        return result;
    }
}
}
