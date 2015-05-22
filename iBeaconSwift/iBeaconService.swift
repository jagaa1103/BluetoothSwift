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
    
    var gPeripheral: CBPeripheral!
    
    let kModeServiceUUID = "2320AE58-8394-4652-95F7-0A872AC0958F"
    let kModeCharacterisitcUUID = "481DE929-8D4C-4D9E-A574-772A73E63977"
    
    let kEventServiceUUID = "41DF72E4-9721-41BD-B27F-F507A94D9634"
    let kEventCharacterisitcUUID = "43E9D729-2FC6-430F-B835-5192ACB96518"

    
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
            return
        }
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        if((peripheral.name) != nil){
            if(peripheral.name == "CODAWheel"){
//                println(peripheral)
//                central.connectPeripheral(peripheral, options: nil)
                var uuid: CBUUID
                uuid = CBUUID(string: kEventServiceUUID)
                var uuidArray: NSArray = [uuid]
                var itemArray: NSArray = central.retrieveConnectedPeripheralsWithServices(uuidArray as [AnyObject])
                gPeripheral = itemArray.objectAtIndex(0) as! CBPeripheral
                central.connectPeripheral(gPeripheral, options: nil)
            }else{
                println("Not CodaWheel")
            }
        }else{
            println("scanned other device")
        }
    }
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("connected")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println(error)
    }
    func centralManager(central: CBCentralManager!, didRetrieveConnectedPeripherals peripherals: [AnyObject]!) {
        println(peripherals)
    }
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        println(peripheral.services)
    }
}