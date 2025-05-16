import Foundation
import Combine

public class DataBuffer: ObservableObject {
    @Published public var eeg1 = [Float]()
    @Published public var eeg2 = [Float]()
    @Published public var ppg = [Int]()
    @Published public var ppgIr = [Int]()
    @Published public var accX = [Int8]()
    @Published public var accY = [Int8]()
    @Published public var accZ = [Int8]()

    public func appendEEG(ch1: Float, ch2: Float) {
        eeg1.append(ch1); eeg2.append(ch2)
    }
    public func appendPPG(red: Int, ir: Int) {
        ppg.append(red); ppgIr.append(ir)
    }
    public func appendACC(x: Int8, y: Int8, z: Int8) {
        accX.append(x); accY.append(y); accZ.append(z)
    }

    public func clear() {
        eeg1.removeAll(); eeg2.removeAll()
        ppg.removeAll(); ppgIr.removeAll()
        accX.removeAll(); accY.removeAll(); accZ.removeAll()
    }
}
