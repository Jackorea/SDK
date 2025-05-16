import Foundation

public struct SignalDecoder {
    public static func decodeEEG(from data: Data) -> [(ch1: Float, ch2: Float)] {
        var result: [(Float, Float)] = []
        guard data.count >= 179 else { return result }

        for i in stride(from: 4, to: 179, by: 7) {
            let ch1 = Int32(data[i+1]) << 16 | Int32(data[i+2]) << 8 | Int32(data[i+3])
            let ch2 = Int32(data[i+4]) << 16 | Int32(data[i+5]) << 8 | Int32(data[i+6])
            let ch1Signed = ch1 & 0x800000 != 0 ? ch1 - 0x1000000 : ch1
            let ch2Signed = ch2 & 0x800000 != 0 ? ch2 - 0x1000000 : ch2

            let scale: Float = 4.033 / 12 / Float((1 << 23) - 1) * 1_000_000
            result.append((Float(ch1Signed) * scale, Float(ch2Signed) * scale))
        }
        return result
    }

    public static func decodePPG(from data: Data) -> [(red: Int, ir: Int)] {
        var result: [(Int, Int)] = []
        for i in stride(from: 4, to: 172, by: 6) {
            let red = Int(data[i]) << 16 | Int(data[i+1]) << 8 | Int(data[i+2])
            let ir  = Int(data[i+3]) << 16 | Int(data[i+4]) << 8 | Int(data[i+5])
            result.append((red, ir))
        }
        return result
    }

    public static func decodeACC(from data: Data) -> [(x: Int8, y: Int8, z: Int8)] {
        var result: [(Int8, Int8, Int8)] = []
        for i in stride(from: 4, to: 184, by: 6) {
            result.append((Int8(bitPattern: data[i+1]),
                           Int8(bitPattern: data[i+3]),
                           Int8(bitPattern: data[i+5])))
        }
        return result
    }
}
