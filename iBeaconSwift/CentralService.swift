//
//  centralService.swift
//  iBeaconSwift
//
//  Created by Enkhjargal Gansukh on 5/22/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import Foundation
import CoreBluetooth

class CentralService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let kModeServiceUUID = "2320AE58-8394-4652-95F7-0A872AC0958F"
    let kModeCharacterisitcUUID = "481DE929-8D4C-4D9E-A574-772A73E63977"
    
    let kEventServiceUUID = "41DF72E4-9721-41BD-B27F-F507A94D9634"
    let kEventCharacterisitcUUID = "43E9D729-2FC6-430F-B835-5192ACB96518"
    
    var centmanager: CBCentralManager!
    var isMode: Bool
    var myPeripheral: CBPeripheral!
    var bluetoothOn:Bool = false
    
    
    class var sharedInstance: CentralService {
        struct Static {
            static var instance: CentralService?
        }
        if (Static.instance == nil) {
            Static.instance = CentralService()
        }
        return Static.instance!
    }
    
    override init(){
        isMode = true
        self.myPeripheral = nil
    }
    
    func startService(){
        isMode = false
        centmanager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if(central.state == CBCentralManagerState.PoweredOn){
            println("Bluetooth is on!!!")
            bluetoothOn = true
            centmanager = central
            self.scanPeripheral()
        }else{
            println("Bluetooth is off!!!")
        }
    }
    func scanPeripheral(){
        centmanager.scanForPeripheralsWithServices(nil, options: nil)
        var uuid: CBUUID
        if isMode {
            uuid = CBUUID(string: kModeServiceUUID)
        } else {
            uuid = CBUUID(string: kEventServiceUUID)
        }
        var uuidArray: NSArray = [uuid]
        var itemArray: NSArray = centmanager.retrieveConnectedPeripheralsWithServices(uuidArray as [AnyObject])
        if(itemArray.count > 0){
            myPeripheral = itemArray.objectAtIndex(0) as! CBPeripheral
            centmanager.connectPeripheral(myPeripheral, options: nil)
            return
        }else{
            println("Coda is not connected!!! Please connect Coda")
        }

    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Failed:\(error)")
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("Connected:\(peripheral.name)")
        println("Connected:\(peripheral.description)")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    func peripheral(peripheral: CBPeripheral!, didReadRSSI RSSI: NSNumber!, error: NSError!) {
        println(RSSI)
    }
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        println(peripheral.services)
        for service in peripheral.services as! [CBService] {
            println("ServiceUUID=\(service.UUID)")
            var uuid: NSString
            if isMode {
                uuid = kModeServiceUUID
            } else {
                uuid = kEventServiceUUID
            }
            if service.UUID.isEqual(CBUUID(string: uuid as String)) {
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        for aChar in service.characteristics as! [CBCharacteristic] {
            
            if aChar.UUID.isEqual(CBUUID(string: kModeCharacterisitcUUID))
            {
                println("Find Mode Charateristic")
                
                var data = NSData(bytes: [0x0b,0x00,0x80,0x00,0x80,0x00,0x80,0x00,0x80] as [UInt8], length: 9)
                peripheral.writeValue(data, forCharacteristic: aChar, type: .WithResponse)
            }
            else if aChar.UUID.isEqual(CBUUID(string: kEventCharacterisitcUUID))
            {
                println("Find Event Charateristic")
                peripheral.setNotifyValue(true, forCharacteristic: aChar)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        println("[kys]didWriteValueForCharacteristic")
        
        centmanager = nil
        
        isMode = false
        centmanager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if (error != nil) {
            println("[kys]Error discover characteristics: \(error.localizedDescription)")
            return
        }
        
        if characteristic.UUID.isEqual(CBUUID(string: kEventCharacterisitcUUID))
        {
            var data = characteristic.value
            var values = [UInt8](count:data.length, repeatedValue:0)
            data.getBytes(&values, length:data.length)
            println("[kys]byte=\(values)")
            
            if (values[0] == 0x3) {
                println("Clicked");
            } else if (values[0] == 0x4) {
                println("Double Clicked");
            } else if (values[0] == 0x5) {
                println("Triple Clicked");
            } else if (values[0] == 0x6) {
                println("Long Pressed");
            }
        }
    }
}