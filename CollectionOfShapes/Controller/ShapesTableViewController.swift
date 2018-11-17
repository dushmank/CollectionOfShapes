//
//  ShapesTableViewController.swift
//  CollectionOfShapes
//
//  Created by Kyle Dushman on 11/15/18.
//  Copyright © 2018 Kyle Dushman. All rights reserved.
//

import UIKit

// Definition for singly-linked list:
public class ListNode<T> {
    public var value: T
    public var next: ListNode<T>?
    public init(_ x: T) {
        self.value = x
        self.next = nil
    }
}

class ShapesTableViewController: UIViewController, ShapesCollectionCellDelegate {
    
    // ShapesCollectionCellDelegate Method
    func tapCell(message: String) {
        print(message)
    }
    
    // View Layouts
    let shapesTableview = UITableView()
    let cellid = "cell"
        
    func createTableview() {
        
        shapesTableview.register(ShapesTableViewCell.self, forCellReuseIdentifier: cellid)
        shapesTableview.delegate = self
        shapesTableview.dataSource = self
        shapesTableview.allowsSelection = false
        
        shapesTableview.backgroundColor = .white
        
        view.addSubview(shapesTableview)
        let leftTable = NSLayoutConstraint(item: shapesTableview, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightTable = NSLayoutConstraint(item: shapesTableview, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topTable = NSLayoutConstraint(item: shapesTableview, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0)
        let bottomTable = NSLayoutConstraint(item: shapesTableview, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0)
        shapesTableview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([leftTable, rightTable, topTable, bottomTable])
    }
    
    // Data Variables for TableView
    var shapes = [ShapeViewModel]()
    var shapesOffset = [IndexPath : CGFloat]()
    var shapesPaging = [IndexPath : Bool]()


    // Function to easily change the amount of data in the TableView
    func createTableData() {
        // Change this number to add more data
        let copies = 15

        for i in 0..<copies {
            shapes.append(ShapeViewModel(shape: Shape(shape: .square, page: false, offset: 0.0, index: 3*i)))
            shapes.append(ShapeViewModel(shape: Shape(shape: .circle, page: false, offset: 0.0,  index: 3*i+1)))
            shapes.append(ShapeViewModel(shape: Shape(shape: .rectangle, page: true, offset: 0.0,  index: 3*i+2)))
        }
        shapesTableview.reloadData()
    }
    
    // Data Variables for CollectionView
    var shapesViewModel = ShapesViewModel(shapes: Shapes(squares: [], circles: [], rectangles: []))
    var colors = [UIColor]()
    
//     Set up nodes for color loop
    let nodeOne = ListNode(UIColor.red)
    func createNodes() {
        let nodeTwo = ListNode(UIColor.orange)
        let nodeThree = ListNode(UIColor.yellow)
        let nodeFour = ListNode(UIColor.green)
        let nodeFive = ListNode(UIColor.blue)
        let nodeSix = ListNode(UIColor.purple)
        nodeOne.next = nodeTwo
        nodeTwo.next = nodeThree
        nodeThree.next = nodeFour
        nodeFour.next = nodeFive
        nodeFive.next = nodeSix
        nodeSix.next = nodeOne
    }
    
    // Function to easily change the amount of data in the CollectionView
    func createCollectionData() {
        
        // Temporary variables to simulate downloading squares, circles, and rectangles
        var squares: [Square] = []
        var circles: [Circle] = []
        var rectangles: [Rectangle] = []

        createNodes()
        
        // Change this number to add more data
        let copies = 10
        var head = nodeOne
        
        for _ in 0..<copies {
            squares.append(Square())
            circles.append(Circle())
            rectangles.append(Rectangle())
            
            colors.append(head.value)
            head = head.next ?? ListNode(UIColor.red)
        }
        
        shapesViewModel = ShapesViewModel(shapes: Shapes(squares: squares, circles: circles, rectangles: rectangles))
    }
    
    // Create the layout of the TableViewController
    func createLayout() {
        view.backgroundColor = .white
        createTableview()
    }
    
    // Create the navigation bar
    func createNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Collection of Shapes"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .blue
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: ".SFUIDisplay-Bold", size: 36)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: ".SFUIDisplay-Bold", size: 24)!]
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavBar()
        createLayout()
        createCollectionData()
        createTableData()
    }
    
}


// Override the navbar status bar
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// Delegate and DataSource for the TableViewController
extension ShapesTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shapes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! ShapesTableViewCell
        
        cell.shapeViewModel = shapes[indexPath.row]
        cell.shapesViewModel = shapesViewModel
        cell.colorsArray = colors
        cell.setScrollOffset(x: shapesOffset[indexPath] ?? 0.0)
        
        if shapes[indexPath.row].shape == .rectangle {
            cell.setPaging(paging: shapesPaging[indexPath] ?? true)
            if shapesPaging[indexPath] ?? true == true {
                cell.pullLabel.text = "FREE"
            } else {
                cell.pullLabel.text = "PAGE"
            }
        } else {
            cell.setPaging(paging: shapesPaging[indexPath] ?? false)
            if shapesPaging[indexPath] ?? false == true {
                cell.pullLabel.text = "FREE"
            } else {
                cell.pullLabel.text = "PAGE"
            }
        }
        
        cell.shapesCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width/6+10
    }
    
    // Save cell's CollectionsView's properties
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ShapesTableViewCell
        shapesOffset[indexPath] = cell.getScrollOffset()
        shapesPaging[indexPath] = cell.getPaging()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.shapesTableview.reloadData()
    }
    
}
