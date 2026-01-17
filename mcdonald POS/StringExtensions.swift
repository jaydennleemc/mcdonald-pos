//
//  StringExtensions.swift
//  mcdonald POS
//
//  String extensions for MD5 hashing and date parsing
//

import Foundation
import CryptoKit

extension String {
    var md5Value: String {
        guard let data = self.data(using: .utf8) else {
            return ""
        }
        return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
    }

    func toDate(withFormat format: String = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        return date
    }
    
    var bool: Bool? {
        let lowercaseSelf = self.lowercased()
        switch lowercaseSelf {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
