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
    }
    
    //메모를 편집후, 다시 메모 보기 화면으로 오기 위해선 새로운 문자열 배열을 방출해야 한다.
    //일반 옵저버블로 선언하면 그렇게 되지 않기 때문에 subject로 선언
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value:[memo.content, formatter.string(from: memo.insertDate)])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
