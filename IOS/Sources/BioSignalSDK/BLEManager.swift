import Foundation
import CoreBluetooth

public protocol BLEManagerDelegate: AnyObject {
    func didReceiveEEG(ch1: Float, ch2: Float)
    func didReceivePPG(red: Int, ir: Int)
    func didReceiveACC(x: Int8, y: Int8, z: Int8)
}

public class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    public weak var delegate: BLEManagerDelegate?

    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var characteristics = [CBUUID: CBCharacteristic]()

    private let EEG_NOTIFY_UUID = CBUUID(string: "00ab4d15-66b4-0d8a-824f-8d6f8966c6e5")
    private let PPG_CHAR_UUID   = CBUUID(string: "6c739642-23ba-818b-2045-bfe8970263f6")
    private let ACC_CHAR_UUID   = CBUUID(string: "d3d46a35-4394-e9aa-5a43-e7921120aaed")

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    public func startScan() {
        centralManager.scanForPeripherals(withServices: nil)
    }

    public func connect(to peripheral: CBPeripheral) {
        self.peripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Bluetooth not available")
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                                advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for char in service.characteristics ?? [] {
            characteristics[char.uuid] = char
            peripheral.setNotifyValue(true, for: char)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }

        if characteristic.uuid == EEG_NOTIFY_UUID {
            let samples = SignalDecoder.decodeEEG(from: data)
            samples.forEach { delegate?.didReceiveEEG(ch1: $0.ch1, ch2: $0.ch2) }
        }
        if characteristic.uuid == PPG_CHAR_UUID {
            let samples = SignalDecoder.decodePPG(from: data)
            samples.forEach { delegate?.didReceivePPG(red: $0.red, ir: $0.ir) }
        }
        if characteristic.uuid == ACC_CHAR_UUID {
            let samples = SignalDecoder.decodeACC(from: data)
            samples.forEach { delegate?.didReceiveACC(x: $0.x, y: $0.y, z: $0.z) }
        }
    }
}
