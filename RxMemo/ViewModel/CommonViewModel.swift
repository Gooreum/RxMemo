//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation
import RxSwift
import RxCocoa


class CommonViewModel: NSObject {
    //모든 씬은 네비게이션컨트롤러에 임베디드 되기 때문에 타이틀이 필요
    //Driver로 생성하는 이유는 네비게이션 아이템에 쉽게 바인딩 할 수 있음.
    let title: Driver<String>
    
    //Scene Coordinator와 저장소를 저장하는 속성 선언
    //아래 두 속성을 프로토콜로 선언한 이유는 의존성을 이후 쉽게 수정할 수 있기 때문.
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    //속성 초기화 하는 생성자
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
    
}

