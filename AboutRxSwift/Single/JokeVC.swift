//
//  JokeViewController.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class JokeVC: UIViewController {

    
    private let textLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private let testButton = UIButton()
    private let viewModel = JokeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        bind()
        configureLayout()
    }

    
    
    func bind() {
        
        let input = JokeViewModel.Input(tap: testButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        // 굳이굳이 예시를 위한 상황 세팅
        // text를 레이블과 네비게이션바 타이틀에 세팅할거
        
        
        output.text
            .bind(with: self) { owner, value in
                owner.textLabel.text = value
                print("얘도 실행")
            }
            .disposed(by: disposeBag)
        
        output.text
            .bind(with: self) { owner, value in
                owner.navigationItem.title = value
                print("야도 실행22")
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(textLabel)
        view.addSubview(testButton)
        
        
        textLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
        }
        textLabel.backgroundColor = .systemCyan
        
        testButton.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        testButton.backgroundColor = .lightGray
        testButton.setTitle("버튼 클릭", for: .normal)
    }
}
