//
//  Observable.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/08/31.
//

import Foundation

//양방향 바인딩
class Observable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            print("didset", value)
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        print(#function)
        closure(value)
        listener = closure //타입 같아서 대입 가능 bind 사용하게 되면 클로저 구문으로 실행시키면 같은 코드가 수행할 수 있도록 프로퍼티 변수에 담아주고 변경되면 didset이 실행됨
    }
    
}

