//
//  ShapeModels.swift
//  CollectionOfShapes
//
//  Created by Kyle Dushman on 11/15/18.
//  Copyright © 2018 Kyle Dushman. All rights reserved.
//

import Foundation

// Model row of shapes properties
struct Shape: Codable {
    
    let shape: ShapeType
    let page: Bool
    let offset: Double
    let index: Int
}

// Model number of shapes
struct Shapes: Codable {
    let squares: [Square]
    let circles: [Circle]
    let rectangles: [Rectangle]
}
