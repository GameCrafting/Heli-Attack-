/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 29.03.14
 * Time: 7:48
 * To change this template use File | Settings | File Templates.
 */
package com.common.file.data {
import com.common.dataTypes.ListenerGroup;

import flash.display.Loader;

import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

public class FileLoadProcess {

    public var fileData:FileData;
    public var onComplete:Function;
    public var onCompleteParams:Array;

    private var _loaderTarget:IEventDispatcher;
    private var _extractDataMethod:Function;

    public function FileLoadProcess() {
    }

    public function init(fileData:FileData,onComplete:Function,onCompleteParams:Array):void
    {
        this.fileData=fileData;
        this.onComplete=onComplete;
        this.onCompleteParams=onCompleteParams;
    }
    public function destroy():void
    {
        fileData=null;
        onComplete=null;
        onCompleteParams=null;
        unSubscribe();
        _loaderTarget=null;
        _extractDataMethod=null;
    }
    public function startLoad():void
    {
        switch(fileData.fileType)
        {
            case FileType.BINARY:
               startBinaryLoad();
            break;
            case FileType.MEDIA:
               startMediaLoad();
            break;
            default :
                startTextLoad();
        }
    }

    private function startBinaryLoad():void
    {
        unSubscribe();
        var request:URLRequest=new URLRequest(fileData.url);
        var loader:URLLoader=new URLLoader();
        loader.dataFormat=URLLoaderDataFormat.BINARY;
        _loaderTarget=loader;
        _extractDataMethod=getLoadedData;
        subscribe();
        loader.load(request);

    }
    private function startTextLoad():void
    {
        unSubscribe();
        var request:URLRequest=new URLRequest(fileData.url);
        var loader:URLLoader=new URLLoader();
        loader.dataFormat=URLLoaderDataFormat.TEXT;
        _loaderTarget=loader;
        _extractDataMethod=getLoadedData;
        subscribe();
        loader.load(request);
    }
    private function startMediaLoad():void
    {
        unSubscribe();
        var request:URLRequest=new URLRequest(fileData.url);
        var loaderInfo:LoaderInfo=new Loader().contentLoaderInfo;
        _loaderTarget=loaderInfo;
        _extractDataMethod=getLoadedLoaderInfo;
        subscribe();
        loaderInfo.loader.load(request);
    }

    private function onFileLoadComplete(event:Event):void
    {
        fileData.failedToLoad=false;
        fileData.data=(_extractDataMethod!=null)?_extractDataMethod(event.target):event.target;
        if(onComplete!=null){
            ListenerGroup.notifyListener(onComplete,onCompleteParams);
        }
    }

    private function onFileLoadError(event:Event):void
    {
        fileData.failedToLoad=true;
        fileData.data=null;
        if(onComplete!=null){
            ListenerGroup.notifyListener(onComplete,onCompleteParams);
        }
    }


    private function subscribe():void
    {
        if(!_loaderTarget) return;
        _loaderTarget.addEventListener(Event.COMPLETE,onFileLoadComplete);
        _loaderTarget.addEventListener(IOErrorEvent.IO_ERROR,onFileLoadError);
        _loaderTarget.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onFileLoadError);

    }

    private function unSubscribe():void
    {
        if(!_loaderTarget) return;
        _loaderTarget.removeEventListener(Event.COMPLETE,onFileLoadComplete);
        _loaderTarget.removeEventListener(IOErrorEvent.IO_ERROR,onFileLoadError);
        _loaderTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onFileLoadError);

    }

    private function getLoadedData(value:URLLoader):Object
    {
        var result:Object=value.data;
        return result;
    }
    private function getLoadedLoaderInfo(value:LoaderInfo):LoaderInfo
    {
        return value;
    }


}
}
