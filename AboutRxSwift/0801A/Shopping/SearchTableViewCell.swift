//
//  SearchTableViewCell.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchTableViewCell"
    
    
    let completeButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        return btn
    }()
     var isComplete = false
    let todoLabel = {
        let label = UILabel()
        label.text = "ㅇㅇㄹㄴㅁㅇㄹㅇㄹㅇㄴ"
        return label
    }()
    
    let bookmarkButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        return btn
    }()
    var isBookmark = false
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    
    private func configure() {
        contentView.addSubview(completeButton)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(todoLabel)
        
        completeButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.size.equalTo(20)
        }
        bookmarkButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.size.equalTo(20)
        }
        todoLabel.snp.makeConstraints { make in
            make.leading.equalTo(completeButton.snp.trailing).offset(5)
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(5)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
    }
    
}
