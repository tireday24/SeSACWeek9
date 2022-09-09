//
//  LoginViewModel.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/09/01.
//

import Foundation

class LoginViewModel {
    
    //반응형으로 만들거다
    //UI요소 뺴고 다 씀
    var email: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    var name: Observable<String> = Observable("")
    var isVaild: Observable<Bool> = Observable(false)
    
    func checkValidation() {
        if email.value.count >= 6 && password.value.count >= 4 {
            isVaild.value = true
        }else {
            isVaild.value = false
        }
    }
    
    func signIn(complition: @escaping () -> Void) {
        
        UserDefaults.standard.set(name.value, forKey: "name")
        
        complition()
    }
    
    
    
}
