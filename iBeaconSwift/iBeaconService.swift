//
//  iBeaconService.swift
//  iBeaconSwift
//
//  Created by Enkhjargal Gansukh on 5/21/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import Foundation
import CoreBluetooth

class iBeaconService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var central: CBCentralManager!
    var bluetoothOn:Bool = false
    
    let kModeServiceUUID = "2320AE58-8394-4652-95F7-0A872AC0958F"

    
    class var sharedInstance: iBeaconService {
        struct Static {
            static var instance: iBeaconService?
        }
        if (Static.instance == nil) {
            Static.instance = iBeaconService()
        }
        return Static.instance!
    }
    
    func startService(){
        central = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan(){
        if !bluetoothOn{
            println("Bluetooth is off")
        }else{
            central.scanForPeripheralsWithServices(nil, options:nil)
        }
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println(central)
        println(central.state)
        if(central.state == CBCentralManagerState.PoweredOn){
            println("Bluetooth is on!!!")
            bluetoothOn = true
            startScan()
        }else{
            println("Bluetooth is off!!!")
        }
    }
    func centralManager(central: CBCentralManager!, willRestoreState dict: [NSObject : AnyObject]!) {
        println(dict)
    }
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        if((peripheral.name) != nil){
            if(peripheral.name == "CODAWheel"){
                println(peripheral)
                central.connectPeripheral(peripheral, options: nil)
            }else{
                println("Not CodaWheel")
            }
        }else{
            println("scanned other device")
        }
        
    }
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("connected")
    }
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println(error)
    }
}