//
//  Scene.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import UIKit

//앱에서 구현할 씬을 열거형으로 선언

enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

//스토리보드에 있는 씬을 생성하고 연관값에 저장된 뷰모델을 바인딩해서 리턴하는 메서드
extension Scene {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let viewModel) :
            //메모 목록씬을 생성후 뷰모델을 바인딩해서 리턴한다.
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else { fatalError() }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else { fatalError() }
            
            //뷰모델은 네비게이션 컨트롤러에 임베디드되어 있는 루트 뷰컨트롤러에 바인드하고, 리턴할 땐 네비게이션 컨트롤러를 리턴해야 한다.
            listVC.bind(viewModel: viewModel)
            return nav
            
        case .detail(let viewModel):
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            
            detailVC.bind(viewModel: viewModel)
            return detailVC
            
        case .compose(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else { fatalError() }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else { fatalError() }
            
            composeVC.bind(viewModel: viewModel)
            return nav
            
        }
    }
}
