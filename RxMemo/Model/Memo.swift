//
//  Memo.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation

struct Memo: Equatable {
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
