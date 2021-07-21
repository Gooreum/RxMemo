//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    
    //Dummy Data
    //class 외부에서 배열에 직접 접근할 필요가 없기 때문에 Private으로 선언.
    //배열은 옵저버블을 통해 외부로 공개된다.
    //이 옵저버블은 배열의 상태가 업데이트 되면 새로운 넥스트 이벤트를 방출해야 한다. 그냥 옵저버블 형식으로 만들면 불가능하기 때문에 'subject'로 만들어야 한다.
    //처음에 더미 데이터가 필요하기 때문에 behaviorSubject로 만들도록 하겠다.
    private var list = [
        Memo(content: "Helo", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Bye", insertDate: Date().addingTimeInterval(-20))
    ]
    
    //기본값을 list로 선언하기 위해서 lazy로 선언했고,subject역시 외부에서 직접 접근할 필요가 없기 때문에 private로 선언했따.
    //private lazy var store = PublishSubject<[Memo]>()
    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        list.insert(memo, at:0)
        
        store.onNext(list)
        
        return Observable.just(memo)
    }
    
    @discardableResult
    func memoList() -> Observable<[Memo]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updateContent: content)
        
        if let index = list.firstIndex(where: { $0 == memo}) {
            list.remove(at: index)
            list.insert(updated, at: index)
        }
        
        store.onNext(list)
        
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: { $0 == memo}) {
            list.remove(at: index)
        }
        
        store.onNext(list)
        
        return Observable.just(memo)
    }
    
    
}
