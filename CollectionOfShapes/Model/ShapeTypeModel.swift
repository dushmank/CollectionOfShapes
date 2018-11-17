//
//  ShapeTypeModel.swift
//  CollectionOfShapes
//
//  Created by Kyle Dushman on 11/15/18.
//  Copyright © 2018 Kyle Dushman. All rights reserved.
//

import Foundation


enum ShapeType: Codable {
    case square
    case circle
    case rectangle
}

//Make Shape Codable
extension ShapeType {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .square
        case 1:
            self = .circle
        case 2:
            self = .rectangle
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .square:
            try container.encode(0, forKey: .rawValue)
        case .circle:
            try container.encode(1, forKey: .rawValue)
        case .rectangle:
            try container.encode(2, forKey: .rawValue)
        }
    }
    
}
