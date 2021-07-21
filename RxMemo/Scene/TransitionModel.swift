//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import Foundation
//화면 전환시 필요한 열겨헝
enum TransitionStyle {
    case root
    case push
    case modal
}

//화면 전환시 생길 수 있는 에러
enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
