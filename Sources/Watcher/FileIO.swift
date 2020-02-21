//
//  FileIO.swift
//  Watcher
//
//  Created by Noirdemort on 21/02/20.
//

import Foundation
import CryptoSwift


protocol JSONOperator {
    func readJSON(encrypted: Bool) throws -> [Account]
    mutating func updateCore(_ account: Account)
    func saveJSON(encrypt: Bool) throws
}


struct JSOC: JSONOperator {
  
    static var jdam = JSOC()
    
    let fileManager = FileManager()
    let file = "blackburn.json"
    
    var allAccounts: [Account] = []
    
    
    private init() {
        allAccounts = try! readJSON()
    }
    
    
    func readJSON(encrypted: Bool = false) throws -> [Account] {
        
        guard let dir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("[!] Can't retrieve the resource")
            exit(EXIT_FAILURE)
        }
        
        let fileURL = dir.appendingPathComponent(self.file)
        
        var data = try Data(contentsOf: fileURL)
        
        if encrypted {
            let bytes = [UInt8](data)
            let secureKey = consoleInput(annotation: "Enter decryption key: ", required: true, secureInput: true)
            let iv = consoleInput(annotation: "Enter decryption IV: ", required: true, secureInput: true)
            let aes = try AES(key: secureKey, iv: iv)
            data = try aes.decrypt(bytes).data
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode([Account].self, from: data)
        
    }
    
    mutating func updateCore(_ account: Account) {
        self.allAccounts.removeAll(where: { $0.username == account.username })
        self.allAccounts.append(account)
    }
    
    
    func saveJSON(encrypt: Bool = false) throws {
        let encoder = JSONEncoder()
        var data = try encoder.encode(self.allAccounts)
        
        guard let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("[!] Can't retrieve the resource")
            exit(EXIT_FAILURE)
        }
        
        let fileURL = dir.appendingPathComponent(self.file)
        
        if encrypt {
            let bytes = [UInt8](data)
            let secureKey = consoleInput(annotation: "Enter encryption key: ", required: true, secureInput: true)
            let iv = consoleInput(annotation: "Enter encryption IV: ", required: true, secureInput: true)
            let aes = try AES(key: secureKey, iv: iv)
            data = try aes.encrypt(bytes).data
        }
        
        try data.write(to: fileURL, options: .atomic)
        
    }
    
}
