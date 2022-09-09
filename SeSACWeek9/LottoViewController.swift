//
//  LottoViewController.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/09/01.
//

import UIKit

class LottoViewController: UIViewController {
    
    @IBOutlet weak var lable1: UILabel!
    @IBOutlet weak var lable2: UILabel!
    @IBOutlet weak var lable3: UILabel!
    @IBOutlet weak var lable4: UILabel!
    @IBOutlet weak var lable5: UILabel!
    @IBOutlet weak var lable6: UILabel!
    @IBOutlet weak var lable7: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    
    var viewModel = LottoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel.fetchLottoAPI(drwNo: 1000)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.viewModel.fetchLottoAPI(drwNo: 1022)
        }
        
        bindData()
        
    }
    
    func bindData() {
        //이 데이터 어디다가 적용?
        viewModel.number1.bind { value in
            self.lable1.text = "\(value)"
        }
        viewModel.number2.bind { value in
            self.lable2.text = "\(value)"
        }
        viewModel.number3.bind { value in
            self.lable3.text = "\(value)"
        }
        viewModel.number4.bind { value in
            self.lable4.text = "\(value)"
        }
        viewModel.number5.bind { value in
            self.lable5.text = "\(value)"
        }
        viewModel.number6.bind { value in
            self.lable6.text = "\(value)"
        }
        viewModel.number7.bind { value in
            self.lable7.text = "\(value)"
        }
        viewModel.lottoMoney.bind { money in
            self.dateLable.text = "\(money)"
        }
    }
    

  

}
