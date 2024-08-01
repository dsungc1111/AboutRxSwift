//
//  PasswordVC.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class LoginVC: UIViewController {
    
    private let emailTextField = SignTextfield(placeholderText: "이메일을 입력해주세요.")
    private let passwordTextField = SignTextfield(placeholderText: "비밀번호를 입력해주세요.")
    
    private let signButton = {
        let btn = UIButton()
        btn.setTitle("로그인", for: .normal)
        btn.backgroundColor = .systemBlue
        return btn
    }()
    
    private let validLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func bind() {
        
        let emailInvalid = emailTextField.rx.text.orEmpty
            .map { $0.count >= 4 } // 4자리 이상 T
        let pwInvalid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 } // 8자리 이상 T
        
       Observable.combineLatest(emailInvalid, pwInvalid) { $0 && $1 }
            .bind(with: self) { owner, result in
                owner.validLabel.text = result ? "통과!" :  "이메일과 비밀번호를 확인해주세요"
                owner.signButton.isEnabled = result
            }
            .disposed(by: disposeBag)
            
        
        signButton.rx.tap
            .bind(with: self) { owner, _ in
                print("df")
                owner.navigationController?.pushViewController(PhoneVC(), animated: true)
                print("0101")
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signButton)
        view.addSubview(validLabel)
    }
    func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        signButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        validLabel.textAlignment = .center
    }
    
}
