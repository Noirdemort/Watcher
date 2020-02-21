import Foundation

/// TODO: Using Some Command Line for Interface

var account = Account.loadAccount(username: "noir", email: nil)
print(Project.readProjects(account: account))
