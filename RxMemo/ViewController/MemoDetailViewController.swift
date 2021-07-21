//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Mingu Seo on 2021/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

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
    }
    
}
