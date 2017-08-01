//
//  TestTableVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/5/21.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class TestTableVC: PostTableVC {

    var heights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = dequeCell(withType: .EditableTextViewCell) as! EditableTextViewCell
            cell.placeHolderText = "Enter title here"
            cell.maximumLetters = 150
            cell.updateCell()
            heights.append(44)
            return cell
        case 1:
            let cell = dequeCell(withType: .EditableTextViewCell) as! EditableTextViewCell
            cell.placeHolderText = "Enter title here"
            cell.updateCell()
            heights.append(44)
            return cell
        case 2:
            let cell = dequeCell(withType: .TextFieldCell) as! TextFieldCell
            cell.placeHolderText = "Enter price here"
            cell.extraLabelText = "USD"
            cell.updateCell()
            heights.append(44)
            return cell
        case 3:
            let cell = dequeCell(withType: .TextFieldCell) as! TextFieldCell
            cell.placeHolderText = "Enter price here"
            cell.updateCell()
            heights.append(44)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if heights.count != 0{
            return heights[indexPath.row]
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        switch indexPath.row {
        case 0:
            heights[indexPath.row] = 130
            tableView.beginUpdates()
            tableView.endUpdates()
        case 1:
            print("in")
            heights[indexPath.row] = 100
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }



}
