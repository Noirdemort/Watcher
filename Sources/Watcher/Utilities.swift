//
//  Utilities.swift
//  Watcher
//
//  Created by Noirdemort on 21/02/20.
//

import Foundation


// MARK:- Global Functions
func consoleInput(annotation: String, required: Bool = true, secureInput: Bool = false) -> String {
    
    var input: String
    
    if secureInput {
        
        var buf = [CChar](repeating: 0, count: 8192)
        guard let passphrase = readpassphrase(annotation, &buf, buf.count, 0) else {
            print("[!] Pointer error")
            exit(EXIT_FAILURE)
        }
        input = String(validatingUTF8: passphrase) ?? ""
        
    } else {
        
        print(annotation, separator: "\n", terminator: "")
        input = readLine(strippingNewline: true) ?? ""
        
    }
    
    if required && input.isEmpty {
        print("[!] Input Error")
        exit(EXIT_FAILURE)
    }
    
    return input
    
}


// MARK:- Extensions

extension String {
    func engageSecure() -> String?{
        if self.isEmpty {
            return nil
        }
        return self
    }
}


// MARK:- Data to [bytes]
extension Data {
    var bytes : [UInt8]{
        return [UInt8](self)
    }
}


// MARK:- [bytes] to Data
extension Array where Element == UInt8 {
    var data : Data{
        return Data(self)
    }
}
