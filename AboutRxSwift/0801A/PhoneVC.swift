//
//  PhoneVC.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class PhoneVC: UIViewController {
    
    
    private let phoneTextField = SignTextfield(placeholderText: "연락처 입력해주세요.")
    private let nextButton = {
        let btn = UIButton()
        btn.setTitle("완료", for: .normal)
        return btn
    }()
    
    private var userPhoneNumber = BehaviorRelay(value: "010")
//    private var getPhoneNumber = PublishSubject<String>()
    
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureLayout()
        bind()
    }
    
    private func bind() {
        
        //숫자만?
        // 추가적인 예외처리 - 숫자
        // 숫자일때만 넣어주고
        userPhoneNumber
            .bind(with: self) { owner, value in
                owner.phoneTextField.text = value
            }
            .disposed(by: disposeBag)
        
        let phoneInvalid = phoneTextField.rx.text.orEmpty
            .map { $0.count >= 10 }
            
        phoneInvalid
            .bind(with: self, onNext: { owner, result in
                owner.nextButton.backgroundColor = result ? .systemBlue : .systemRed
            })
            .disposed(by: disposeBag)
        
        
        
        phoneTextField.rx.text.orEmpty
            .map { "\($0)" }
            .bind(with: self, onNext: { owner, value in
                owner.userPhoneNumber.accept(value)
            })
            .disposed(by: disposeBag)
        
    
        
    }
    
    func configureLayout() {
        
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        
    }
    
    
}
