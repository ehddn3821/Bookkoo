//
//  BookkooVO.swift
//  Bookkoo
//
//  Created by dwKang on 2021/04/12.
//

import Foundation
import RealmSwift

class BookModel: Object {
    @objc dynamic var id: Int = 0  // PK
    @objc dynamic var bkTitle: String = ""
    let bkAuthors = List<String>()
    let bkTranslators = List<String>()
    @objc dynamic var bkPublisher: String = ""
    @objc dynamic var bkContents: String = ""
    @objc dynamic var bkThumbnail: String = ""
    @objc dynamic var bkDatetime: String = ""
    
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
