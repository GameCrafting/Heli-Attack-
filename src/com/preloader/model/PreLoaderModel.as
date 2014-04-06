/**
 * Created with IntelliJ IDEA.
 * User: Viacheslav.Kolesnyk
 * Date: 06.04.14
 * Time: 13:21

 */
package com.preloader.model {
import com.preloader.event.PreLoaderEvent;

import flash.text.StageTextInitOptions;

import org.robotlegs.mvcs.Actor;

public class PreLoaderModel extends Actor {

    private var _preLoaderActive:Boolean;

    private var _preLoaderTitle:String;
    private var _preLoaderDescription:String;
    private var _preLoaderStyle:Object;



    public function PreLoaderModel() {
        super();
    }



    public function get preLoaderActive():Boolean {
        return _preLoaderActive;
    }

    public function get preLoaderTitle():String {
        return _preLoaderTitle;
    }

    public function get preLoaderDescription():String {
        return _preLoaderDescription;
    }

    public function get preLoaderStyle():Object {
        return _preLoaderStyle;
    }

    public function set preLoaderActive(value:Boolean):void {
        if(_preLoaderActive==value) return;
        _preLoaderActive = value;
        if(_preLoaderActive){
            dispatch(new PreLoaderEvent(PreLoaderEvent.PRE_LOADING_STARTED));
        }else{
            dispatch(new PreLoaderEvent(PreLoaderEvent.PRE_LOADING_COMPLETED));
        }
    }

    public function set preLoaderTitle(value:String):void {
        _preLoaderTitle = value;
    }

    public function set preLoaderDescription(value:String):void {
        _preLoaderDescription = value;
    }

    public function set preLoaderStyle(value:Object):void {
        _preLoaderStyle = value;
    }
}
}
