//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel: CommonViewModel {
    //테이블 뷰와 바인딩 할 수 있는 속성 추가
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
