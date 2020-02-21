//
//  Project.swift
//  Watcher
//
//  Created by Noirdemort on 21/02/20.
//

import Foundation



protocol CoreProject: Codable, Equatable {
    
    var id: String { get set }
    var name: String { get set }
    var category: String? { get set }
    var tags: String? { get set }
    var description: String { get set }
    var createdBy: String { get }
    var tasks: [Task] { get set }
    
    static func createNewProject(account: inout Account) -> Self
    static func loadProject(account: Account) -> Self?
    func addFiles() throws
    func modifyProject()
    func deleteProject()
    
}


struct Project: CoreProject {
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.createdBy == rhs.createdBy
    }
    
    var id: String
    
    var name: String
    
    var category: String?
    
    var tags: String?
    
    var description: String
    
    var createdBy: String
    
    var tasks: [Task] = []
    
    
    static func createNewProject( account: inout Account) -> Project {
        var id = consoleInput(annotation: "Enter project id (Optional): ", required: false, secureInput: false)
        if id.isEmpty {
            id = UUID().uuidString
        }
        let name = consoleInput(annotation: "Enter project name: ")
        let description = consoleInput(annotation: "Enter project description: ")
        let category = consoleInput(annotation: "Enter project category (Optional): ", required: false).engageSecure()
        let tags = consoleInput(annotation: "Enter project tags (Optional): ", required: false).engageSecure()
        let project = Project(id: id, name: name, category: category, tags: tags, description: description, createdBy: account.username)
        account.projects.append(project)
        return project
    }
    
    static func loadProject(account: Account) -> Project? {
        let name = consoleInput(annotation: "Enter project name: ")
        
        let projects = account.projects
        let selection = projects.filter({ $0.createdBy == account.username && $0.name == name })
        return selection.first
        
    }
    
    static func readProjects(account: Account) -> [Project] {
        let projects: [Project] = account.projects
        return projects
    }
    
    func addFiles() throws {
        let filePath = consoleInput(annotation: "Enter file path: ")
        do {
            try JSOC.jdam.fileManager.copyItem(atPath: filePath, toPath: JSOC.jdam.fileManager.currentDirectoryPath)
        } catch {
            print("[!] No such file exists!!")
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
        
    }
    
    
    func modifyProject() {
        
    }
    
    func deleteProject() {
        
    }
    
    func exportProject(account: Account) {
        
    }
    
    
}
