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
    case activity = "activity"
    case project = "project"
    case research = "research"
}



public struct GroupStruct{
    var reference: String?
    
    // tiny data
    var creatorID: String?
    var groupType: GroupType?
    var groupTag: GroupTag?
    var title: String?
    var groupImage: ImageData?
    var description: String?
    
    // mega data
    var location: String?
    var contact: String?
    var requirement: String?
    var schedules: ScheduleList?
    var comments: CommentList?
    var queue: Queue?
    var professors: ProfessorList?
}



class Group{
    
    private var data: GroupStruct!
    
    /**
     
     Initialize group with given creatorID.
     
     - parameter creatorID: user ID of creator

     */
    
    init(creatorID: String) {
        self.data = GroupStruct()
        self.data.creatorID = creatorID
    }
    
    
    
    
    
    
    /**
     
     Initialize group with given reference.
     
     - parameter reference: path of the group data in database.
     
     */
    
    init(reference: String) {
        self.data = GroupStruct()
        self.data.reference = reference
    }
    
    
    
    
    
    
    func retrieveTinyData() {
        let request = Request(requestType: .json, endPoint: "getGroupTinyData", body: nil, userToken: nil) { (data, err) in
            
        }
        request.start()
    }
    
    
    func retrieveMegaData() {
        let request = Request(requestType: .json, endPoint: "getGroupMegaData", body: nil, userToken: nil) { (data, err) in
            
        }
        request.start()
    }
    
    
    
    
    // Setters

    func setGroupType(groupType: GroupType?) {
        data.groupType = groupType
    }
    
    func setGroupTag(groupTag: GroupTag?) {
        data.groupTag = groupTag
    }
    
    func setTitle(title: String?) {
        data.title = title
    }
    
    func setGroupImage(groupImage: ImageData?) {
        data.groupImage = groupImage
    }
    
    func setDescription(description: String?) {
        data.description = description
    }
    
    func setLocation(location: String?) {
        data.location = location
    }
    
    func setContact(contact: String?) {
        data.contact = contact
    }
    
    func setRequirement(requirment: String?) {
        data.requirement = requirment
    }
    

    
    
    
    
    
    
    
    
    
    // Getters
    
    func getReference() -> String? {
        return data.reference
    }
    
    func getCreatorID() -> String? {
        return data.creatorID
    }
    
    func getGroupType() -> GroupType? {
        return data.groupType
    }
    
    func getGroupTag() -> GroupTag? {
        return data.groupTag
    }
    
    func getTitle() -> String? {
        return data.title
    }
    
    func getProfessors() -> ProfessorList? {
        return data.professors
    }
    
    func getGroupImage() -> ImageData? {
        return data.groupImage
    }
    
    func getDescription() -> String? {
        return data.description
    }
    
    func getQueue() -> Queue? {
        return data.queue
    }
    
    func getLocation() -> String? {
        return data.location
    }
    
    func getContact() -> String? {
        return data.contact
    }
    
    func getRequirement() -> String? {
        return data.requirement
    }

    func getSchedules() -> ScheduleList? {
        return data.schedules
    }
    
    func getComments() -> CommentList? {
        return data.comments 
    }
    
    func getCommentCount() -> Int? {
        return data.comments?.getCommentsCount()
    }
    
    
    
    
    
    
    
    
    func isValidTitle() -> Bool {
        return InputChecker.hasCorrectLength(min: 1, max: Config.groupTitleLength, text: data.title ?? "")
    }
    
    
    /**
     
     Parse group data to JSON file. Image directory will be set to "" (Empty String).
     
     - returns: The JSON file which represents group data.
     
     */
    func toJSON() -> [String: Any] {
        return ["uid": data.creatorID!,
                "groupType": data.groupType?.rawValue ?? "",
                "title": data.title ?? "",
                "maxSlots": data.queue?.getMaxSlot() ?? "",
                "sendNotification": data.queue?.getSendNotification() ?? false,
                "groupTag": data.groupTag!.getTagName() ?? "",
                "location": data.location ?? "",
                "contact": data.contact ?? "",
                "requirment": data.requirement ?? "",
                "description": data.description ?? "",
                "professors": data.professors?.getReferences() ?? [],
                "schedules": data.schedules?.getJSON() ?? []]
    }
    
    
    
    

    
    
    
    /**
     
     Helper function for uploading the group data.
     
     - parameter completion: The block which will be excuted after upload finishes.
     
     - parameter errorString: A String with reason of faling.
     
     - parameter reference: Reference of the object just uploaded.
     
     */
    func upload(completion: @escaping (String?, DatabaseReference?) -> Void) {

    }

}
