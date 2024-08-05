//
//  PhoneViewModel.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    private var userPhoneNumber = BehaviorRelay(value: "010")
    var outPutSetPhoneNumber: BehaviorRelay<String>
    
    
    struct Input {
        let phoneText: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    struct Output {
        let changedPhoneNumber:  Observable<ControlProperty<String>.Element>
        let phoneNumeberValidation: Observable<Bool>
        let nextButtontap: ControlEvent<Void>
    }
   
    
    init() {
        outPutSetPhoneNumber = userPhoneNumber
        
    }
    
//    func phoneNumberSet() {
//       
//    }
    
    func transform(input: Input) -> Output {
        
        let changedPhoneNumber = input.phoneText.orEmpty
            .map { text in
                text.filter { "0123456789".contains($0) }
            }
        
        
        let phoneValidation = input.phoneText.orEmpty
        .map { $0.count >= 10  }
        
        let nextButtonTap = input.nextButtonTap
        
        return Output(changedPhoneNumber: changedPhoneNumber, phoneNumeberValidation: phoneValidation, nextButtontap: nextButtonTap)
    }
    
}
