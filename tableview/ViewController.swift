//
//  ViewController.swift
//  tableview
//
//  Created by David Wagner on 20/09/2017.
//  Copyright © 2017 David Wagner. All rights reserved.
//

import UIKit


extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class ViewController: UIViewController {

    enum Section: Int {
        case First, Second, Third
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tableData: [[String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTestData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Although Xcode 9 offers a checkbox automatic dimension, this
        // property isn't read by earlier iOS versions. We're being
        // snazzy here and using the #available runtime iOS version check
        // so that we don't set the values twice on iOS 11+, but you
        // could reduce the complexity by not setting these values in the
        // storyboard and always setting them programatically.
        let configureTableViewAutomaticHeights:Bool
        if #available(iOS 11.0, *) {
            configureTableViewAutomaticHeights = false
        } else {
            configureTableViewAutomaticHeights = true
        }
        
        if (configureTableViewAutomaticHeights) {
            // Headers
            tableView.sectionHeaderHeight = UITableViewAutomaticDimension
            tableView.estimatedSectionHeaderHeight = 28
            
            // Footers if needed
            //tableView.sectionFooterHeight = UITableViewAutomaticDimension
            //tableView.estimatedSectionFooterHeight = 28

            // Cells if needed
            //tableView.rowHeight = UITableViewAutomaticDimension
            //tableView.estimatedRowHeight = 28
        }
    }

    private func createTestData() {
        var data = [[String]]()

        data.append(["one", "two", "three"])
        data.append(["one", "two", "three", "four", "five", "six"])
        data.append(["one", "two", "three"])
        
        tableData = data
    }

}

extension ViewController: UITableViewDelegate {
    func createHeader() -> GenericSectionHeader? {
        guard let views = Bundle.main.loadNibNamed("GenericSectionHeader", owner: nil, options: nil), views.count > 0 else {
            return nil
        }

        return views.first as? GenericSectionHeader
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = createHeader() else { fatalError("Could not load header xib") }
        header.label.text = "Section \(section + 1)"
        
        let fontSize = UIFont.systemFontSize * CGFloat(section + 1)
        let font = UIFont.systemFont(ofSize: fontSize)
        header.label.font = font
        
        return header
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let data = tableData else { return 0 }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = tableData?[safe: section] else { return 0 }
        
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = tableData?[indexPath.section][indexPath.row] else { fatalError("Er, invalid index path") }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data
        cell.detailTextLabel?.text = "Foop"
        return cell
    }
}
