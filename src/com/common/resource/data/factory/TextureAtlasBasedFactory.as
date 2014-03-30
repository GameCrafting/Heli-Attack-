/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 20:00

 */
package com.common.resource.data.factory {
import com.common.resource.api.IBitmapDataFactory;
import com.common.resource.api.ITextureAtlasFactory;
import com.common.resource.api.IXMLFactory;
import com.common.resource.data.factory.ResourceFactoryBase;

import flash.display.BitmapData;

import starling.textures.TextureAtlas;

public class TextureAtlasBasedFactory extends ResourceFactoryBase implements IBitmapDataFactory, IXMLFactory, ITextureAtlasFactory{




    public function TextureAtlasBasedFactory() {
        super(ResourceFactoryType.TEXTURE_ATLAS_SOURCE_BASED)
    }


    public function getBitmapDataReference(resourceId:String):BitmapData {
        return null;
    }

    public function getXMLReference(resourceId:String):XML {
        return null;
    }

    public function getTextureAtlasReference(resourceId:String):TextureAtlas {
        return null;
    }
}
}
