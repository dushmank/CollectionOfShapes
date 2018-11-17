//
//  ShapesTableViewCell.swift
//  CollectionOfShapes
//
//  Created by Kyle Dushman on 11/15/18.
//  Copyright © 2018 Kyle Dushman. All rights reserved.
//

import UIKit

// Protocol to interact with collectionview cells on the tableviewcontroller
protocol ShapesCollectionCellDelegate: class {
    func tapCell(message: String)
}

class ShapesTableViewCell: UITableViewCell {

    // Delegate Property
    var cellDelegate: ShapesCollectionCellDelegate?
    
    // CollectionView Properties
    var shapeViewModel: ShapeViewModel {
        didSet {
            shapesCollectionView.shapeViewModel = shapeViewModel
            
            // Turn on and off paging for shapes
            let page = shapeViewModel.page
            if page == true {
                shapesCollectionView.isPagingEnabled = true
            } else {
                shapesCollectionView.isPagingEnabled = false
            }
        }
    }
    var shapesViewModel: ShapesViewModel {
        didSet {
            shapes = shapesViewModel
        }
    }
    var colorsArray: [UIColor] {
        didSet {
            colors = colorsArray
        }
    }
    let shapesCollectionView: ShapesCollectionView = {
        let collectionView = ShapesCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    var pullWidth: NSLayoutConstraint
    let pullView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var pullLabelRight: NSLayoutConstraint
    let pullLabel: UILabel = {
        let label = UILabel()
        label.text = "PAGE"
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont(name: ".SFUIDisplay-Heavy", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Data Variables for CollectionView
    var shapes = ShapesViewModel(shapes: Shapes(squares: [Square()], circles: [Circle()], rectangles: [Rectangle()]))
    var colors = [UIColor]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        shapeViewModel = ShapeViewModel(shape: Shape(shape: .square, page: false, offset: 0.0, index: 0))
        shapesViewModel = ShapesViewModel(shapes: Shapes(squares: [Square()], circles: [Circle()], rectangles: [Rectangle()]))
        colorsArray = [UIColor]()
        pullWidth = NSLayoutConstraint()
        pullLabelRight = NSLayoutConstraint()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        shapesCollectionView.dataSource = self
        shapesCollectionView.delegate = self
                
        createLayout()
    }
    
    func createLayout(){
                
        contentView.addSubview(shapesCollectionView)
        contentView.addSubview(pullView)
        contentView.addSubview(pullLabel)
        
        // Contraints for CollectionView
        let collectionViewLeft = NSLayoutConstraint(item: shapesCollectionView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let collectionViewRight = NSLayoutConstraint(item: shapesCollectionView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let collectionViewTop = NSLayoutConstraint(item: shapesCollectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let collectionViewBottom = NSLayoutConstraint(item: shapesCollectionView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([collectionViewLeft, collectionViewRight, collectionViewTop, collectionViewBottom])
        
        // Contraints for pullView
        let pullLeft = NSLayoutConstraint(item: pullView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let pullTop = NSLayoutConstraint(item: pullView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let pullBottom = NSLayoutConstraint(item: pullView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        pullWidth = pullView.widthAnchor.constraint(equalToConstant: 0.0)
        NSLayoutConstraint.activate([pullLeft, pullTop, pullBottom, pullWidth])
        
        // Contraints for pullLabel
        let pullLabelCenterY = NSLayoutConstraint(item: pullLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        pullLabelRight = NSLayoutConstraint(item: pullLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: -10.0)
        NSLayoutConstraint.activate([pullLabelCenterY, pullLabelRight])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Delegate and DataSource for the CollectionView
extension ShapesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let cellShape = shapesCollectionView.cellShape
        
        if cellShape == .square {
            return shapes.squares.count
        } else if cellShape == .circle {
            return shapes.circles.count
        } else if cellShape == . rectangle {
            return shapes.rectangels.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShapesCollectionViewCell
        
        cell.backgroundColor = colors[indexPath.item]
        let cellShape = shapesCollectionView.cellShape
        if cellShape == .circle {
            cell.layer.cornerRadius = cell.frame.width/2
        } else {
            cell.layer.cornerRadius = 0
        }
        return cell
    }
    
    // Did select with delegate for passing information back to the TableViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let delegatedClass: ShapesTableViewController = ShapesTableViewController()
        cellDelegate = delegatedClass
        cellDelegate?.tapCell(message: "Hi there, I am a \(shapesCollectionView.cellShape)")
    }
    
    // Cell Size for CollectionView cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let cellShape = shapesCollectionView.cellShape
            let width: CGFloat = collectionView.frame.width/6-10
            let height: CGFloat = collectionView.frame.width/6-10
        
                if cellShape == .square {
                    return CGSize(width: width, height: height)
                } else if cellShape == .circle {
                    return CGSize(width: width, height: height)
                } else if cellShape == .rectangle {
                    return CGSize(width: collectionView.frame.width-20, height: height)
                } else{
                    return CGSize(width: width, height: height)
                }
    }
    
    // Line spacing for the CollectionView cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellShape = shapesCollectionView.cellShape
        if cellShape == .rectangle {
            return 20
        } else {
            return 10
        }
    }
    
    // Edge insets for the CollectionView cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellShape = shapesCollectionView.cellShape
        if cellShape == .rectangle {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    // When dragging the set distance, enable or disable paging
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let dragOffset = -scrollView.frame.width/6
        if shapesCollectionView == scrollView {
            let offset = scrollView.contentOffset.x
            if offset <= dragOffset {
                if shapesCollectionView.isPagingEnabled == false {
                    shapesCollectionView.isPagingEnabled = true
                    pullLabel.text = "FREE"
                } else {
                    shapesCollectionView.isPagingEnabled = false
                    pullLabel.text = "PAGE"
                }
            }
        }
    }
    
    // Manage page/free switch animation
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shapesCollectionView == scrollView {
            
            let offset = scrollView.contentOffset.x
            let dragOffset: CGFloat = -scrollView.frame.width/4
            if offset < 0 {
                pullWidth.constant = -offset
                if offset >= dragOffset/2-10 {
                    pullLabelRight.constant = -offset-10
                } else if offset < dragOffset/2 && offset > dragOffset {
                    pullLabelRight.constant = -dragOffset/2
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                        self.layoutIfNeeded()
                    }, completion: { (completed) in
                    })
                } else if offset <= dragOffset {
                    pullLabelRight.constant = -offset-10
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                        self.layoutIfNeeded()
                    }, completion: { (completed) in
                    })
                }
            } else {
                if pullWidth.constant != 0 {
                    pullWidth.constant = 0
                }
                if pullLabelRight.constant != 0 {
                    pullLabelRight.constant = 0
                }
            }

        }
    }
    
    // Sets the paging for an individual tableviewcell's collectionview
    public func setPaging(paging: Bool) {
        shapesCollectionView.isPagingEnabled = paging
    }
    // Retrieves the paging for an individual tableviewcell's collectionview
    public func getPaging() -> Bool {
        return shapesCollectionView.isPagingEnabled
    }
    // Sets the offset for an individual tableviewcell's collectionview
    public func setScrollOffset(x: CGFloat) {
        shapesCollectionView.setContentOffset(CGPoint(x: x >= 0.0 ? x : 0.0, y: 0.0), animated: false)
    }
    // Retrieves the offset for an individual tableviewcell's collectionview
    public func getScrollOffset() -> CGFloat {
        return shapesCollectionView.contentOffset.x
    }
    
}
