//
//  BookkooVO.swift
//  Bookkoo
//
//  Created by dwKang on 2021/04/12.
//

import Foundation
import RealmSwift

class BookModel: Object {
    @objc dynamic var id = 0  // PK
    @objc dynamic var bkTitle = ""
    @objc dynamic var bkAuthors = ""
    @objc dynamic var bkTranslators: String? = nil
    @objc dynamic var bkPublisher = ""
    @objc dynamic var bkContents = ""
    @objc dynamic var bkThumbnail = ""
    @objc dynamic var bkDatetime = ""
    @objc dynamic var bkLike = false
    @objc dynamic var bkReview: String? = nil
    @objc dynamic var bkISBN = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // PrimaryKey AutoIncrement
    func autoIncrementId() -> Int {
        let realm = try! Realm()
        
        if let retNext = realm.objects(BookModel.self).sorted(byKeyPath: "id").last?.id {
            return retNext + 1
        } else {
            return 0
        }
    }
}
