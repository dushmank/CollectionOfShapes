//
//  ShapeViewModels.swift
//  CollectionOfShapes
//
//  Created by Kyle Dushman on 11/15/18.
//  Copyright © 2018 Kyle Dushman. All rights reserved.
//

import Foundation
import UIKit

// ViewModel row of shapes properties
struct ShapeViewModel {
    
    let shape: ShapeType
    let page: Bool
    var offset: Double
    let index: Int
    
    init(shape: Shape) {
        self.shape = shape.shape
        self.page = shape.page
        self.offset = shape.offset
        self.index = shape.index
    }
}

// ViewModel number of shapes
struct ShapesViewModel {
    
    let squares: [Square]
    let circles: [Circle]
    let rectangels: [Rectangle]
    
    init(shapes: Shapes) {
        self.squares = shapes.squares
        self.circles = shapes.circles
        self.rectangels = shapes.rectangles
    }
}
