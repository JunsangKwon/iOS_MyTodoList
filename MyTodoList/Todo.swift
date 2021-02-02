//
//  Todo.swift
//  MyTodoList
//
//  Created by 권준상 on 2021/01/30.
//

import UIKit

struct Todo: Equatable {
    let id: Int
    var isDone: Bool
    var detail: String
    
    mutating func update(isDone: Bool, detail: String) {
        self.isDone = isDone
        self.detail = detail
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}

class TodoViewModel {
    
    static var lastId: Int = 0
    var todos: [Todo] = []
    
    func createTodo(detail: String) -> Todo {
        let nextId = TodoViewModel.lastId + 1
        TodoViewModel.lastId = nextId
        return Todo(id: nextId, isDone: false, detail: detail)
    }
    
    var numOfTodoList: Int {
        return todos.count
    }
    
    func addTodo(todo: Todo) {
        todos.append(todo)
    }
    
    func deleteTodo(todo: Todo) {
        todos = todos.filter{existingTodo in
            return existingTodo.id != todo.id
        }
    }
    
    func updateTodo(_ todo: Todo) {
        //[x] TODO: update 로직 추가
        if let index = todos.firstIndex(of: todo) {
            todos[index].update(isDone: todo.isDone, detail: todo.detail)
        }
    }
    
}

