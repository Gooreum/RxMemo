//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import UIKit
import RxSwift
import RxCocoa


enum ActionType {
    case ok
    case cancel
}

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    
    var viewModel: MemoDetailViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func bindViewModel() {
        
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.contents
            .bind(to: listTableView.rx.items) { tableView, row, value in
                switch row {
                //메모 컨텐츠 보여주기
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                    
                //Date 보여주기
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        
        //편집하기 버튼 바인딩하기
        editButton.rx.action = viewModel.makeEditAction()
        
        //삭제버튼과 바인딩하기
        //deleteButton.rx.action = viewModel.makeDeleteAction()
        deleteButton.rx.tap
            .flatMap { [unowned self] in self.alert(title: "Current Color", message: "삭제하시겠습니까?")}
            .subscribe(onNext: { [unowned self] actionType in
                switch actionType {
                case .ok:
                     viewModel.makeDeleteAction()
                case .cancel:
                    print("cancel")
                default:
                    break
                }
            })
            .disposed(by: rx.disposeBag)
        
        
        //공유하기 버튼
        //  shareButton.rx.action = viewModel.makeShareAction()
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] _ in
                let memo = self.viewModel.memo.content
                
                let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        
        //뒤로가기 할 때, 네비게이션 스택 조절해주기 위한 목적 -> 삭제!
        //scenecoordinator
        //        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        //        viewModel.title
        //            .drive(backButton.rx.title)
        //            .disposed(by: rx.disposeBag)
        //        backButton.rx.action = viewModel.popAction
        //        navigationItem.hidesBackButton = true
        //        navigationItem.leftBarButtonItem = backButton
        //
    }
    
}

extension UIViewController {
    //Alert 창
    func alert(title: String, message: String? = nil) -> Observable<ActionType> {
        return Observable.create { [weak self] observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                _ in
                observer.onNext(.ok)
                observer.onCompleted()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
                _ in
                observer.onNext(.cancel)
                observer.onCompleted()
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
