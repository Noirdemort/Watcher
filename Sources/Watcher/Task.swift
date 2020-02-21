//
//  Task.swift
//  Watcher
//
//  Created by Noirdemort on 21/02/20.
//

import Foundation

enum Priority: String, Codable {
    case low
    case medium
    case high
}

enum Status: String, Codable {
    case abort
    case waiting
    case inProgress
    case completed
}

protocol CoreTask: Codable {
    var key: String { get set }
    var priority: Priority { get set }
    var objective: String { get set }
    var description: String { get set }
    var start: String? { get set }
    var end: String? { get set }
    var status: Status { get set }
    var dependentOn: String? { get set }
    var projectId: String  { get set }
    var author: String { get set }
    
    static func newTask(account: Account, project: inout Project) -> Self
    static func loadTask()
    func addReminder()
    func editTask()
    func dropTask()
}


struct Task: CoreTask {
    
    var key: String
    
    var priority: Priority
    
    var objective: String
    
    var description: String
    
    var start: String?
    
    var end: String?
    
    var status: Status
        
    var dependentOn: String?
    
    var projectId: String
    
    var author: String
    
    
    static func newTask(account: Account, project: inout Project) -> Task {
        var key = consoleInput(annotation: "Enter task id (Optional): ", required: false)
        if key.isEmpty {
            key = UUID().uuidString
        }
        let priority = consoleInput(annotation: "Enter priority [low|medium|high]: ")
        let objective = consoleInput(annotation: "Enter task objective: ")
        let desc = consoleInput(annotation: "Enter task description: ")
        let start = consoleInput(annotation: "Enter start date (Optional): ", required: false).engageSecure()
        let end = consoleInput(annotation: "Enter expected end date (Optional): ", required: false).engageSecure()
        let status = consoleInput(annotation: "Enter current status [ waiting | inProgress | completed | abort ]: ")
        let dependency = consoleInput(annotation: "Enter comma separated task id(s) this task depends on (Optional): ", required: false).engageSecure()
        
        
        let task = Task(key: key, priority: Priority(rawValue: priority)!, objective: objective, description: desc, start: start, end: end, status: Status(rawValue: status)!, dependentOn: dependency, projectId: project.id, author: account.username)
        
        project.tasks.append(task)
        
        return task
        
    }
    
    static func loadTask() {
        <#code#>
    }
    
    func addReminder() {
        
    }
    
    func editTask() {
        <#code#>
    }
    
    func dropTask() {
        
    }
}
