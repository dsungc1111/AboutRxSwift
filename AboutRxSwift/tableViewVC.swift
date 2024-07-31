//
//  tableViewVC.swift
//  AboutRxSwift
//
//  Created by 최대성 on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SimpleValidationVC: UIViewController {
    
    
    let usernameTextfield = UITextField()
    let usernameValidLabel = UILabel()
    
    let passwordTextField = UITextField()
    let passwordValidLabel = UILabel()
    
    let loginBtn = UIButton()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(usernameTextfield)
        view.addSubview(usernameValidLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordValidLabel)
        view.addSubview(loginBtn)
        
        
        usernameTextfield.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        usernameTextfield.placeholder = "닉네임 입력"
        
        usernameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextfield.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        usernameValidLabel.text = "최소 5글자"
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameValidLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        passwordValidLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        passwordTextField.placeholder = "password"
        passwordValidLabel.text = "최소 5글자"
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordValidLabel.snp.bottom).offset(20)
            make.size.equalTo(40)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        loginBtn.backgroundColor = .systemBlue
        
        let usernameValid = usernameTextfield.rx.text.orEmpty
            .map { $0.count >= 5 }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default

        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 5 }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)

        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
