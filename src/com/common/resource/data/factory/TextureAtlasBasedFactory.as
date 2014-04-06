/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 20:00

 */
package com.common.resource.data.factory {
import com.common.file.data.FileData;
import com.common.file.data.FileType;
import com.common.resource.api.IBitmapDataFactory;
import com.common.resource.api.IBitmapFactory;
import com.common.resource.api.ITextureAtlasFactory;
import com.common.resource.api.IXMLFactory;
import com.common.resource.data.ResourceType;
import com.common.resource.data.factory.ResourceFactoryBase;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;

import starling.textures.Texture;

import starling.textures.TextureAtlas;

public class TextureAtlasBasedFactory extends ResourceFactoryBase implements IBitmapDataFactory,IBitmapFactory, IXMLFactory, ITextureAtlasFactory{




    public function TextureAtlasBasedFactory() {
        super(ResourceFactoryType.TEXTURE_ATLAS_SOURCE_BASED)
    }


    override public function saveSourceFilesForResources(resourceIList:Array, fileDataList:Vector.<FileData>):void {
        super.saveSourceFilesForResources(resourceIList, fileDataList);
        var descriptionSource:Object, imageSource:Object;
        var fileData:FileData
        for(var i:int=0;i<fileDataList.length;i++){
            fileData=fileDataList[i];
            if(fileData.fileType==FileType.TEXT){
               descriptionSource=fileData.data;
            }else{
                imageSource=fileData.data;
            }
        }
        var resourceId:String,descriptionResourceId:String,imageResourceId:String
        for(i=0;i<resourceIList.length;i++){
            resourceId=resourceIList[i];
            descriptionResourceId=getDescriptionSourceId(resourceId);
            imageResourceId=getImageSourceId(resourceId);
            saveSource(descriptionResourceId,descriptionSource);
            saveSource(imageResourceId,imageSource);

        }
    }

    public function getBitmapDataInstance(resourceId:String):BitmapData {
        var sourceKey:String=getImageSourceId(resourceId);
        var source:LoaderInfo=getSource(sourceKey) as LoaderInfo;
        var sourceBitmapData:BitmapData=(source.content as Bitmap).bitmapData;
        var result:BitmapData=sourceBitmapData;
        return result;
    }

    public function getBitmapInstance(resourceId:String):Bitmap {
        var sourceKey:String=getImageSourceId(resourceId);
        var source:LoaderInfo=getSource(sourceKey) as LoaderInfo;
        var sourceBitmapData:BitmapData=(source.content as Bitmap).bitmapData;
        var result:Bitmap=new Bitmap(sourceBitmapData);
        return result;
    }

    public function getXMLInstance(resourceId:String):XML {
        var sourceKey:String=getDescriptionSourceId(resourceId);
        var source:Object=getSource(sourceKey);
        var result:XML=(source)?new XML(source):null;
        return result;
    }

    public function getTextureAtlasInstance(resourceId:String):TextureAtlas {

        var description:XML=getXMLInstance(resourceId);
        var imageSourceKey:String=getImageSourceId(resourceId);
        var imageSource:BitmapData=((getSource(imageSourceKey) as LoaderInfo).content as Bitmap).bitmapData;
        var texture:Texture=Texture.fromBitmapData(imageSource,false);
        var result:TextureAtlas=new TextureAtlas(texture,description);
        return result;
    }

    override public function removeResource(value:Object):void {
        super.removeResource(value);
        if(value is BitmapData){
            var bitmapData:BitmapData=value as BitmapData;
            bitmapData.dispose();
        }
    }

    private function getDescriptionSourceId(resourceId:String):String
    {
        var result:String=resourceId+"|"+ResourceType.XML;
        return result;
    }
    private function getImageSourceId(resourceId:String):String
    {
        var result:String=resourceId+"|"+ResourceType.BITMAP;
        return result;
    }
}


}
