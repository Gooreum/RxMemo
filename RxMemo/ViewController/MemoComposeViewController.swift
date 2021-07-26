//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx


class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    var viewModel: MemoComposeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
        
        saveButton.rx.tap
            //더블탭을 막기 위해 0.5초마다 버튼 클릭 가능하도록 한다.
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
            
        
        //키보드 노티피케이션 -> 메모 작성시 키보드가 메모 화면을 가리는 문제 해결
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            //키보드 높이 전달
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0}
        
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable).share()
        
        keyboardObservable.subscribe(onNext: { [weak self] height in
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.contentTextView.contentInset
            inset.bottom = height
            
            //스크롤 인디케이터에도 하단 여백 주기
            var scrollInsest = strongSelf.contentTextView.scrollIndicatorInsets
            scrollInsest.bottom = height
            
            UIView.animate(withDuration: 0.3) {
                strongSelf.contentTextView.contentInset = inset
                strongSelf.contentTextView.scrollIndicatorInsets = scrollInsest
            }
        })
        .disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
