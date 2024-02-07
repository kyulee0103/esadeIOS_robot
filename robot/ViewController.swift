//
//  ViewController.swift
//  robot
//
//  Created by 권규리 on 2023/11/14.
//

import UIKit

class ViewController: UIViewController {

    var miniBotBleConnect:MiniBotBLEConnect!
    
    @IBOutlet weak var buttonConnect: UIButton!
    /*
     * Send command both motors.
     * dir_l: 0 forward rotation left, 1 backward rotation left.
     * dir_r: 0 forward rotation right, 1 backward rotation right.
     * power_l: motor power left (0 to 100).
     * power_r: motor power right(0 to 100).
     */
    var dir_l = 0
    var dir_r = 0
    var power_l = 0
    var power_r = 0
    
    
    
    /*
     * Inicializaciones.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buttonConnect.tintColor = UIColor.init(red: 0.7, green: 0, blue: 0, alpha: 1)
        buttonConnect.setTitle("Connect", for: .normal)
        var config = UIButton.Configuration.filled ()
        config.subtitle = "(disconnected)"
        config.titleAlignment = .center
        buttonConnect.configuration = config
        miniBotBleConnect =  MiniBotBLEConnect(view_status: buttonConnect, bot: 2)
        miniBotBleConnect.connectServer()
    }


    
    // ****************************************************
    // ************** Bluetooth button action *************
    // ****************************************************
//    @IBAction func actionButtonConnect(_ sender: Any) {
//        if !miniBotBleConnect.connected {
//            miniBotBleConnect.connectServer()
//        } else {
//            miniBotBleConnect.disconnectServer()
//        }
//    }
    
    @IBAction func actionButtonConnect(_ sender: Any) {
        if !miniBotBleConnect.connected{
            miniBotBleConnect.connectServer()
        }
        else {
            miniBotBleConnect.disconnectServer()
        }
    }
    
    
    
    // ****************************************************
    // ************* Button motors actions ****************
    // ****************************************************
    
    @IBAction func actionButtonLeftDown_F(_ sender: Any) {
        dir_l = 0
        power_l = 100
        sendMotorCommand()
        print("Forward Left Down")
    }
    
    @IBAction func actionButtonLeftUp_F(_ sender: Any) {
        dir_l = 0
        power_l = 0
        sendMotorCommand()
        print("Forward Left Up")
    }
    
//    @IBAction func actionButtonLeftDown_B(_ sender: Any) {
//        dir_l = 1
//        power_l = 100
//        sendMotorCommand()
//        print("Backward Left Down")
//    }
//
//    @IBAction func actionButtonLeftUp_B(_ sender: Any) {
//        dir_l = 1
//        power_l = 0
//        sendMotorCommand()
//        print("Backward Left up")
//    }
    
    @IBAction func actionButtonLeftDown_B(_ sender: Any) {
        dir_l = 1
        power_l = 100
        sendMotorCommand()
        print("Backward Left Down")
    }
    @IBAction func actionButtonLeftUp_B(_ sender: Any) {
        dir_l = 1
        power_l = 0
        sendMotorCommand()
        print("Backward Left Up")
    }
    
    
    @IBAction func actionButtonRightDown_F(_ sender: Any) {
        dir_r = 0
        power_r = 100
        sendMotorCommand()
        print("Forward Right Down")
    }

    @IBAction func actionButtonRightUp_F(_ sender: Any) {
        dir_r = 0
        power_r = 0
        sendMotorCommand()
        print("Forward Right Up")
    }
    
    @IBAction func actionButtonRightDown_B(_ sender: Any) {
        dir_r = 1
        power_r = 100
        sendMotorCommand()
        print("Backward Right Down")
    }

    @IBAction func actionButtonRightUp_B(_ sender: Any) {
        dir_r = 1
        power_r = 0
        sendMotorCommand()
        print("Backward RIght up")
    }
    
    @IBAction func actionSliderLeftMotor(_ sender: UISlider) {
        let powerValue = Int(sender.value)
        power_l = powerValue
        sendMotorCommand()
        print("Left Motor Power: \(powerValue)")

    }
    
    
    @IBAction func actionSliderRightMotor(_ sender: UISlider) {
        let powerValue = Int(sender.value)
        power_r = powerValue
        sendMotorCommand()
        print("Right Motor Power: \(powerValue)")
        
    }
    
    func sendMotorCommand() {
        // Example of command.
        // CC+D+PPP+D+PPP -> 0101501080 -> 01 1 050 0 080
        // CC: 01 -> command type (motor control command).
        // D: 1 -> backward rotation.
        // PPP: 050 -> power 50%.
        
        var str_comm:String = "01"
        
        // Check 'dir' value [0 <= dir <= 1].
        var dr_l = dir_l
        if dr_l < 0 {
        dr_l = 0
            print("Error in sendMotorCommand: 'dir' value < 0")
        } else if dr_l > 1 {
            dr_l = 1
            print("Error in sendMotorCommand: 'dir' value > 1")
        }
        
        // Check 'dir_r' value [0 <= dir <= 1].
        var dr_r = dir_r
        if dr_r < 0 {
        dr_r = 0
            print("Error in sendMotorCommand: 'dir' value < 0")
        } else if dr_r > 1 {
            dr_r = 1
            print("Error in sendMotorCommand: 'dir' value > 1")
        }
        
        // Check 'power_l' value [0 <= power <= 100].
        var pwr_l = power_l
        if pwr_l < 0 {
            pwr_l = 0
            print("Error in sendMotorCommand: 'power' value < 0")
        } else if pwr_l > 100 {
            pwr_l = 100
            print("Error in sendMotorCommand: 'power' value > 100")
        }
        
        // Check 'power_r' value [0 <= power <= 100].
        var pwr_r = power_r
        if pwr_r < 0 {
            pwr_r = 0
            print("Error in sendMotorCommand: 'power' value < 0")
        } else if pwr_r > 100 {
            pwr_r = 100
            print("Error in sendMotorCommand: 'power' value > 100")
        }
        
        // Appending dir_l to the command string.
        str_comm = str_comm + String(dr_l)
        
        // Appending power_l to the command string.
        if (pwr_l < 100) && (pwr_l > 10) {
            // Appending an extra '0' to keep the total number of characters.
            str_comm = str_comm + "0" + String(pwr_l)
        } else if (pwr_l < 10) {
            // Appending an extra '00' to keep the total number of characters.
            str_comm = str_comm + "00" + String(pwr_l)
        } else {
            str_comm = str_comm + String(pwr_l)
        }

        // Appending dir_r to the command string.
        str_comm = str_comm + String(dr_r)

        // Appending power_r to the command string.
        if (pwr_r < 100) && (pwr_r > 10) {
            // Appending an extra '0' to keep the total number of characters.
            str_comm = str_comm + "0" + String(pwr_r)
        } else if (pwr_r < 10) {
            // Appending an extra '00' to keep the total number of characters.
            str_comm = str_comm + "00" + String(pwr_r)
        } else {
            str_comm = str_comm + String(pwr_r)
        }


        // Check if BLE connection is alive before sending.
        if miniBotBleConnect.connected {
            // Sending command.
            miniBotBleConnect.send(str: str_comm)
            print("Sending command: \(str_comm)")
        } else {
            print("Error in sendMotorCommand: bluetooth not connected !!")
        }
    }
    
    
} // End class.

