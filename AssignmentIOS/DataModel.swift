//
//  DataModel.swift
//  AssignmentIOS
//
//  Created by User on 14/04/21.
//

import Foundation

struct DataModel: Codable {
    var results: [Person]?
    var next: String?
    var previous: String?
}

struct Person: Codable {
    var name: String
    var gender: String?
    var eyeColor: String?
    var height: String
    var mass: String
    var hairColor: String?
    
    private enum CodingKeys: String, CodingKey {
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
        case name,gender,height,mass
    }
}



struct FilterDataModel {
    var collections: [Person]?
    var filterType: String?
    var filterSpecificType: String?
    
}
