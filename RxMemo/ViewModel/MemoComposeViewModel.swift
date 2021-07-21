//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation
import RxSwift
import RxCocoa
import Action

//MVVM은 뷰모델을 뷰컨트롤러의 속성으로 추가한다.
//그런후 뷰모델과 뷰를 바인딩한다.
//이런 역할을 하는 프로토콜을 선언하겠다.
//뷰컨트롤러 그룹에 새로운 스위프트 파일을 추가하자!


class MemoComposeViewModel: CommonViewModel {
    //Compose 씬에 저장할 메모를 선언
    private let content: String?
    //뷰에 바인딩 할 수 있도록 Driver 추가
    
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinator, storage: MemoStorageType, saveAction: Action<String,Void>? = nil, cancleAction: CocoaAction? = nil) {
        self.content = content
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
                action.execute(input)
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancleAction {
                action.execute(())
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
