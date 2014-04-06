/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 28.03.14
 * Time: 22:32
 * To change this template use File | Settings | File Templates.
 */
package com.common.file.service {
import com.common.dataTypes.ListenerGroup;
import com.common.file.data.FileData;
import com.common.file.data.FileLoadProcess;
import com.common.util.ListUtil;
import flash.utils.Dictionary;

public class FileService {

    private var _listenerGroupDict:Dictionary;
    private var _fileListLoadListenerGroup:Dictionary
    private var _fileDataDict:Dictionary;
    private var _fileLoadProcessDict:Dictionary;



    public function FileService() {

        _listenerGroupDict=new Dictionary();
        _fileListLoadListenerGroup=new Dictionary();
        _fileDataDict=new Dictionary();
        _fileLoadProcessDict=new Dictionary();
    }
    public function getFileDataList(urlList:Array,fileTypeList:Array=null):Vector.<FileData>
    {
        var result:Vector.<FileData>=new Vector.<FileData>();
        var fileTypeListLength:int=ListUtil.getLength(fileTypeList);
        var length:int=ListUtil.getLength(urlList);
        var fileData:FileData,fileType:String;
        for(var i:int=0;i<length;i++){
            fileType=(i<fileTypeListLength)?fileTypeList[i]:FileData.getFileTypeFromUrl(urlList[i]);
            fileData=getFileData(urlList[i],fileType);
            if(!result) continue;
            result.push(fileData)
        }
        return result;
    }

    public function getFileData(url:String,fileType:String=null):FileData
    {
        fileType=(fileType)?fileType:FileData.getFileTypeFromUrl(url);
        var key:String=FileData.generateId(url,fileType);
        var result:FileData=_fileDataDict[key];
        return result;
    }
    public function isFileListLoadPerformed(urlList:Array,fileTypeList:Array=null):Boolean
    {
        var urlListLength:int=ListUtil.getLength(urlList);
        var fileTypeListLength:int=ListUtil.getLength(fileTypeList);
        var result:Boolean=true;
        var fileType:String
        for(var i:int=0;i<urlListLength;i++){
            fileType=(i<fileTypeListLength)?fileTypeList[i]:FileData.getFileTypeFromUrl(urlList[i]);
            result=isFileLoadPerformed(urlList[i],fileType);
            if(!result) break;
        }
        return result;
    }



    public function isFileLoadPerformed(url:String,fileType:String=null):Boolean
    {
        fileType=(fileType)?fileType:FileData.getFileTypeFromUrl(url);
        var key:String=FileData.generateId(url,fileType);
        var result:Boolean=Boolean(_fileDataDict[key]);
        return result;
    }

    public function loadFileList(urlList:Array,fileTypeList:Array=null,onComplete:Function=null,onCompletePostParams:Array=null):void
    {
        if(isFileListLoadPerformed(urlList,fileTypeList)){
            if(onComplete!=null){
                var fileDataList:Vector.<FileData>=getFileDataList(urlList,fileTypeList);
                ListenerGroup.notifyListener(onComplete,[fileDataList],onCompletePostParams);
            }
            return;
        }

        if(onComplete!=null){
            var key:String=FileData.generateGroupId(urlList,fileTypeList);
            var listenerGroup:ListenerGroup=_fileListLoadListenerGroup[key];
            if(!listenerGroup){
                listenerGroup=new ListenerGroup();
                _fileListLoadListenerGroup[key]=listenerGroup;
            }
            listenerGroup.addListener(onComplete,onCompletePostParams);
        }

        var fileTypeListLength:int=ListUtil.getLength(fileTypeList);
        var length:int=ListUtil.getLength(urlList);
        var currentFileType:String
        for(var i:int=0;i<length;i++){
            currentFileType=(i<fileTypeListLength)?fileTypeList[i]:FileData.getFileTypeFromUrl(urlList[i])
            loadFile(urlList[i],currentFileType)
        }


    }

    public function loadFile(url:String,fileType:String=null,onComplete:Function=null,onCompletePostPrams:Array=null):void
    {
        fileType=(fileType)?fileType:FileData.getFileTypeFromUrl(url);
        var fileData:FileData=getFileData(url,fileType);
        if(fileData){
            if(onComplete!=null){
                ListenerGroup.notifyListener(onComplete,[fileData],onCompletePostPrams);
            }

            return;
        }

        var key:String=FileData.generateId(url,fileType);
        if(onComplete!=null){
            var listenerGroup:ListenerGroup=_listenerGroupDict[key];
            if(!listenerGroup){
                listenerGroup=new ListenerGroup();
                _listenerGroupDict[key]=listenerGroup;
            }
            listenerGroup.addListener(onComplete,onCompletePostPrams);
        }
        if(!_fileLoadProcessDict[key]){
            fileData=new FileData();
            fileData.url=url;
            fileData.fileType=fileType;

            var fileLoadProcess:FileLoadProcess=new FileLoadProcess();
            fileLoadProcess.init(fileData,onFileLoadComplete,[fileLoadProcess]);
            _fileLoadProcessDict[key]=fileLoadProcess;
            fileLoadProcess.startLoad();
        }

    }

    public function removeFileLoadListener(value:Function,withAnyPostParams:Boolean=true,postParams:Array=null):void
    {
        for each(var listenerGroup:ListenerGroup in _listenerGroupDict){
            if(withAnyPostParams){
                listenerGroup.removeListener(value);
            }else{
               listenerGroup.removeListenerWithPostParams(value,postParams);
            }
        }


    }
    public function removeFileListLoadListener(value:Function,withAnyPostParams:Boolean=true,postParams:Array=null):void
    {
        for each(var listenerGroup:ListenerGroup in _fileListLoadListenerGroup){
            if(withAnyPostParams){
                listenerGroup.removeListener(value);
            }else{
                listenerGroup.removeListenerWithPostParams(value,postParams);
            }
        }

    }

    private function onFileLoadComplete(fileLoadProcess:FileLoadProcess):void
    {
        var fileData:FileData=fileLoadProcess.fileData;
        var key:String=FileData.generateId(fileData.url,fileData.fileType);
        _fileDataDict[key]=fileData;
        _fileLoadProcessDict[key]=undefined;
        delete _fileLoadProcessDict[key];
        fileLoadProcess.destroy();

        var listenerGroup:ListenerGroup=_listenerGroupDict[key];
        if(listenerGroup){
            _listenerGroupDict[key]=undefined;
            delete  _listenerGroupDict[key];
            listenerGroup.notify(fileData);
        }

        var urlList:Array,fileTypeList:Array,fileDataList:Vector.<FileData>;
        for(var fileListLoadKey:String in _fileListLoadListenerGroup){
            if(fileListLoadKey.indexOf(key)<0)continue;
            urlList=[];
            fileTypeList=[];
            FileData.readGroupId(fileListLoadKey,urlList,fileTypeList);
            if(!isFileListLoadPerformed(urlList,fileTypeList)) continue;
            listenerGroup=_fileListLoadListenerGroup[fileListLoadKey];
            _fileListLoadListenerGroup[fileListLoadKey]=undefined;
            delete _fileListLoadListenerGroup[fileListLoadKey];
            fileDataList=getFileDataList(urlList,fileTypeList);
            listenerGroup.notify(fileDataList);

        }

    }
}
}
