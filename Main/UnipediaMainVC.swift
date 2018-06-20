//
//  UnipediaMainVC.swift
//  cheer
//
//  Created by bainingshuo on 2018/1/10.
//  Copyright © 2018年 Evolvement Apps. All rights reserved.
//

import UIKit

//protocol UnipediaMainVCDelegate {
//    func categoryButtonPushed(at index: Int)
//}

class UnipediaMainVC: UIViewController {
    
//    var delegate: UnipediaMainVCDelegate!
    var subTVArr = [UIView]()

    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var underlineView: UITableView!
    @IBOutlet weak var underlineWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineLeftConstraint: NSLayoutConstraint!
    
    @IBAction func categoryIsPushed(_ sender: UIButton) {
        contentScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * CGFloat(sender.tag), y: 0), animated: true)
        moveUnderline(to: sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentScrollView.delegate = self
        contentScrollView.contentSize.width = UIScreen.main.bounds.width * 4
        for i in 0..<4 {
            let frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            let tableView = UIView(frame: frame)
            subTVArr.append(tableView)
            contentScrollView.addSubview(tableView)
        }
        subTVArr[0].backgroundColor = .red
        subTVArr[1].backgroundColor = .green
        subTVArr[2].backgroundColor = .blue
        subTVArr[3].backgroundColor = .yellow
        underlineView.backgroundColor = Config.themeColor
        for button in categoryButtons {
            if button.tag == 0 {
                button.setTitleColor(Config.themeColor, for: .normal)
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func moveUnderline(to index: Int) {
        var frame: CGRect!
        for button in categoryButtons {
            if button.tag == index {
                frame = self.view.convert(button.frame, to: button.superview)
                button.setTitleColor(Config.themeColor, for: .normal)
            } else {
                button.setTitleColor(.black, for: .normal)
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.underlineLeftConstraint.constant = frame.minX * -1
            self.underlineWidthConstraint.constant = frame.width
            self.view.layoutIfNeeded()
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


extension UnipediaMainVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int((scrollView.contentOffset.x / UIScreen.main.bounds.width).rounded(.towardZero))
        moveUnderline(to: currentIndex)
    }
}
