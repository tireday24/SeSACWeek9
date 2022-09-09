//
//  Sample.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/09/01.
//

import Foundation

//제네릭으로 다루어줘서 타입에 따라 달라진다
class User<T> {
    
    //매개변수 설정해주기
    //리스너로 업데이트 됐을 때 찍힘
    //리스너는 항상 같은 역할을 하기 때문에 (역할을 주면) 실행되는 쪽에서 기능 구현
    private var listener: ((T) -> Void)? //옵셔널 처리해도 상관없다 = {}
    
    var value: T {
        didSet {
            //클로저여서 타입만 맞으면 받음
            //print("nameChangerd: \(oldValue) -> \(name)")
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    //함수 만들기 이름 만들고 뭐 해줄거야?
    func bind(_ complitionHandler: @escaping (T) -> Void) {
        //실행은 실행하는데로 해라
        //결과적으로 실제로 바뀌는 지점에 didSet
        //네임이 바뀌기 전에 complitionHandler 실행되기 때문에 Print
        //그 후에 listner로 업데이트
        //최초 상황은 만들어준다
        complitionHandler(value)
        //타입 같으니까 상관없자나??
        listener = complitionHandler
    }
        
}


