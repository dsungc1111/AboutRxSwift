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
    
    private let viewModel = PhoneViewModel()
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureLayout()
        bind()
    }
    
    private func bind() {
        
        viewModel.outPutSetPhoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        let input = PhoneViewModel.Input(phoneText: phoneTextField.rx.text, nextButtonTap: nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        
        output.changedPhoneNumber
            .bind(with: self, onNext: { owner, value in
                owner.viewModel.outPutSetPhoneNumber.accept(value)
            })
            .disposed(by: disposeBag)
        
        output.phoneNumeberValidation
            .bind(with: self, onNext: { owner, result in
                owner.nextButton.backgroundColor = result ? .systemBlue : .systemRed
                owner.nextButton.isEnabled = result
            })
            .disposed(by: disposeBag)
        
        // 다음페이지 화면 전환
        output.nextButtontap
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
