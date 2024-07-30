//
//  ViewController.swift
//  AboutRxSwift
//
//  Created by 최대성 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


class ViewController: UIViewController {

    let exmapleTableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(exmapleTableView)
        exmapleTableView.snp.makeConstraints { make in
            make.edges.equalTo(exmapleTableView.safeAreaLayoutGuide)
        }
        exmapleTableView.backgroundColor = .lightGray
        setPickerView()
    }
    
    func setPickerView() {
      
        exmapleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            
        let items = Observable.just([
            "딸기",
            "수박",
            "참외",
            "메론"
        ])
        
        items
            .bind(to: exmapleTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {(row, element, cell) in
                cell.textLabel?.text = "\(element), \(row)"
            }
            .disposed(by: disposeBag)
        
    }


}

