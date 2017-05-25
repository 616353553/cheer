//
//  TestViewController.swift
//  cheer
//
//  Created by Kelong Wu on 5/24/17.
//  Copyright © 2017 Evolvement Apps. All rights reserved.
//

import UIKit

class SearchButton: UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        // create two subview 
        // autolayout them 
        super.init(frame: frame)
        
        let i = UIImageView()
        let l = UILabel()
        
        self.addSubview(i)
        self.addSubview(l)

        
        self.translatesAutoresizingMaskIntoConstraints = false
        i.translatesAutoresizingMaskIntoConstraints = false
        l.translatesAutoresizingMaskIntoConstraints = false
        
        
        // auto layout
        i.widthAnchor.constraint(equalToConstant: 20).isActive = true
        i.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        l.text = "Search"
        i.image = UIImage(named: "Search")
        
        let m = self.layoutMarginsGuide
        // layout with view
        i.topAnchor.constraint(equalTo: m.topAnchor, constant: 5.0).isActive = true
        i.bottomAnchor.constraint(equalTo: m.bottomAnchor, constant: 5.0).isActive = true
        i.leadingAnchor.constraint(equalTo: m.leadingAnchor, constant: 0).isActive = true
        
        l.centerYAnchor.constraint(equalTo: i.centerYAnchor, constant: 10).isActive = true
        l.leftAnchor.constraint(equalTo: i.rightAnchor, constant: 15).isActive = true
        l.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        
    }
}

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = UIView()
        v.frame = CGRect(x: 25, y: 100, width: 50, height: 50)

        v.backgroundColor = UIColor.black
        view.addSubview(v)

        v.translatesAutoresizingMaskIntoConstraints = false

        v.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        v.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        v.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        v.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
//        let lb = UIBarButtonItem.init(customView: SearchButton())
//        self.navigationItem.leftBarButtonItem = lb
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
