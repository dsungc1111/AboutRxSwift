//
//  BirthdayVC.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthdayVC: UIViewController {
    
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let userInfoLabel = {
        let label = UILabel()
        label.text = "만 17세 이상만 가입가능합니다."
        label.textAlignment = .center
        return label
    }()
    
    let completeButton = {
        let btn = UIButton()
        btn.setTitle("다음으로!", for: .normal)
        return btn
    }()
    
    let today = Date()
    
    var nowAge = BehaviorRelay(value: 0)
    
    let disposeBag = DisposeBag()
    let viewModel = BirthdayViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        bind()
        
    }
    
    func bind() {
        
        let input = BirthdayViewModel.Input(datepick: datePicker.rx.date, completeButtonTap: completeButton.rx.tap)
        let output = viewModel.transform(input: input)
        
       
        output.pickDate
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nowAge
            .bind(with: self, onNext: { owner, value in
                if value < 17 {
                    owner.userInfoLabel.text = "현재 \(value)살, 만 17세 미만입니다."
                    owner.userInfoLabel.textColor = .red
                    owner.completeButton.backgroundColor = .lightGray
                    owner.completeButton.isEnabled = false
                } else {
                    owner.userInfoLabel.text = "현재 \(value)살, 만 17세 이상입니다."
                    owner.userInfoLabel.textColor = .systemBlue
                    owner.completeButton.backgroundColor = .systemBlue
                    owner.completeButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        
        output.completeButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(ShoppingVC(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
    func configureLayout() {
        view.addSubview(datePicker)
        view.addSubview(dateLabel)
        view.addSubview(userInfoLabel)
        view.addSubview(completeButton)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(300)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        userInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
}


extension BirthdayVC {
    
    static let dateformatter = DateFormatter()
    
    
    static func getDateString(date: Date) -> String {
        BirthdayVC.dateformatter.dateFormat = "yyyy년 MM월 dd일"
      
        return BirthdayVC.dateformatter.string(from: date)
    }
    
    
    static func getTodayMonth(date: Date) -> String {
        BirthdayVC.dateformatter.dateFormat = "MM"
      
        return BirthdayVC.dateformatter.string(from: date)
    }
    static func getTodayday(date: Date) -> String {
        BirthdayVC.dateformatter.dateFormat = "dd"
      
        return BirthdayVC.dateformatter.string(from: date)
    }
    
    
}
