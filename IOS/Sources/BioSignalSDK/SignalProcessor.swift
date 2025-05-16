public struct SignalProcessor {
    public static func notchFilter(data: [Float], fs: Float, freq: Float, q: Float) -> [Float] {
        // Accelerate를 활용해 IIR Notch 필터 구성
    }

    public static func bandpassFilter(data: [Float], fs: Float, low: Float, high: Float) -> [Float] {
        // Butterworth 필터 구성
    }

    public static func calculateSpO2(red: [Float], ir: [Float]) -> Float? {
        // Python 코드를 Swift로 변환한 SpO2 계산식 적용
    }

    public static func calculateBPM(ppg: [Float], fs: Float) -> Float {
        // 피크 감지 알고리즘 적용
    }
}
