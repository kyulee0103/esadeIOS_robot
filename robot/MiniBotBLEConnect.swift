//
//  MiniBotBLEConnect.swift
//  robot
//
//  Created by 권규리 on 2023/11/14.
//

import Foundation
import CoreBluetooth
import UIKit


/*
 *
 *
 */
class MiniBotBLEConnect : NSObject, ObservableObject {

    // MARK: - BLE
    private var centralQueue: DispatchQueue?

    private var serviceUUID:CBUUID!
    private var inputCharUUID:CBUUID!
    private var inputChar: CBCharacteristic?
    private var outputCharUUID:CBUUID!
    private var outputChar: CBCharacteristic?
    
    // service and peripheral objects
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?

    
    // MARK: - Interface
    @Published var output = "Desconnetat "  // current text to display in the output field
    @Published var connected = false        // true when BLE connection is active
    
    // MARK: - Calculations
    private var operatorSymbol = ""
    
    private var view_status:UIButton!
    
    
    
    /*
     * Constructor
     */
    init(view_status: UIButton) {
        self.view_status = view_status
    }

    
    
    /*
     * Constructor
     */
    init(view_status: UIButton, bot:Int) {
        super.init()
        self.view_status = view_status
        selectBot(bot: bot)
    }

    
    
    /*
     *
     */
    func selectBot(bot: Int) {
        switch bot {
            case 1:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0001")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0001")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0001")
            case 2:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0002")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0002")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0002")
            case 3:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0003")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0003")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0003")
            case 4:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0004")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0004")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0004")
            case 5:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0005")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0005")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0005")
            case 6:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0006")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0006")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0006")
            case 7:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0007")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0007")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0007")
            case 8:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0008")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0008")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0008")
            case 9:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0009")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0009")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0009")
            case 10:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0010")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0010")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0010")
            case 11:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0011")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0011")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0011")
            default:
                serviceUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0A0000")
                inputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0C0000")
                outputCharUUID = CBUUID(string: "EBC0FCC1-2FC3-44B7-94A8-A08D0A0B0000")
        }
        
    }
    
    
    
    /*
     * Send bytes.
     */
    func send(vals:[UInt8]) {
        guard let peripheral = connectedPeripheral,
              let inputChar = inputChar else {
            output = "Error de connexió !!!"
            return
        }
                
        peripheral.writeValue(Data(vals), for: inputChar, type: .withoutResponse)
    }
    
    
    
    /*
     * Send string.
     */
    func send(str: String) {
        let valueString = (str as String).data(using: .utf8)
        if let periferic = connectedPeripheral {
            if let txCharacteristic = inputChar {
                periferic.writeValue(valueString!, for: txCharacteristic, type: .withResponse)
            }
        }
    }

    
    
    /*
     *
     */
    func connectServer() {
        output = "Connecting ..."
        centralQueue = DispatchQueue(label: "test.discovery")
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    
    
    /*
     *
     */
    func disconnectServer() {
        print("Disconnecting ...")
        guard let manager = centralManager,
              let peripheral = connectedPeripheral else { return }
        
        manager.cancelPeripheralConnection(peripheral)
    }
    
    
} // Fi CalculatorViewModel
extension MiniBotBLEConnect: CBCentralManagerDelegate {

    /*
     * This method monitors the Bluetooth radios state
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOff:
                print("Central Manager state: BLE is powered off.")
            case .poweredOn:
                print("Central Manager state: BLE is poweredOn.")
                central.scanForPeripherals(withServices: [serviceUUID])
            case .resetting:
                print("Central Manager state: BLE is resetting.")
            case .unauthorized:
                print("Central Manager state: BLE is unauthorized.")
            case .unknown:
                print("Central Manager state: BLE is unknown.")
            case .unsupported:
                print("Central Manager state: BLE is unsupported.")
             default:
                print("Central Manager state: Error !!")
        }
        
    }

    
    
    /*
     * Called for each peripheral found that advertises the serviceUUID.
     * This test program assumes only one peripheral will be powered up.
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "UNKNOWN")")
        central.stopScan()
        
        connectedPeripheral = peripheral
        central.connect(peripheral, options: nil)
    }

    
    /*
     * After BLE connection to peripheral, enumerate its services.
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "UNKNOWN")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        DispatchQueue.main.async {
            self.view_status.tintColor = UIColor.init(red: 0, green: 0.7, blue: 0, alpha: 1)
            self.view_status.setTitle("Disconnect", for: .normal)
            
            var config = UIButton.Configuration.filled ()
            config.subtitle = "(connected)"
            config.titleAlignment = .center
            self.view_status.configuration = config
        }
    }
    
    
    /*
     * After BLE connection, cleanup.
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "UNKNOWN")")
        
        centralManager = nil
        
        DispatchQueue.main.async {
            self.connected = false
            self.output = "Disconnected"
            self.view_status.tintColor = UIColor.init(red: 0.7, green: 0, blue: 0, alpha: 1)
            self.view_status.setTitle("Connect", for: .normal)

            var config = UIButton.Configuration.filled ()
            config.subtitle = "(disconnected)"
            config.titleAlignment = .center
            self.view_status.configuration = config
        }
    }
    
} // Fi CBCentralManagerDelegate.
extension MiniBotBLEConnect : CBPeripheralDelegate {
    
    /*
     *
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Descobert servei pel perifèric -> \(peripheral.name ?? "DESCONEGUT !!")")
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    
    /*
     *
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Descoberta característica pel perifèric -> \(peripheral.name ?? "DESCONEGUT !!")")
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        for ch in characteristics {
            switch ch.uuid {
                case inputCharUUID:
                    inputChar = ch
                case outputCharUUID:
                    outputChar = ch
                    // subscribe to notification events for the output characteristic
                    peripheral.setNotifyValue(true, for: ch)
                default:
                    break
            }
        }
        
        DispatchQueue.main.async {
            self.connected = true
            self.output = "Connected."
        }
    }
    
    
    
    /*
     *
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Notification state changed to \(characteristic.isNotifying)")
    }
    
    
    
    /*
     * Rep resposta del server ESP32.
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Characteristic updated: \(characteristic.uuid)")
        if characteristic.uuid == outputCharUUID, let data = characteristic.value {
            // Sortida amb string
            let str = String(decoding: data, as: UTF8.self)
            print("Recibet: \(str)")
            DispatchQueue.main.async { [self] in
                view_status.setTitle("Batt: " + str + "%", for: .normal)
            }
        }
    }

} // Fi CBPeripheralDelegate


