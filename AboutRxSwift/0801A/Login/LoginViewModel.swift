//
//  LoginViewModel.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa


class LoginViewModel {
    
    
    struct Input {
        let emailText: ControlProperty<String?>
        let pwText: ControlProperty<String?>
        let nicknameText: ControlProperty<String?>
        let loginTap: ControlEvent<Void>
    }
    struct Output {
        let emailValid: Observable<Bool>
        let pwValid: Observable<Bool>
        let nicknameValid: Observable<Bool>
        let loginTap: ControlEvent<Void>
    }
    
    private let userList = ["UserA", "UserB", "UserC", "UserD"]
    
    func transform(input: Input) -> Output {
       
        let emailValid = input.emailText.orEmpty
            .map { $0.count >= 4 && $0.contains("@") } // 4자리 이상 & @ 포함 > T
        let pwValid = input.pwText.orEmpty
            .map { $0.count >= 8 } // 8자리 이상 T
        
        let nicknameValid = input.nicknameText.orEmpty
            .map { !self.userList.contains($0) && $0.count >= 4 && !$0.contains(" ")}
        
        
        
        return Output(emailValid: emailValid, pwValid: pwValid, nicknameValid: nicknameValid, loginTap: input.loginTap)
        
    }
}
