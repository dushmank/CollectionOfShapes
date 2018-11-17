//
//  ShapesCollectionView.swift
//  CollectionOfShapes
//
//  Created by Kyle Dushman on 11/15/18.
//  Copyright © 2018 Kyle Dushman. All rights reserved.
//

import UIKit

class ShapesCollectionView: UICollectionView {

    // Collectionview Properties
    let cellid = "Cell"
    var cellShape: ShapeType
    var page: Bool
    var offset: Double
    var index: Int
    
    var shapeViewModel: ShapeViewModel? {
        didSet {
            cellShape = shapeViewModel?.shape ?? .square
            page = shapeViewModel?.page ?? false
            offset = shapeViewModel?.offset ?? 0.0
            index = shapeViewModel?.index ?? 0
        }
    }
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        cellShape = .square
        page = false
        offset = 0.0
        index = 0
        shapeViewModel = ShapeViewModel(shape: Shape(shape: cellShape, page: page, offset: offset, index: 0))
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        createLayout()
    }

    // Create collectionview layout
    func createLayout() {
        let shapesFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        shapesFlowLayout.scrollDirection = .horizontal
        self.setCollectionViewLayout(shapesFlowLayout, animated: true)
        
        self.register(ShapesCollectionViewCell.self, forCellWithReuseIdentifier: cellid)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
