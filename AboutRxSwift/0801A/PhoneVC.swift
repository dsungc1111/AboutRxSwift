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
        
        //  userPhoneNumber > behaviorSubject
        
        
        
        
        // 초기값 010 세팅
        userPhoneNumber
            .bind(with: self) { owner, value in
                owner.phoneTextField.text = value
            }
            .disposed(by: disposeBag)
        
        // 텍스트 입력받을 때 숫자만 입력 받게 설정
        phoneTextField.rx.text.orEmpty
            .map { text in
                text.filter { "0123456789".contains($0) }
            }
            .bind(with: self, onNext: { owner, value in
                owner.userPhoneNumber.accept(value)
            })
            .disposed(by: disposeBag)
        
        // 최소 10자리 설정
        let phoneInvalid = phoneTextField.rx.text.orEmpty
            .map { $0.count >= 10 }
            
        // 10자리 넘으면 파란색, 그 미안 빨간색
        phoneInvalid
            .bind(with: self, onNext: { owner, result in
                owner.nextButton.backgroundColor = result ? .systemBlue : .systemRed
                owner.nextButton.isEnabled = result
            })
            .disposed(by: disposeBag)
        
        // 다음페이지 화면 전환
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayVC(), animated: true)
            }
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
