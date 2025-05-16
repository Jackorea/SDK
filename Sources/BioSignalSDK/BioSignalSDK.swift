import Foundation
import Combine

public class BioSignalSDK: ObservableObject {
    public static let shared = BioSignalSDK()

    @Published public private(set) var buffer = DataBuffer()

    private let bleManager = BLEManager()

    private init() {
        // 초기화 시 BLE 콜백에서 buffer 업데이트 연동
        bleManager.onEEG = { [weak self] ch1, ch2 in
            DispatchQueue.main.async {
                self?.buffer.eeg1.append(ch1)
                self?.buffer.eeg2.append(ch2)
            }
        }
        bleManager.onPPG = { [weak self] red, ir in
            DispatchQueue.main.async {
                self?.buffer.ppg.append(red)
                self?.buffer.ppgIr.append(ir)
            }
        }
        bleManager.onACC = { [weak self] x, y, z in
            DispatchQueue.main.async {
                self?.buffer.accX.append(x)
                self?.buffer.accY.append(y)
                self?.buffer.accZ.append(z)
            }
        }
    }

    public func scanAndConnect(deviceName: String) {
        bleManager.scanAndConnect(to: deviceName)
    }

    public func exportEEG(filename: String) throws {
        let csv = CSVExporter(headers: ["timestamp", "eeg1", "eeg2"])
        for (i, ch1) in buffer.eeg1.enumerated() {
            let ch2 = buffer.eeg2[safe: i] ?? 0
            let ts = Date().timeIntervalSince1970
            csv.appendRow([ts, ch1, ch2])
        }
        _ = try csv.export(to: filename)
    }

    public var isConnected: Bool {
        bleManager.isConnected
    }
}
