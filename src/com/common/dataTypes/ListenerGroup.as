/**
 * Created with IntelliJ IDEA.
 * User: Wheeler
 * Date: 28.03.14
 * Time: 20:31
 * To change this template use File | Settings | File Templates.
 */
package com.common.dataTypes {
import com.common.util.ListUtil;

public class ListenerGroup {


    private var _listenerList:Vector.<Function>;
    private var _listenerPostParamsList:Vector.<Array>;


    public function ListenerGroup() {
        _listenerList=new Vector.<Function>();
        _listenerPostParamsList=new Vector.<Array>()

    }

    public function destroy():void
    {
        _listenerList=null;
        _listenerPostParamsList=null;
    }

    public function purge():void
    {
        _listenerList.length=0;
        _listenerPostParamsList.length=0;
    }

    public function notify(...params):void
    {
        var currentListener:Function;
        var currentListenerPostParams:Array;
        for(var i:int=0;i<_listenerList.length;i++){
            currentListener=_listenerList[i];
            currentListenerPostParams=_listenerPostParamsList[i];
            notifyListener(currentListener,params,currentListenerPostParams)
        }
    }

    static public function notifyListener(value:Function,params:Array=null,postParams:Array=null):void
    {
        params=(params)?params:[];
        var listenerParams:Array=((postParams)&&(postParams.length))?params.concat(postParams):params.slice();
        listenerParams.length=Math.min(listenerParams.length,value.length);
        value.apply(null,listenerParams);
    }

    public function addListener(value:Function,postParams:Array):void
    {
        if(value==null) return;
        if(containsListenerWithPostParams(value,postParams)) return;
        _listenerList.push(value);
        _listenerPostParamsList.push(postParams);
    }

    public function removeListenerWithPostParams(value:Function,postParams:Array):void
    {
        var index:int=getListenerWithPostPramsIndex(value,postParams);
        if(index<0) return;
        _listenerList.splice(index,1);
        _listenerPostParamsList.splice(index,1);

    }

    public function removeListener(value:Function):void
    {
        for(var i:int=_listenerList.length-1;i>=0;i--){
            if(_listenerList[i]!=value) continue;
            _listenerList.splice(i,1)
            _listenerPostParamsList.splice(i, 1);

        }
    }





    public function containsListenerWithPostParams(value:Function,postParams:Array):Boolean
    {
        var index:int=getListenerWithPostPramsIndex(value,postParams);
        var result:Boolean=(index>=0);
        return result;
    }

    public function containsListener(value:Function):Boolean
    {
        var index:int=(value!=null)?_listenerList.indexOf(value):-1;
        var result:Boolean=(index>=0);
        return result;
    }







    private function getListenerWithPostPramsIndex(value:Function,postParams:Array):int
    {
        var result:int=-1;
        for(var i:int=0;i<_listenerList.length;i++){
            if(_listenerList[i]!=value) continue;
            if(!ListUtil.isContentEqual(postParams,_listenerPostParamsList[i])) continue;
            result=i;
            break;
        }

        return result;
    }

}
}
