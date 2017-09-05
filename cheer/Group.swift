//
//  Group.swift
//  cheer
//
//  Created by bainingshuo on 2017/6/17.
//  Copyright © 2017年 Evolvement Apps. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Photos

public enum GroupType: String {
    case professorProject = "professorProject"
    case studentProject = "studentProject"
    case activity = "activity"
}



public struct groupStruct{
    var groupDirectory: String
    var uid: String
    var groupType: GroupType
    var image: ImageData
    var title: String
    var professors: GroupProfessors
    var departments: GroupDepartments
    var maxSlots: Int
    var location: String
    var contact: String
    var requirement: String
    var description: String
    
    var schedules: [Schedule]
    var scheduleList: String
    
    var sendNotification: Bool
    var queue: Queue
    var queueList: String
    var queueMemberCount: Int
    var queuePendingCount: Int
    
    var comments: CommentList
    var commentListDirectory: String
    var commentCount: Int
}



class Group{
    
    private var data: groupStruct!
    
    /**
     
     Initializer for Group structure, error will be raised if user is not logged in.
     
     - parameter commentType: ".professorProject" for professors' pojects, ".studentProject" for students' projects, and ".activity" for activities.

     */
    
    func initialize(groupType: GroupType){
        if let uid = Auth.auth().currentUser?.uid {
            data = groupStruct(groupDirectory: "",
                               uid: uid,
                               groupType: groupType,
                               image: ImageData(),
                               title: "",
                               professors: GroupProfessors(),
                               departments: GroupDepartments(),
                               maxSlots: -1,
                               location: "",
                               contact: "",
                               requirement: "",
                               description: "",
                               
                               schedules: [Schedule](),
                               scheduleList: "",
                               
                               sendNotification: true,
                               queue: Queue(),
                               queueList: "",
                               queueMemberCount: 0,
                               queuePendingCount: 0,
                               
                               comments: CommentList(),
                               commentListDirectory: "",
                               commentCount: 0)
            data.image.initialize(withCapacity: 2)
            data.queue.initialize(creatorId: data!.uid)
            data.professors.initialize(professors: [nil])
            data.departments.initialize(departments: [nil])
        } else {
            fatalError("Error: user must be signed in to comment/reply")
        }
    }
    
    
    
    
    
    
    /**
     
     Initialize group with given directory.
     
     - parameter directory: directory of the group data in database.
     
     */
    
    func initialize(groupDirectory: String) {
        data = groupStruct(groupDirectory: groupDirectory,
                           uid: "",
                           groupType: .professorProject,
                           image: ImageData(),
                           title: "",
                           professors: GroupProfessors(),
                           departments: GroupDepartments(),
                           maxSlots: -1,
                           location: "",
                           contact: "",
                           requirement: "",
                           description: "",
                           
                           schedules: [],
                           scheduleList: "",
                           
                           sendNotification: true,
                           queue: Queue(),
                           queueList: "",
                           queueMemberCount: 0,
                           queuePendingCount: 0,
                           
                           comments: CommentList(),
                           commentListDirectory: "",
                           commentCount: 0)
    }
    
    
    
    
    
    /**
     
     Retrieve group data from database on given directory.
     
     - parameter completion: directory of the group data in database.
     
     */
    
    func retrieveGroupFromDirectory(completion: @escaping (DataSnapshot) -> Void) {
        Database.database().reference().child(data.groupDirectory).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let groupData = snapshot.value as! [String: AnyObject]
                
                // user ID
                if let uid = groupData["uid"] as? String {
                    self.data!.uid = uid
                }
                
                // group type, professors and departments
                if let groupType = groupData["groupType"] as? String {
                    self.data!.groupType = GroupType.init(rawValue: groupType)!
                    switch self.data!.groupType {
                    case .professorProject:
                        if let professors = groupData["professors"] as? [String?] {
                            self.data.professors.initialize(professors: professors)
                        } else {
                            self.data.professors.initialize()
                        }
                        if let departments = groupData["departments"] as? [String?] {
                            self.data.departments.initialize(departments: departments)
                        } else {
                            self.data.departments.initialize()
                        }
                    default:
                        self.data.professors.initialize()
                        self.data.departments.initialize()
                    }
                }
                
                // image
                var imageDirectories: [String] = []
                if let image = groupData["image"] as? String {
                    imageDirectories.append(image)
                }
                if let thumbImage = groupData["thumbImage"] as? String {
                    imageDirectories.append(thumbImage)
                }
                if imageDirectories.count == 2 {
                    self.data!.image.initialize(withDirectories: imageDirectories)
                } else {
                    self.data!.image.initialize(withCapacity: 2)
                }
                
                // title
                if let title = groupData["title"] as? String {
                    self.data!.title = title
                }
                
                // maxSlots
                if let maxSlots = groupData["maxSlots"] as? Int {
                    self.data!.maxSlots = maxSlots
                }
                
                // location
                if let location = groupData["location"] as? String {
                    self.data!.location = location
                }
                
                // contact
                if let contact = groupData["contact"] as? String {
                    self.data!.contact = contact
                }
                
                // requirement
                if let requirement = groupData["requirement"] as? String {
                    self.data!.requirement = requirement
                }
                
                // description
                if let description = groupData["description"] as? String {
                    self.data!.description = description
                }
                
                // scheduleList
                if let scheduleList = groupData["scheduleList"] as? String {
                    self.data!.scheduleList = scheduleList
                }
                
                // sendNotification
                if let sendNotification = groupData["sendNotification"] as? Bool {
                    self.data!.sendNotification = sendNotification
                }
                
                // queueList
                if let queueList = groupData["queueList"] as? String {
                    self.data!.queueList = queueList
                }
                
                // queueMemberCount
                if let queueMemberCount = groupData["queueMemberCount"] as? Int {
                    self.data!.queueMemberCount = queueMemberCount
                }
                
                // queuePendingCount
                if let queuePendingCount = groupData["queuePendingCount"] as? Int {
                    self.data!.queuePendingCount = queuePendingCount
                }
                
                // commentList
                if let commentListDirectory = groupData["commentList"] as? String {
                    self.data!.commentListDirectory = commentListDirectory
                }
                
                // commentCount
                if let commentCount = groupData["commentCount"] as? Int {
                    self.data!.commentCount = commentCount
                }
            } else {
                // snapshot does not exist
            }
            completion(snapshot)
        })
    }
    
    
    
    
    
    
    
    
    
    
    func setGroupType(groupType: GroupType) {
        data.groupType = groupType
    }

    func setImage(imageData: ImageData) {
        data.image = imageData
    }

    func setTitle(title: String) {
        data.title = title
    }
    
    func setMaxSlots(maxSlots: Int) {
        data.maxSlots = maxSlots
    }
    
    func setLocation(location: String){
        data.location = location
    }
    
    func setContact(contact: String) {
        data.contact = contact
    }
    
    func setRequirement(requirment: String){
        data.requirement = requirment
    }
    
    func setDescription(description: String){
        data.description = description
    }

    func setSchedules(schedules: [Schedule]){
        data.schedules = schedules
    }

    func setSendNotification(sendNotification: Bool) {
        data.sendNotification = sendNotification
    }
    
    func setQueue(queue: Queue) {
        data.queue = queue
    }

    

    
    
    
    
    
    
    
    
    
    
    
    func getGroupDirectory() -> String {
        return data.groupDirectory
    }
    
    func getUID() -> String {
        return data.uid
    }
    
    func getGroupType() -> GroupType {
        return data.groupType
    }
    
    func getImage() -> ImageData {
        return data.image
    }
    
    func getTitle() -> String {
        return data.title
    }
    
    func getProfessors() -> GroupProfessors {
        return data.professors
    }
    
    func getDepartments() -> GroupDepartments {
        return data.departments
    }
    
    func getMaxSlots() -> Int {
        return data.maxSlots
    }
    
    func getLocation() -> String{
        return data.location
    }
    
    func getContact() -> String {
        return data.contact
    }
    
    func getRequirement() -> String {
        return data.requirement
    }
    
    func getDescription() -> String{
        return data.description
    }

    func getSchedules() -> [Schedule] {
        return data.schedules
    }
    
    func getQueueList() -> String {
//        var queueList = getValue(dataType: .queueList) as! String
//        let range = queueList.startIndex..<queueList.index(queueList.startIndex, offsetBy: 38)
//        queueList.removeSubrange(range)
        return data.queueList
    }

    func getSendNotification() -> Bool {
        return data.sendNotification
    }
    
    func getQueue() -> Queue {
        return data.queue
    }
    
    func getScheduleList() -> String {
        return data.scheduleList
    }
    
    func getQueueMemberCount() -> Int {
        return data.queueMemberCount
    }
    
    func getQueuePendingCount() -> Int {
        return data.queuePendingCount
    }
    
    func getComments() -> CommentList {
        return data.comments
    }
    
    func getCommentListDirectory() -> String {
        return data.commentListDirectory
    }
    
    func getCommentCount() -> Int {
        return data.commentCount
    }
    
    
    
    
    
    
    
    
    func isValidTitle() -> Bool {
        return InputChecker.hasCorrectLength(min: 1, max: Config.groupTitleLength, text: data!.title)
    }
    
    
    func isValidSchedules() -> Bool {
        if data!.schedules.count > 0 {
            for schedule in data!.schedules {
                if schedule.isValidSchedule() != nil {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    
    func isValidGroup() -> Bool {
        guard data!.title != "" else {
            return false
        }
        guard isValidSchedules() else {
            return false
        }
        if data!.groupType == .professorProject {
            guard !data.professors.isEmpty() else {
                return false
            }
            guard !data.departments.isEmpty() else {
                return false
            }
        }
        return true
    }
    
    
    
    
    private func removeEmptyElements(array: [String?]) -> [String] {
        var nonEmptyArray = [String]()
        for element in array {
            if element != nil {
                nonEmptyArray.append(element!)
            }
        }
        return nonEmptyArray
    }
    
    
    
    /**
     
     Parse group data to JSON file. Image directory will be set to "" (Empty String).
     
     - returns: The JSON file which represents group data.
     
     */
    func toJSON() -> [String: [String: AnyObject]] {
        // group data
        var groupJSON: [String: AnyObject] = ["uid": self.data!.uid as AnyObject,
                                          "groupType": data!.groupType.rawValue as AnyObject,
                                          "title": self.data!.title as AnyObject,
                                          "maxSlots": self.data!.maxSlots as AnyObject,
                                          "sendNotification": self.data!.sendNotification as AnyObject]
        
        switch self.data!.groupType {
        case .professorProject:
            groupJSON["professors"] = data!.professors.arrayWithoutEmpty() as AnyObject
            groupJSON["departments"] = data!.departments.arrayWithoutEmpty() as AnyObject
        default:
            break
        }
        
        // storing optional information
        if data!.location != "" {
            groupJSON["location"] = data!.location as AnyObject
        }
        if data!.contact != "" {
            groupJSON["contact"] = data!.contact as AnyObject
        }
        if data!.requirement != "" {
            groupJSON["requirement"] = data!.requirement as AnyObject
        }
        if data!.description != "" {
            groupJSON["description"] = data!.description as AnyObject
        }
        
        
        // queue data
        let queueJSON = data!.queue.toJSON()
        
        // schedules data
        var schedulesJSON = [String: [String: AnyObject]]()
        for i in 0..<self.data!.schedules.count {
            schedulesJSON["\(i)"] = self.data!.schedules[i].toJSON()
        }
        
        // comment data
        let commentJSON = [String: [String: Any]]()
        
        return ["group": groupJSON as [String: AnyObject],
                "queue": queueJSON as [String: AnyObject],
                "schedule": schedulesJSON as [String: AnyObject],
                "comment": commentJSON as [String: AnyObject]]
    }
    
    
    
    

    
    
    
    /**
     
     Helper function for uploading the group data.
     
     - parameter completion: The block which will be excuted after upload finishes.
     
     - parameter errorString: A String with reason of faling.
     
     - parameter reference: Reference of the object just uploaded.
     
     */
    func upload(completion: @escaping (String?, DatabaseReference?) -> Void){
        // upload image firest if there is any
        var group = self.toJSON()
        if data!.image.numOfImages() != 0 {
            data!.image.upload(maxSizeInByte: [Config.imageMaxSize, Config.thumbImageMaxSize]) { (metaData, errors) in
                guard errors == nil else {
                    for error in errors! {
                        if error != nil {
                            completion(error, nil)
                        }
                    }
                    return
                }
                group["group"]!["image"] = self.data!.image.getDirectories()[0] as AnyObject
                group["group"]!["thumbImage"] = self.data!.image.getDirectories()[1] as AnyObject
                self.uploadGroup(data: group, completion: completion)
            }
        } else {
            self.uploadGroup(data: group, completion: completion)
        }
    }
    
    
    private func uploadGroup(data: [String: [String: Any]], completion: @escaping (String?, DatabaseReference?) -> Void) {
        let action = NERequestAction.init(endPoint: "group_upload", httpBody: data) { (data, dataBaseError, requestError) in
            if dataBaseError == nil && requestError == nil {
                completion(nil, nil)
            } else if dataBaseError != nil{
                completion("Unkown error", nil)
            } else {
                completion(requestError!.localizedDescription, nil)
            }
        }
        
        let controller = NERequestController()
        controller.isSequential = true
        controller.add(request: action)
        controller.sendRequests()
    }
}
