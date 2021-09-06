//
//  CoreDataStorage.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/26.
//

import Foundation
import RxCoreData
import RxSwift
import CoreData

class CoreDataStorage : MemoStorageType {
    
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    //Main Context 속성 추가
    private var mainContext: NSManagedObjectContext {
        //Container가 생성한 뷰 컨텍스트를 그대로 리턴한다.
        return persistentContainer.viewContext
    }
    
    // MARK: 기본 CRUD ---
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        
        do {
            _ = try mainContext.rx.update(memo)
            // 에러 : Instance method 'update' requires that 'Memo' conform to 'Persistable'
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]> {
        return mainContext.rx.entities(Memo.self, sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map { results in [MemoSectionModel(model: 0, items: results)] }
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updateContent: content)
        
        do {
            _ = try mainContext.rx.update(updated)
            // 에러 : Instance method 'update' requires that 'Memo' conform to 'Persistable'
            return Observable.just(updated)
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        
        do {
            try mainContext.rx.delete(memo)
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }
}
