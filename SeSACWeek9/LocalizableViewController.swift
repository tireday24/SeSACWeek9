//
//  LocalizableViewController.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/09/06.
//

import UIKit
import MessageUI //메일로 문의 보내기, 디바이스 테스트, 아이폰 메일 계정을 등록 해야 가능

/*
 리뷰 남기기 -> 리뷰 얼럿: 1년에 한 디바이스 당 3회 카운트 체크나 realm record 비교 해서 오픈해주자
 SKStoreReviewController
 문의남기기 ->
 */


class LocalizableViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var myLable: UILabel!
    @IBOutlet weak var sampleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "navigation_title".localized
        
        myLable.text = "introduce".localized(with: "고래밥") //userDefault
        
        //String(format: NSLocalizedString("introduce", comment: ""), "고래밥")
        
        //나는 0살입니다
        //I am 8 years old.
        
        //저는 고래밥입니다
        // i am jack //순서 바뀔 때 다국어 대응 어떻게 해야할까
        
        sampleButton.setTitle("common_cancle".localized, for: .normal)
        searchBar.placeholder = "search_placeholder".localized
        
        inputTextField.placeholder = "number_test".localized(number: 11)
        
        //inputTextField.placeholder = String(format: NSLocalizedString("number_test", comment: ""), 11)
        //swiftGen 사용시 localizable String 만들어줌
        //R.Swift 리터럴한 정보를 정리해줌 R에서는 선택적 리소스 대응 못 함
        //앱 이름 위치 디스크립션 언어 지정 따로 해줘야함
        //인포필에 bundleName 보통 지정한다
        
        //CLLocationManager().requestWhenInUseAuthorization() //alert 구문
        //설정 페이지에서 다국어 설정 가능
        
    }
    
    func sendMail() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.setToRecipients([]) //[]안에 개인 메일
            mail.setSubject("고래밥 다이어리 문의사항 - ")//메일 제목도 미리 세팅 가능
            mail.mailComposeDelegate = self
            
            self.present(mail, animated: true)
            //
        } else {
            //alert. 메일 등록을 해주시거나 ~로 문의 주세요
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result { //케이스 별로 대응 가능
        case .cancelled:
            <#code#>
        case .saved:
            <#code#>
        case .sent:
            <#code#>
        case .failed:
            <#code#>
        }
        controller.dismiss(animated: true) //메일 띄우는거 자체는 delegate 필요 없음
    }
}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
    
    func localized(number: Int) -> String {
        return String(format: self.localized, number)
    }
    
}
