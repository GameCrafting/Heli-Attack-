package com.common.util {
public class ListUtil {
    public function ListUtil() {
    }

    static public function getLength(value:Object):int {
        var result:int = ((value) && (value.hasOwnProperty("length"))) ? value.length : 0;
        return result;
    }

    static public function isContentEqual(list1:Object, list2:Object):Boolean {
        var length1:int = getLength(list1);
        var length2:int = getLength(list2);
        if (!length1 != length2) return false;

        var result:Boolean = true;
        for (var i:int = 0; i < length1; i++) {
            if (list1[i] == list2[i]) continue;
            result = false;
            break;
        }

        return result;
    }

    static public function toArray(sourceList:Object):Array
    {
        var length:int=getLength(sourceList);
        var result:Array=[];
        for(var i:int=0;i<length;i++){
            result.push(sourceList[i]);
        }
        return result;
    }
    static public function createListWithValue(value:Object,length:int):Array
    {
        var result:Array=[];
        for(var i:int=0;i<length;i++){
            result.push(value);
        }
        return result;
    }
}
}
