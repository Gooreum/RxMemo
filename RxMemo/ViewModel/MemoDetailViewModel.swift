//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation
import RxCocoa
import RxSwift
import Action

class MemoDetailViewModel: CommonViewModel {
    let memo: Memo
    
    //날짜를 문자로 변경할 때 사용
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    //메모를 편집후, 다시 메모 보기 화면으로 오기 위해선 새로운 문자열 배열을 방출해야 한다.
    //일반 옵저버블로 선언하면 그렇게 되지 않기 때문에 subject로 선언
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value:[memo.content, formatter.string(from: memo.insertDate)])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    //편집 액션
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .subscribe(onNext: { updated in
                    self.contents.onNext([
                                            updated.content, self.formatter.string(from: updated.insertDate)])
                })
                .disposed(by: self.rx.disposeBag)
            
            return Observable.empty()
        }
    }
    
    //편집하기
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator as! SceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
            
        }
    }
    
    
    
    //백버튼과 바인딩할 액션 -> 뒤로가기 했을 때 네비게이션 스택 맞춰주기 위한 목적
//    lazy var popAction = CocoaAction { [unowned self] in
//        return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
//    }
    
    
    //삭제 바인딩
    func makeDeleteAction() -> CocoaAction {
        //Action에서는 메모를 삭제후 이전 화면으로 돌아간다.
        return Action { input in
            self.storage.delete(memo: self.memo)
            return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
    }
}
