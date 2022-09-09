//
//  LoginViewController.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/09/01.
//

import UIKit

//텍스트 뷰모델로 보내줌 로그인 이메일 이름 등
//뷰모델에서 뷰로 보내줌
//왜 나누어주나? 이메일 유효성 검증, 닉네임 중복인지 아닌지에 대한 이슈 체크, 아이디에 대한 제한, 비밀번호의 제한을 실시간으로 처리하고 싶어서, 대문자 처리, 버튼이 다 입력이 잘되었을 때 컬러 바꿔주는 기능

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextFireld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //변화될때
        //글자가 바뀔 때 마다 viewModel에 전달 어떻게 처리?
        //바인딩에서 처리
        //listener 등록 과정
        viewModel.name.bind { text in
            self.nameTextFireld.text = text
        }
        viewModel.password.bind { text in
            self.passwordTextField.text = text
        }
        viewModel.email.bind { text in
            self.emailTextfield.text = text
        }
        
        viewModel.isVaild.bind { bool in
            self.loginButton.isEnabled = bool
            self.loginButton.backgroundColor = bool ? .red : .lightGray
        }
    }
    
    
    @IBAction func nameTextFieldChanged(_ sender: UITextField) {
        viewModel.name.value = nameTextFireld.text! //name이 옵셔널을 받지 않아서 강제 해제 연산자
        viewModel.checkValidation()
    }
    
    //글자 바뀔 때 마다
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        viewModel.password.value = passwordTextField.text!
        //실행해달라 요청
        viewModel.checkValidation()
    }
    
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        viewModel.email.value = emailTextfield.text!
        viewModel.checkValidation()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        viewModel.signIn {
            //화면 전환 코드
        }
    }
    
    
}
