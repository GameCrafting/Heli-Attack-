/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 30.03.14
 * Time: 21:16

 */
package com.common.util {
public class ParseUtil {
    public function ParseUtil() {
    }

    static public function readString(source:XML,propertyName:String):String
    {
        var result:String=((source)&&(source.hasOwnProperty(propertyName)))?source[propertyName]+"":"";
        return result;
    }

    static public function readChildNodeString(source:XML,childNodeName:String,childNodeIndex:int,propertyName:String):String
    {

        var result:String=((source)&&(source[childNodeName])&&(source[childNodeName][childNodeIndex])&&(source[childNodeName][childNodeIndex][propertyName]))?source[childNodeName][childNodeIndex][propertyName]+"":"";
        return result;
    }
}
}
