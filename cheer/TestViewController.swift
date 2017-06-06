//
//  TestViewController.swift
//  cheer
//
//  Created by Kelong Wu on 5/24/17.
//  Copyright © 2017 Evolvement Apps. All rights reserved.
//

import UIKit

extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}

extension String {
    var length: Int {
        return self.characters.count
    }
}

extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        guard let hex = hexString.hex else {
            return nil
        }
        self.init(hex: hex)
    }
}



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

class TextViewBlock: UIView{
    
    // MARK:- Overall Position
    var leftMargin = 15
    var rightMargin = 10
    var topMargin = 10
    var bottomMargin = 10
    var size = 5
    var lineMargin = 10
    var priority_stack = 0
    

    // the key is to add art board automation to our layout guide
    
    // MARK:- Basic Information
    func setupOverallLayout(){
        for v in subviews{
            v.removeFromSuperview()
        }
        
        // this statify d-text - d-text might be related in the data layer, of which haven't been intepreted
        // however, this remind you should modulize those things.
        for text in texts{
            let l = UILabel()
            l.translatesAutoresizingMaskIntoConstraints = false
            addSubview(l)
        }
        
        let all = subviews
        for each in all{
            each.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(leftMargin)).isActive = true
            each.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(rightMargin)).isActive = true
        }
        
        if let first = subviews.first {
            first.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(topMargin)).isActive = true
        }
        
        if let last = subviews.last {
            last.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: CGFloat(bottomMargin)).isActive = true
        }
        
        let allButFirst = subviews.dropFirst()
        let allButLast = subviews.dropLast()
        
        for (i, bottom) in allButFirst.enumerated() {
            let top = allButLast[i]
            let k = bottom.topAnchor.constraint(equalTo: top.bottomAnchor, constant: CGFloat(lineMargin))
            // test - how to use priority
            priority_stack += 1
            k.priority = Float(priority_stack)
            k.isActive = true
        }
    }
    
    func reloadData(){
        for (i, text) in texts.enumerated(){
            let v = subviews[i] as! UILabel
            v.text = text
        }
    }
    
    // MARK:- Intepreter
    func loadSelfList(){
        loadList(list: list)
    }
    
    func loadList(list: [(String, String, String)]){
        list1_to_list2_updater()
        for item in list{
            let (range, action, value) = item
            parseTuple(range: range, action: action, value: value)
        }
    }
    
    // representing layer - can we access last layer -> are we change the last layer
    var list1: [(String, String, String)] = [("All", ".color", ".hex(42E700)"), ("0", ".color", ".hex(151515)"), ("3", ".top_margin", ".int(30)"), ("1", ".top_margin", ".int(35)"), ("1", ".font_size", ".int(28)")]
    
    // illegal words are drifting down to next level to become reasonable words.
    
    // the "First" and "Last" is not supported in this case.
    
    var dType: [Int] = [0, 1, 0, 1]
    var count: [Int] = [1, 2, 1, 4] // why is is required -> index converter table - weight index
    
    // required - "list1" and "list"
    // this is the level transformer of view - to solve ranging problem
    func list1_to_list2_updater(){
        list = []
        for item in list1{
            let (r, a, b) = item
            if let new_range = rangeTransformer(range: r){
                list.append((new_range, a, b))
            } else {
                list.append(item)
            }
        }
    }
    
    // empty count might creat problem - (1, 0) -> what does this mean? it means nothing? or it's illegal to do so?
    // But then what we are suppose to do in this case?
    func tester_ojiofjda(){
        if let k = rangeTransformer(range: "3"){
            print(k)
        }
        
        if let k = rangeTransformer(range: "(1,3)"){
            print(k)
        }
    }
    
    // we need to replace the
    
    // safety issue 
    // edge case ignored
    // this transformer requires dType and count as its global input!
    func rangeTransformer(range: String)->String?{
        
        // distinguish two case - "x" , "(,)", else return same
        if intChecker(s: range){
            let i = intProcessor(s: range)
            // does not check if it's in the valid range
            
            var current = 0
            for index in 0...i{
                if index < i{
                    if dType[index] == 0{
                        current += 1
                    } else {
                        current += count[index]
                    }
                }
            }
            
            let start = current
            let end = current + count[i] - 1
            let result = tupleBuilder(start: start, end: end)
            print(result)
            return result
        }
        
        if tupleChecker(s: range){
            if let (start, end) = tupleProcessor(s: range){
                let (s1, _) = singleRanger(i: start)
                let (_, e2) = singleRanger(i: end)
                let result = tupleBuilder(start: s1, end: e2)
                print(result)
                return result
            }
        }
        
        return nil
    }
    
    // helper function - edge case ignored - not stable
    func singleRanger(i: Int)->(Int, Int){
        var current = 0
        for index in 0...i{
            if index < i{
                if dType[index] == 0{
                    current += 1
                } else {
                    current += count[index]
                }
            }
        }
        
        let start = current
        let end = current + count[i] - 1
        return (start, end)
    }
    
    // what is data layer -> why do you even care about data layer -> because we have to get count from data layer,
    // that's the problem -> this is not a problem -> the String / data will still be generated automaticlly 
    // what about views
    
    // bookmark1
    var texts: [String] = ["Mon Thu Fri", "11:00AM - 12:00PM", "CS225", "Data Structure", "Dan Roth", "Kelong Wu", "CNN - 3242343", "LOC - Siebel 1024"]
    
    var data: [(String, String, String)] = [("0", ".text", "Mon Thu Fri"), ("1", ".text", "11:00AM - 12:00PM"), ("2", ".text", "CS225"), ("3", ".text", "Data Structure"), ("4", ".text", "Dan Roth"), ("5", ".text", "Kelong Wu"), ("6", ".text", "CNN - 3242343"), ("7", ".text", "LOC - Siebel 1024")]
    
    var list: [(String, String, String)] = [("All", ".color", ".hex(42E700)"), ("0", ".color", ".hex(151515)"), ("3", ".top_margin", ".int(30)"), ("1", ".top_margin", ".int(35)"), ("1", ".font_size", ".int(28)")]
    
    func test_kkfasjdkfaosjdflas(){
        text_list_parser()
    }
    
    func text_list_parser(){
        data = ddl_list_parser(list: texts, name: ".text")
        print(data)
    }
    
    func ddl_list_parser(list: [String], name: String)->[(String, String, String)]{
        var res : [(String, String, String)] = []
        for (i, item) in list.enumerated(){
            let a = ddl_parser(range: i, name: name, content: item)
            res.append(a)
        }
        return res
    }
    
    func ddl_parser(range: Int, name:String, content: String)->(String, String, String){
        return (String(range), name, content)
    }
    
    // Caution: return when the action is performed
    // step1 - range layer
    func parseTuple(range: String, action: String, value: String){
        // 1. integer
        if let i = Int(range){
            parseType(range: i, action: action, value: value)
            return
        }
        
        // 2. ranger with integer
        // Todo - replace by [formal checker]
        if range.hasPrefix("(") && range.hasSuffix(")"){
            var subrange = range
            if let i = subrange.characters.index(of: "("){
                subrange.remove(at: i)
            }
            if let i = subrange.characters.index(of: ")"){
                subrange.remove(at: i)
            }
            let result = subrange.characters.split(separator: ",").map{String.init($0)}
            if result.count == 2{
                print("[2]")
                if let start = Int(result[0]){
                    if let end = Int(result[1]){
                        let a = [Int](start...end)
                        let b = a.map{ String($0)}
                        print(a)
                        for e in b{
                            parseTuple(range: e, action: action, value: value)
                            // parseTuple(range: String(e), action: action, value: value)
                        }
                        return  // double check return position - DEBUG
                    }
                }
            }
        }
        
        if range == "All" || range == "all" || range == "ALL"{
            let start = 0
            let end = texts.count - 1
            let range = "(\(start),\(end))"
            parseTuple(range: range, action: action, value: value)
            return
        }
        
        if range == "First" || range == "first" || range == "FIRST"{
            let range = "0"
            parseTuple(range: range, action: action, value: value)
            return
        }
        
        if range == "Last" || range == "last" || range == "LAST"{
            let range = "\(texts.count - 1)"
            parseTuple(range: range, action: action, value: value)
            return
        }
        
    }
    
    // a [Checker] that is to check the certain format called tuple.
    func intChecker(s: String)->Bool{
        if let i = Int(s){
            return true
        }
        return false
    }
    
    // notice - unsafe! throw exception here!
    func intProcessor(s: String)->Int{
        if let i = Int(s){
            return i
        }
        return -1
    }
    
    func intBuilder(i: Int)->String{
        return "\(i)"
    }
    
    // format - [1, 2]
    // process - 0 alpha
    // note - not a robust one
    func tupleChecker(s: String)->Bool{
        var subrange = s
        if subrange.hasPrefix("(") && subrange.hasSuffix(")"){
            if let i = subrange.characters.index(of: "("){
                subrange.remove(at: i)
            }
            if let i = subrange.characters.index(of: ")"){
                subrange.remove(at: i)
            }
            let result = subrange.characters.split(separator: ",").map{String.init($0)}
            if result.count == 2{
                return true
            }
        }
        return false
    }
    
    // we use tuple processor in a secure way
    func tupleProcessor(s: String)->(Int, Int)?{
        var subrange = s
        if let i = subrange.characters.index(of: "("){
            subrange.remove(at: i)
        }
        if let i = subrange.characters.index(of: ")"){
            subrange.remove(at: i)
        }
        let result = subrange.characters.split(separator: ",").map{String.init($0)}
        if let start = Int(result[0]){
            if let end = Int(result[1]){
                return (start, end) // double check return position - DEBUG
            }
        }
        return nil
    }
    
    func tupleBuilder(start s:Int, end e: Int)->String{
        return "(\(s),\(e))"
    }
    
    // !Notice: Missing Range Checker!
    // step 2 - type layer
    func parseType(range: Int, action: String, value: String){
        switch action {
        case ".color":
            colorParser(range: range, value: value)
        case ".top_margin":
            marginParser(range: range, value: value)
        case ".font_size":
            fontSizeParser(range: range, value: value)
        default:
            print("\(action) is not a valid instruction type")
            break
        }
    }
    
    // step 3 - value layer
    func colorParser(range: Int, value: String){
        // support .hex(363636) 
        // support .grey
        // first version - can be used
        
        // special form parser - ._wahtever _( _whatever _)
        
        // we might be able to build a parse from scratch
        
        // so try to read . and find position rigt 
        // 2 situation then, either with or with out or not valid type
        // must be careful to define not valide type 
        
        // .__id__str__(__p1__,__p2__,__p3___) -> ("id", "raw_value_group") -> parse_raw_value_group!
        let (name, value) = parseDFormat(dLine: value)
        if name == "hex" && value != nil {
            if let color = UIColor(hexString: value!) // hex format does not checked - this is unchecked
            {
                colorSetter(range: range, value: color)
            }
        }
    }
    
    func marginParser(range: Int, value: String){
        let (name, value) = parseDFormat(dLine: value)
        if name == "int" && value != nil {
            if let m = Int(value!){
                let margin = CGFloat(m)
                marginSetter(range: range, value: margin)
            }
        }
    }
    
    func fontSizeParser(range: Int, value: String){
        let (name, value) = parseDFormat(dLine: value)
        if name == "int" && value != nil {
            if let m = Int(value!){
                let font = CGFloat(m)
                fontSetter(range: range, value: font)
            }
        }
    }
    
    // step 4 - excution layer
    func colorSetter(range: Int, value: UIColor){
        (subviews[range] as! UILabel).textColor = value         // caution as! force-cast UILabel
    }
    
    func marginSetter(range: Int, value: CGFloat){
        if (range != 0) {
            //subviews[4].topAnchor.
            let k = subviews[range].topAnchor.constraint(equalTo: subviews[range - 1].bottomAnchor, constant: value)
            priority_stack += 1
            k.priority = Float(priority_stack)
            k.isActive = true
        }
    }
    
    func fontSetter(range: Int, value: CGFloat){
        let l = (subviews[range] as! UILabel)
        l.font = l.font.withSize(value)
    }
    
    // step x - toolkit layer
    // DFormat is a format .__id__str__(__p1__,__p2__,__p3___)
    // parsing goal is ("id", "raw_value_group") -> parse_raw_value_group!
    func parseDFormat(dLine: String)->(String, String?){
        var l = dLine
        if !l.hasPrefix("."){
            return ("error", "no . found as first char")
        }
        
        var value: String? = nil
        var name: String = ""
        
        // notice . is not allowed in this case in the () or in namespace - parsing is much difficult in this case
        if let i = l.characters.index(of: "."){
            l.remove(at: i)
        }
        
        let start = l.characters.index(of: "(")
        let end = l.characters.index(of: ")")
        

        if let s = start{
            if let e = end{
                let r = Range(uncheckedBounds: (s, e))
                var before = l.substring(to: s)
                var after = l.substring(with: r)
                
                if let i = after.characters.index(of: "("){
                    after.remove(at: i)
                }
                return (before, after)
            }
        }
        
        return("error", "not a correct DFormat, but we don't know what's wrong... >_<")
    }
}

class TestViewController: UIViewController {

    var courseNumber = ["CS225"]
    var courseName = [""]
    var professor = ["Dan Roth"]
    
    // Mark As Default // Mark As Live Update
    
    
    // scope function - anyother / else except for selected
    // ["String", "String"]
    // json has lot's of level , which is hard to map to the view indeed
    // we might be able to create a two to n level mapper
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = TextViewBlock()
        
        view.addSubview(v)

        v.translatesAutoresizingMaskIntoConstraints = false
        v.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        v.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        v.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        v.setupOverallLayout()
        v.reloadData()
        v.loadSelfList()
    
        v.test_kkfasjdkfaosjdflas()
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
