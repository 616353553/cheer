//
//  ProfessorList.swift
//  cheer
//
//  Created by bainingshuo on 2018/1/7.
//  Copyright © 2018年 Evolvement Apps. All rights reserved.
//

import Foundation

class ProfessorList {
    
    private var professors: [Professor]!
    
    init() {
        self.professors = []
    }
    
    init(professorRefs: [String]) {
        self.professors = []
        for professorRef in professorRefs {
            professors.append(Professor(reference: professorRef))
        }
    }
    
    func append(_ professor: Professor) {
        self.professors.append(professor)
    }
    
    subscript(index: Int) -> Professor {
        get {
            return professors[index]
        }
        set(newValue) {
            professors[index] = newValue
        }
    }
    
    func getReferences() -> [String] {
        var references = [String]()
        for professor in professors {
            if let professorRef = professor.getReference() {
                references.append(professorRef)
            }
        }
        return references
    }
    
    func isEmpty() -> Bool {
        return professors.isEmpty
    }
    
    func count() -> Int {
        return professors.count
    }
    
    func remove(at index: Int) {
        self.professors.remove(at: index)
    }
}
