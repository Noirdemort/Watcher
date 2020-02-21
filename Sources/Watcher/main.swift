import Foundation
import CryptoSwift

var account = Account.loadAccount(username: "noir", email: nil)
print(Project.readProjects(account: account))
