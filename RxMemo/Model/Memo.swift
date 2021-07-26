//
//  Memo.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation

//RxDataSources는 Tableview, collectionview에 바인딩할 수 있는 데이터 소스를 제공한다. -> 데이터 소스에 저장되는 모든 데이터는 반드시 IdentifiableType 프로토콜을 채용해야 한다.
import RxDataSources

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
