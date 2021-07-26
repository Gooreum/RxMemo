//
//  Memo.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation

//RxDataSources는 Tableview, collectionview에 바인딩할 수 있는 데이터 소스를 제공한다. -> 데이터 소스에 저장되는 모든 데이터는 반드시 IdentifiableType 프로토콜을 채용해야 한다.
import RxDataSources
import CoreData
import RxCoreData

struct Memo: Equatable, IdentifiableType {
        
    var content: String
    var insertDate: Date
    var identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    //업데이트된 메모로 새로운 인스턴스를 생성할 때 사용
    init(original: Memo, updateContent: String) {
        self = original
        self.content = updateContent
    }
}

extension Memo: Persistable {
    public static var entityName: String {
        return "Memo"
    }
    
    static var primaryAttributeName: String {
        return "identity"
    }
    
    //인스턴스 초기화 하는 생성자
    init( entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        do {
            //CoreData를 RxCoreData로 구현할 시 주의해야 할 점 :
            //RxCoreData는 context를 알아서 저장해주기 때문에 save를 직접 호출할 필요가 없음, 그런데 지금 구현하고 있는 이 코드는 RxCoreData를 사용하고 있지 않음. 그래서 Save 메서드를 직접 호출해야 한다. 그렇지 않으면 경우에 따라서 update한 내용이 사라질 수 있다.
            try entity.managedObjectContext?.save()
        } catch  {
            print(error)
        }
    }
}
