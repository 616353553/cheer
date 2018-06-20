//
//  Professor.swift
//  cheer
//
//  Created by bainingshuo on 2018/1/6.
//  Copyright © 2018年 Evolvement Apps. All rights reserved.
//

import Foundation

struct ProfessorStruct {
    var reference: String?
    var professorName: String?
    var unipediaRef: String?
    var image: ImageData?
}

class Professor {
    
    private var data: ProfessorStruct!
    
    init(reference: String) {
        data = ProfessorStruct()
        data.reference = reference
    }
    
    
    
    
    // Getters
    
    func getReference() -> String? {
        return data.reference
    }
    
    func getProfessorName() -> String? {
        return data.professorName
    }
    
    
    
    func retrieveData() {
        
    }
}
