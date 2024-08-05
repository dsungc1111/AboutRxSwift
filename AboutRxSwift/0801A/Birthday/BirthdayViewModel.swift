//
//  BirthdayViewModel.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa


class BirthdayViewModel {
    
    
    struct Input {
        let datepick: ControlProperty<Date>
        let completeButtonTap: ControlEvent<Void>
    }
    struct Output {
        let nowAge: BehaviorRelay<Int>
        let pickDate: BehaviorRelay<String>
        let completeButtonTap: ControlEvent<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let today = Date()
        let pickDate =  BehaviorRelay(value: BirthdayVC.getDateString(date: today))
        let nowAge = BehaviorRelay(value: 0)
        
        input.datepick
            .bind(with: self) { owner, value in
                
                let component = Calendar.current.dateComponents([.day, .month, .year], from: value)
                pickDate.accept(BirthdayVC.getDateString(date: value))
               
                // 오늘
                guard let todayMonth = Int(BirthdayVC.getTodayMonth(date: today)) else { return }
                guard let todayDay = Int(BirthdayVC.getTodayday(date: today)) else { return }
    
                // 생일
                guard let birthMonth = component.month else { return }
                guard let birthDay = component.day else { return }
                var age = 2024 - (component.year ?? 0) - 1
                
                if birthMonth == todayMonth {
                    if birthDay <= todayDay {
                        age += 1
                    }
                } else if birthMonth < todayMonth {
                    age += 1
                }
                nowAge.accept(age)
            }
            .disposed(by: disposeBag)
      
        
        return Output(nowAge: nowAge, pickDate: pickDate, completeButtonTap: input.completeButtonTap)
    }
    
    
}
