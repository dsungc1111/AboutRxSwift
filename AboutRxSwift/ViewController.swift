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
    
    let examplePickerView = UIPickerView()
    let exampleLabel = UILabel()
    
    let exampleSwitch = UISwitch()
    
    let exampleNameTextField = UITextField()
    let exampleEmailTextField = UITextField()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        setSign()
//        setSwitch()
//        setTableView()
//        setPickerView()
        exampleJustOF()
    }
    
    
    
    func exampleJustOF() {
        
        // 하나의 값만 emit
        
        let itemsA = [1.0, 4.0 , 5.5, 6.7, 8.0, 9.9]
        let itemsB = [1.1, 2.2, 3.3, 4.4]
        
        print("=======just=======")
        Observable.just(itemsA)
            .subscribe(with: self) { owner, value in
                print(value)
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)
        print("=======of=======")
        
        Observable.of(itemsA, itemsB)
            .subscribe(with: self) { owner, value in
                print(value)
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        print("=======from=======")
        Observable.from(itemsA)
            .subscribe(with: self) { owner, value in
                print(value)
            } onDisposed: { owner in
                print("disposer")
            }
            .disposed(by: disposeBag)

        
        print("=======take=======")
        Observable.repeatElement("abcdefg")
            .take(2)
            .subscribe(with: self) { owner, value in
                print(value)
            } onDisposed: { owner in
                print("disposer")
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    
    
    
    
    
    func setSign() {
        
        view.addSubview(exampleLabel)
        view.addSubview(exampleNameTextField)
        view.addSubview(exampleEmailTextField)
        
        exampleNameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
        exampleNameTextField.backgroundColor = .systemBlue
        
        exampleEmailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(exampleNameTextField.snp.bottom).offset(20)
            make.height.equalTo(60)
        }
        exampleEmailTextField.backgroundColor = .systemCyan
        
        exampleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(exampleEmailTextField.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        exampleLabel.backgroundColor = .systemYellow
        
        Observable.combineLatest(exampleNameTextField.rx.text.orEmpty, exampleEmailTextField.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1), email is \(value2)"
        }
        .bind(to: exampleLabel.rx.text)
        .disposed(by: disposeBag)
        
        
        exampleNameTextField.rx.text.orEmpty
            .map {$0.count < 4 }
            .bind(to: exampleLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    
    
    func setSwitch() {
        view.addSubview(exampleSwitch)
        exampleSwitch.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            
        }
        
        Observable.of(false)
            .bind(to: exampleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    func setPickerView() {
        print(#function)
        
        view.addSubview(examplePickerView)
        view.addSubview(exampleLabel)
        examplePickerView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        exampleLabel.snp.makeConstraints { make in
            make.top.equalTo(examplePickerView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        exampleLabel.backgroundColor = .systemBlue
        examplePickerView.backgroundColor = .lightGray
        
        // 옵져버블 생성
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        
        // 옵져버가 옵져버블 구독
        items.bind(to: examplePickerView.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: disposeBag)
        

        
        examplePickerView.rx.modelSelected(String.self)
            .map { $0.description } // exampleLabel.rx.text = 00 중 00
            .bind(to: exampleLabel.rx.text)
            .disposed(by: disposeBag)
           
        
    }
    func setTableView() {
      
        view.addSubview(exmapleTableView)
        exmapleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        exmapleTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        exmapleTableView.backgroundColor = .lightGray
            
        
        
        let items = Observable.just([
            "딸기",
            "수박",
            "참외",
            "메론"
        ])
        
        items
            .bind(to: exmapleTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
               cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
    }


}

