//
//  NumbersVC.swift
//  AboutRxSwift
//
//  Created by 최대성 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NumbersVC: UIViewController {
    
    let inputNum1 = UITextField()
    let inputNum2 = UITextField()
    
    let resultLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Observable.combineLatest(inputNum1.rx.text.orEmpty, inputNum2.rx.text.orEmpty) { value1, value2 -> Int in
             return (Int(value1) ?? 0) + (Int(value2) ?? 0)
        }
        .map {"\($0)"}
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
        
        configureLayout()
    }
    
    func configureLayout() {
        
        view.addSubview(inputNum1)
        view.addSubview(inputNum2)
        view.addSubview(resultLabel)
        
        
        inputNum1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        inputNum1.backgroundColor = .lightGray
        inputNum2.snp.makeConstraints { make in
            make.top.equalTo(inputNum1.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        inputNum2.backgroundColor = .lightGray
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(inputNum2.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        resultLabel.backgroundColor = .lightGray
    }
}
