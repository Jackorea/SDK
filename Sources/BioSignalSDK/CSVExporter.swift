// CSVExporter.swift
import Foundation

public class CSVExporter {
    private var lines: [String] = []
    private let delimiter: String
    private let headers: [String]

    public init(headers: [String], delimiter: String = ",") {
        self.headers = headers
        self.delimiter = delimiter
        self.lines.append(headers.joined(separator: delimiter))
    }

    public func appendRow(_ values: [CustomStringConvertible]) {
        let row = values.map { $0.description }.joined(separator: delimiter)
        lines.append(row)
    }

    public func export(to filename: String) throws -> URL {
        let content = lines.joined(separator: "\n")
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        try content.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    public func clear() {
        lines = [headers.joined(separator: delimiter)]
    }
} 
