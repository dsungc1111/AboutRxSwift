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
    private let nicknameTextField = SignTextfield(placeholderText: "닉네임을 입력해주세요.")
    private let signButton = {
        let btn = UIButton()
        btn.setTitle("로그인", for: .normal)
        btn.backgroundColor = .lightGray
        return btn
    }()
    
    private let validLabel = UILabel()
    private let loginViewModel = LoginViewModel()
    
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func bind() {
        
        
        let input = LoginViewModel.Input(emailText: emailTextField.rx.text, pwText: passwordTextField.rx.text, nicknameText: nicknameTextField.rx.text, loginTap: signButton.rx.tap)
        
        let output = loginViewModel.transform(input: input)
        
        output.emailValid
            .bind(with: self) { owner, result in
                owner.passwordTextField.placeholder = result ? "비밀번호를 입력해주세요." : "이메일부터 입력해주세요!"
                owner.passwordTextField.isEnabled = result
                owner.emailTextField.layer.borderColor = result ? UIColor.systemBlue.cgColor : UIColor.lightGray.cgColor
            }
            .disposed(by: disposeBag)
        
        
        output.nicknameValid
            .bind(with: self) { owner, result in
                if owner.nicknameTextField.text != "" {
                    owner.signButton.backgroundColor = result ? .systemBlue : .lightGray
                    owner.signButton.isEnabled = result
                    owner.nicknameTextField.layer.borderColor = result ? UIColor.systemBlue.cgColor : UIColor.lightGray.cgColor
                }
            }
            .disposed(by: disposeBag)
        
        output.pwValid
            .bind(with: self) { owner, result in
             
                owner.passwordTextField.layer.borderColor = result ? UIColor.systemBlue.cgColor : UIColor.lightGray.cgColor
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.emailValid, output.pwValid, output.nicknameValid) { $0 && $1 && $2 }
             .bind(with: self) { owner, result in
                 owner.validLabel.text = result ? "가입이 가능해요." :  "닉네임을 입력해주세요."
             }
             .disposed(by: disposeBag)
        
        Observable.combineLatest(output.emailValid, output.pwValid) { $0 && $1 }
             .bind(with: self) { owner, result in
                 owner.validLabel.text = result ? "닉네임을 입력해주세요." :  "이메일과 비밀번호를 확인해주세요"
                 owner.passwordTextField.layer.borderColor = result ? UIColor.systemBlue.cgColor : UIColor.lightGray.cgColor
                 owner.nicknameTextField.isEnabled = result
             }
             .disposed(by: disposeBag)
             
        output.loginTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneVC(), animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nicknameTextField)
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
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        signButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        validLabel.textAlignment = .center
    }
    
}
