//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoListViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //뷰모델과 뷰를 바인딩한다.
    func bindViewModel() {
         //뷰모델에 저장되어 있는 타이틀을 뷰모델과 바인딩 한다.
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        //메모 목록을 테이블뷰와 바인딩한다.
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
     
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        //메모 상세보기로 가기.
        //테이블뷰에서 메모를 선택하면 뷰모델을 통해 디테일 액션을 전달하고 선택한 셀은 선택해제 한다.
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .do(onNext: { [unowned self] (_, indexPath) in
                self.listTableView.deselectRow(at: indexPath, animated: true)
            })
            .map { $0.0 }
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
        
    }
}
