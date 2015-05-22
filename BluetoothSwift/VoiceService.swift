//
//  VoiceService.swift
//  BluetoothSwift
//
//  Created by Enkhjargal Gansukh on 5/22/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import Foundation
import AudioToolbox

class VoiceService {
    
    var currentLanguage: String?
    
    class var sharedInstance: VoiceService {
        struct Static {
            static var instance: VoiceService?
        }
        
        if (Static.instance == nil) {
            Static.instance = VoiceService()
        }
        
        return Static.instance!
    }
    
    func infoSound(type:String){
        if(type == "GREEN_SIDE"){
            playSound("\(currentLanguage!)/around_green_2")
        }else if(type == "OVER_500_METER"){
            playSound("\(currentLanguage!)/over_end_2")
        }else if(type == "RECEIVING_GPS"){
            playSound("\(currentLanguage!)/gps_information_2")
        }else if(type == "GOTO_TEE"){
            playSound("\(currentLanguage!)/tbox")
        }
    }
    func distanceSound(hole: String, distance: String, unit: String){
        
        
        println("distance: \(distance)")
        var _distance = distance.toInt()!
        var q100:Int
        var q10:Int
        var q1:Int
        
        var tmp_no = "\(currentLanguage!)/hole_\(hole)"
        playSound(tmp_no)
        NSThread.sleepForTimeInterval(8.0/10)
        
        q100 = _distance / 100;
        if(q100 > 0){
            var tmp_no = "\(currentLanguage!)/e\(q100)00_2"
            playSound(tmp_no)
            NSThread.sleepForTimeInterval(8.0/10)
        }
        q10 = _distance - q100*100;
        if(currentLanguage! == "en"){
            if(q10<10){
                var tmp_no = "\(currentLanguage!)/e\(q10)_2"
                playSound(tmp_no)
                NSThread.sleepForTimeInterval(6.0/10)
            }else if(q10>9 && q10<20){
                var temp = q10%10
                q10 = q10/10
                println("temp: \(temp)")
                var _temp = "\(q10)\(temp)"
                println("_temp:\(_temp)")
                var tmp_no = "\(currentLanguage!)/e\(q10)\(temp)_2"
                playSound(tmp_no)
                NSThread.sleepForTimeInterval(9.0/10)
            }else{
                q10 = q10/10
                var tmp_no = "\(currentLanguage!)/e\(q10)0_2"
                playSound(tmp_no)
                NSThread.sleepForTimeInterval(9.0/10)
                q1 = _distance - q100*100 - q10*10;
                if(q1>0){
                    var tmp_no = "\(currentLanguage!)/e\(q1)_2"
                    playSound(tmp_no)
                    NSThread.sleepForTimeInterval(6.0/10)
                }
            }
        }else{
            q10 = q10/10
            if(q10>0){
                var tmp_no = "\(currentLanguage!)/e\(q10)0_2"
                playSound(tmp_no)
                NSThread.sleepForTimeInterval(9.0/10)
            }
            q1 = _distance - q100*100 - q10*10;
            if(q1>0){
                var tmp_no = "\(currentLanguage!)/e\(q1)_2"
                playSound(tmp_no)
                NSThread.sleepForTimeInterval(6.0/10)
            }
        }
        var _unit:String
        if(unit == "METER"){
            _unit = "\(currentLanguage!)/meter_2"
        }else{
            _unit = "\(currentLanguage!)/yard_2"
        }
        playSound(_unit)
        
    }
    
    func playSound(data:String){
        let soundURL = NSBundle.mainBundle().URLForResource("Sounds/\(data)", withExtension: "caf")
        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL, &mySound)
        AudioServicesPlaySystemSound(mySound);
    }
    
    func setDeviceLanguage(){
        let lang: String = NSLocale.preferredLanguages()[0] as! String
        println(lang)
        if(lang == "ja"){
            currentLanguage = "ja"
        }else if(lang == "ko"){
            currentLanguage = "ko"
        }else{
            currentLanguage = "en"
        }
        println(currentLanguage)
    }
}