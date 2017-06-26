//
//  SelectionViewController.swift
//  cheer
//
//  Created by Kelong Wu on 2017/6/20.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, RestfulRequestManagerDelegate {
    
    @IBOutlet weak var course_id: UILabel!
    @IBOutlet weak var course_name: UILabel!
    
    
    @IBOutlet weak var tableview: UITableView!
    var tableviewData = [SectionData]()
    var requestManager = RestfulRequestManager()
    
    var id: String?
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        
        let nib = UINib(nibName: "SectionTableViewCell", bundle: nil)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(nib, forCellReuseIdentifier: "section")
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 300
        
        course_id.text = id
        course_name.text = name
        
        // Do any additional setup after loading the view.
        requestManager.delegate = self
        if let query = id{
           requestManager.request(endPoint: "sectioninfo_update_t", params: ["query":query])
        }

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "section")! as! SectionTableViewCell
        
        let row = indexPath.row
        
        cell.tag = row
        cell.updateCell(data: tableviewData[row])
        
        return cell
        
    }



    func getResultFromData(data: Any)->Any{
        print("get result from data")
        print("data")
        var res = [SectionData]()
        let d = data as! [Any]
        for item in d{
            let s = SectionData()
            s.updateDataFromFoundation(result: item)
            res.append(s)
        }
        return res
    }
    
    func presentResult(result: Any){
        print("present result")
        tableviewData = result as! [SectionData]
        tableview.reloadData()
    }
    
}
