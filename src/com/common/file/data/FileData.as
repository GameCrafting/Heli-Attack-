/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 28.03.14
 * Time: 22:37
 * To change this template use File | Settings | File Templates.
 */
package com.common.file.data {
public class FileData {

    static private const MEDIA_URL_REG:RegExp=/\.(swf|jpg|jpeg|png)$/


    public var url:String;
    public var fileType:String;
    public var failedToLoad:Boolean
    public var data:Object;



    public function FileData() {
    }

    static public function generateId(url:String,fileType:String):String
    {
        var result:String=url+"<_>"+fileType;
        return result;
    }
    static public function generateGroupId(urlList:Array,fileTypeList:Array):String
    {
        var fileTyeListLength:int=(fileTypeList)?fileTypeList.length:0;
        var currentFileType:String;
        var result:String="";
        var currentKey:String
        for(var i:int=0;i<urlList.length;i++){
            currentFileType=(i<fileTyeListLength)?fileTypeList[i]:getFileTypeFromUrl(urlList[i]);
            currentKey=generateId(urlList[i],currentFileType);
            result=(result)?result+"|"+currentKey:currentKey;
        }
        return result;
    }
    static public function readGroupId(id:String,urlList:Array,fileTypeList:Array):void
    {
        var idComponentList:Array=(id)?id.split("|"):null;
        var length:int=(idComponentList)?idComponentList.length:0;
        var helper:Array
        for(var i:int=0;i<length;i++){
            helper=idComponentList[i].split("<_>");
            urlList.push(helper[0]);
            fileTypeList.push(helper[1]);
        }
    }
    static public function getFileTypeFromUrl(url:String):String
    {
        var result:String=MEDIA_URL_REG.test(url)?FileType.MEDIA:FileType.TEXT;
        return result;
    }

    static public function getFileTypeListFromUrlList(urlList:Array):Array
    {
        var result:Array=[];
        var currentURL:String,currentFileType:String;
        for(var i:int=0;i<urlList.length;i++){
            currentURL=urlList[i];
            currentFileType=getFileTypeFromUrl(currentURL);
            result.push(currentFileType);
        }
        return result;
    }
}
}
