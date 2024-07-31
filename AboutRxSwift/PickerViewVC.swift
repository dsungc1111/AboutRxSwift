//
//  PickerViewVC.swift
//  AboutRxSwift
//
//  Created by 최대성 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


class PickerViewVC: UIViewController {
    
    let pickerview = UIPickerView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        pickItems()
    }
    
    
    func configureLayout() {
        view.addSubview(pickerview)
        pickerview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(300)
        }
    }
    
    func pickItems() {
        
        let items = Observable.just(["a", "b", "c", "d"])
        
        // 피커뷰 설정
        items.bind(to: pickerview.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: disposeBag)
        
        // pick 된 값 출력
        pickerview.rx.modelSelected(String.self)
            .subscribe { value in
                print(value)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
            
        
        /*
         pickerView1.rx.modelSelected(Int.self)
             .subscribe(onNext: { models in
                 print("models selected 1: \(models)")
             })
             .disposed(by: disposeBag)
         */
    }
}
