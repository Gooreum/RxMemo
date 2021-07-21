//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation
import RxSwift
import RxCocoa

//SceneCoordinatorType 프로토콜을 사용해보자.
//화면 전환을 담당하는 클래스. 윈도우 인스턴스와 현재 화면에 표시되어 있는 씬을 가지고 있어야 한다.
class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    
    private var window: UIWindow
    private var currentVC: UIViewController
    
    //위의 두 속성을 초기화 하는 생성자
    required init(window: UIWindow) {
        self.window  = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        //전환 결과를 방출할 서브젝트 선언
        //publishSubject를 생성하지 않고 처음부터 completable로 생성해도 되지만 create 연산자로 만들어야 하고 클로저 내부에서 구현해야 하기 때문에 코드가 필요 이상으로 복잡해진다.
        //따라서 publishSubject와 아래의 ignoreElements 연산자를 사용한다.
        let subject = PublishSubject<Void>()
        
        //씬을 생성해서 상수에 저정
        let target = scene.instantiate()
        
        //실제 전환
        switch style {
        case .root:
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()
            
        case .push:
            guard let nav = currentVC.navigationController else { subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.pushViewController(target, animated: animated)
            currentVC = target
            subject.onCompleted()
            
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target
        }
        
        //transition 메서드 리턴형은 completable이기 때문에 subject를 리턴할때 ignoreElements 연산자를 호출하면 completable로 변환되어 리턴된다.
        return subject.ignoreElements().asCompletable()
        ///subject.ignoreElements()를 리턴하면 에러가 발생하는데, asCompletable()를 붙여주면 에러가 발생 안하네.. 
        
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        //transiotion 메서드의 코드 길이 비교하기 위해 completable로 코드를 작성해보자.
        
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}
