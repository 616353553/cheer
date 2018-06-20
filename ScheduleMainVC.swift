//
//  ScheduleMainVC.swift
//  cheer
//
//  Created by bainingshuo on 6/16/18.
//  Copyright © 2018 Evolvement Apps. All rights reserved.
//

import UIKit

class ScheduleMainVC: UIViewController {

    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var scheduleScrollView: UIScrollView!
    
    fileprivate var dates: [Date] = []
    fileprivate let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    fileprivate let calendar = Calendar.current
    fileprivate var initialScroll = true
    fileprivate let scheduleHeight: CGFloat = 80.0
    fileprivate var today = Date()
    fileprivate var currentWeekDay = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: today)
        guard let weekday = components.weekday else {
            fatalError("Unable to retrieve current weekday")
        }
        currentWeekDay = weekday
        for i in (1..<weekday + 7).reversed() {
            dates.append(calendar.date(byAdding: .day, value: -1 * i, to: today)!)
        }
        dates.append(today)
        for i in 1...(14 - weekday) {
            dates.append(calendar.date(byAdding: .day, value: i, to: today)!)
        }
        
        dateCollectionView.setContentOffset(CGPoint(x: dateCollectionView.frame.width, y: 0), animated: true)
        scheduleScrollView.contentInsetAdjustmentBehavior = .never
        addTimeLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addTimeLabels() {
        let twelveHoursTexts = ["12\nAM", "01\nAM","02\nAM","03\nAM","04\nAM","05\nAM","06\nAM","07\nAM","08\nAM","09\nAM","10\nAM"
            ,"11\nAM","12\nPM","01\nPM","02\nPM","03\nPM","04\nPM","05\nPM","06\nPM","07\nPM","08\nPM","09\nPM","10\nPM","11\nPM","12\nAM"]
        scheduleScrollView.contentSize = CGSize(width: scheduleScrollView.frame.width, height: 24.0 * scheduleHeight + 42.0)
        for (i, text) in twelveHoursTexts.enumerated() {
            let label = UILabel(frame: CGRect(x: 0.0, y: 8.0 + CGFloat(i) * scheduleHeight, width: 18.0, height: 28.0))
            label.font = UIFont(name: "HelveticaNeue", size: 11)
            label.text = text
            label.textColor = .lightGray
            label.numberOfLines = 2
            label.textAlignment = .center
            scheduleScrollView.addSubview(label)
            let line = UIView(frame: CGRect(x: 22.0, y: 22.0 + CGFloat(i) * scheduleHeight, width: scheduleScrollView.frame.width - 22.0, height: 0.3))
            line.backgroundColor = .lightGray
            scheduleScrollView.addSubview(line)
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

extension ScheduleMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return weekdays.count
        } else {
            return dates.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.tag)
        print(indexPath)
        if collectionView.tag == 0 {
            let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! WeekCVCell
            cell.weekLabel.text = weekdays[indexPath.row]
            return cell
        } else {
            let cell = dateCollectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCVCell
            cell.dateLabel.text = String(calendar.dateComponents([.day], from: dates[indexPath.row]).day ?? 0)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index path : \(indexPath)")
        currentWeekDay = indexPath.row % 7 + 1
        weekCollectionView.collectionViewLayout.invalidateLayout()
        dateCollectionView.collectionViewLayout.invalidateLayout()
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.weekCollectionView.layoutIfNeeded()
            self.dateCollectionView.layoutIfNeeded()
//            self.weekCollectionView.reloadData()
//            self.dateCollectionView.reloadData()
        }, completion: nil)
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if initialScroll {
            initialScroll = false
        } else {
            self.view.isUserInteractionEnabled = false
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0.0 {
            dates.removeLast(7)
            var prevWeek: [Date] = []
            for i in (1...7).reversed() {
                prevWeek.append(calendar.date(byAdding: .day, value: -1 * i, to: dates.first!)!)
            }
            dates.insert(contentsOf: prevWeek, at: 0)
        } else if scrollView.contentOffset.x == 2 * dateCollectionView.frame.width {
            dates.removeFirst(7)
            var nextWeek: [Date] = []
            for i in (1...7) {
                nextWeek.append(calendar.date(byAdding: .day, value: i, to: dates.last!)!)
            }
            dates.append(contentsOf: nextWeek)
        }
        dateCollectionView.reloadData()
        dateCollectionView.contentOffset = CGPoint(x: dateCollectionView.frame.width, y: 0)
        self.view.isUserInteractionEnabled = true
    }
    
}

extension ScheduleMainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row % 7 + 1 == currentWeekDay {
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.size.width / 8, height: collectionView.frame.size.height)
        }
        //return CGSize(width: collectionView.frame.size.width / 7, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let horizontalSpacing = (collectionView.frame.width - collectionView.frame.size.height * 7) / 7
//        return UIEdgeInsets(top: 0, left: horizontalSpacing/2, bottom: 0, right: horizontalSpacing/2)
//    }
    
}
