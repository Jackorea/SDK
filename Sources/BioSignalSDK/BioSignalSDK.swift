public class BioSignalSDK {
    public static let shared = BioSignalSDK()

    private let bleManager = BLEManager()
    public var buffer: DataBuffer { bleManager.dataBuffer }

    public func startScanning() {
        bleManager.startScanning()
    }

    public func connectToDevice(name: String?) {
        bleManager.connectToDevice(named: name)
    }

    public func disconnect() {
        bleManager.disconnect()
    }

    public func startReceiving() {
        bleManager.subscribeAll()
    }

    public func stopReceiving() {
        bleManager.unsubscribeAll()
    }
}
