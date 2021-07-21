//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation
import RxSwift

//씬 코디네이터가 공통적으로 구현해야 할 멤버들을 선언
protocol SceneCoordinatorType {
    
    //새로운 씬을 표시. 파라메터로 대상 씬, 트렌지션 스타일, 애니메이션 플래그를 전달
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    //현재 씬을 닫고 이전 씬으로 돌아간다.
    @discardableResult
    func close(animated: Bool) -> Completable
    
}
