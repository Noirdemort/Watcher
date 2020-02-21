//
//  Account.swift
//  Watcher
//
//  Created by Noirdemort on 21/02/20.
//

import Foundation
import CryptoSwift

protocol Security {
    func encrypt(plaintext: String, key: String?, iv: String?) -> [UInt8]
    static func sha(text: String) -> String
    func decrypt(ciphertext: [UInt8], key: String?, iv: String?) -> String
    static func saltGenerator(length: Int) -> String
}


protocol CoreAccount: Codable, Equatable, Security {
    var username: String { get set }
    var password: String { get set }
    var email: String { get set }
    var salt: String { get set }
    var projects: [Project] { get set }
    
    static func newAccount() -> Self
    static func login() -> Self?
    static func loadAccount(username: String, email: String?) -> Self
    mutating func updateProject(_ project: Project)
    mutating func deleteProject(_ project: Project)
    func exportAccount(encrypted: Bool)
    static func verify(username: String, currentKey: String) -> Self?
    func signOut()
}


struct Account: CoreAccount {
    
    var username: String
    
    var password: String
    
    var email: String
    
    var salt: String
    
    var projects: [Project] = []

    
    static func newAccount() -> Account {
        let username = consoleInput(annotation: "Enter Username: ")
        
        let password = consoleInput(annotation: "Secure key: ", secureInput: true)
        
        let confirmedPassword = consoleInput(annotation: "Confirm Key: ", secureInput: true)
        
        if confirmedPassword != password {
            print("[!] Passwords mismatch.")
            exit(EXIT_FAILURE)
        }
        
        let email = consoleInput(annotation: "Enter email: ")
        
        let salt = saltGenerator()
        
        return Account(username: username, password: password, email: email, salt: salt)
    }
    
    
    static func login() -> Account? {
        print("[*] Login Terminal")
        let username = consoleInput(annotation: "Enter Username: ")
        let password = consoleInput(annotation: "Secure key: ", secureInput: true)
        
        if var account = verify(username: username, currentKey: password) {
            print("[+] Login Successful!!")
            account.password = password
            return account
        }
        
        print("[!] Invalid Credentials")
        exit(EXIT_FAILURE)
    }
    
    
    static func verify(username: String, currentKey: String) -> Account? {
        let account = loadAccount(username: username, email: nil)
        if sha(text: currentKey + account.salt) == account.password {
            return account
        }
        
        return nil
    }
    
    static func loadAccount(username: String, email: String?) -> Account {
        let accounts = JSOC.jdam.allAccounts
        guard let account =  accounts.first(where: { $0.username == username}) else {
            print("[!] No such account!!")
            exit(EXIT_FAILURE)
        }
        
        return account
    }
    
    mutating func updateProject(_ project: Project) {
        self.projects.removeAll(where: { $0.id == project.id })
        self.projects.append(project)
    }
    
    
    mutating func deleteProject(_ project: Project) {
        self.projects.removeAll(where: { $0.id == project.id })
    }
    
    
    func exportAccount(encrypted: Bool) {
        JSOC.jdam.updateCore(self)
        do {
            try JSOC.jdam.saveJSON(encrypt: encrypted)
        } catch {
            print("[!] Cannot update target.")
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
    }
    
    
    func signOut() {
        exit(EXIT_SUCCESS)
    }
    
    
    internal func encrypt(plaintext: String, key: String?, iv: String?) -> [UInt8]{
        let encryptionKey = key ?? consoleInput(annotation: "Enter encryption key: ", required: true, secureInput: true)
        
        let randomIV = iv ?? consoleInput(annotation: "Enter IV value: ", required: true, secureInput: true)
        
        print("""
        AES-128 = 16 bytes
        AES-192 = 24 bytes
        AES-256 = 32 bytes
        """)
        do {
            let aes = try AES(key: encryptionKey, iv: randomIV)
            let ciphertext = try aes.encrypt(Array(plaintext.utf8))
            return ciphertext
        } catch {
            print("[!] Encryption Failed")
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
    }
    
    
    static func sha(text: String) -> String {
        return text.sha512()
    }
    
    
    internal func decrypt(ciphertext: [UInt8], key: String?, iv: String?) -> String {
        let encryptionKey = key ?? consoleInput(annotation: "Enter encryption key: ", required: true, secureInput: true)
        
        let randomIV = iv ?? consoleInput(annotation: "Enter IV value: ", required: true, secureInput: true)
        
        print("""
        AES-128 = 16 bytes
        AES-192 = 24 bytes
        AES-256 = 32 bytes
        """)
        do {
            let aes = try AES(key: encryptionKey, iv: randomIV)
            let plaintext = try aes.decrypt(ciphertext)
            return String(bytes: plaintext, encoding: .utf8)!
        } catch {
            print("[!] Encryption Failed")
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
    }
    
    
    static func saltGenerator(length: Int = 10) -> String {
        return UUID().uuidString
    }
}

