import Foundation

/// TODO: Using Some Command Line for Interface

let args = CommandLine.arguments
var account = Account.loadAccount(username: "user", email: nil)
print(Project.readProjects(account: account))
