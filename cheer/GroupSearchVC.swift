//
//  GroupSearchVC.swift
//  cheer
//
//  Created by bainingshuo on 2017/7/24.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import UIKit

enum GroupSearchType: Int {
    case group = 0
    case professor = 1
    case department = 2
}

class GroupSearchVC: UIViewController {

    @IBOutlet weak var searchTypeStackView: UIStackView!
    @IBOutlet var searchTypeButtons: [UIButton]!
    @IBOutlet weak var indicatorLine: UIView!
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchTypePushed(_ sender: UIButton) {
        if sender.tag != searchType.hashValue  {
            searchType = GroupSearchType(rawValue: sender.tag)!
            UIView.animate(withDuration: 0.3, animations: {
                self.indicatorLeftConstraint.constant = sender.frame.minX + self.searchTypeStackView.frame.minX
                self.indicatorWidthConstraint.constant = sender.frame.width
                self.view.layoutIfNeeded()
            })
            updateSearchType()
        }
    }
    
    var searchType: GroupSearchType = .group
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search group here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.tableFooterView = UIView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        self.resignFirstResponder()
    }
    
    func updateSearchType() {
        for button in searchTypeButtons {
            if button.tag == searchType.hashValue {
                button.setTitleColor(Config.themeColor, for: .normal)
            } else {
                button.setTitleColor(.darkGray, for: .normal)
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension GroupSearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
    }
}


extension GroupSearchVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
