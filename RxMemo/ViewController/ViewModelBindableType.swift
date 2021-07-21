//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import UIKit

//MVVM은 뷰모델을 뷰컨트롤러의 속성으로 추가한다.
//그런후 뷰모델과 뷰를 바인딩한다.
//이런 역할을 하는 프로토콜을 선언하겠다.

protocol ViewModelBindableType {
    //뷰모델의 타입은 뷰컨트롤러 마다 달라지기 때문에 제네릭으로 선언
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

//뷰컨틀롤러에 추가된 뷰모델 속성에 실제 뷰모델을 저장하고 바인드 뷰모델 메서드를 자동으로 호출하는 메서드를 구현한다.
extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}

