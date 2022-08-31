//
//  ViewController.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/08/30.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var lottoLable: UILabel!
    
    private var viewModel = PersonViewModel()
    
    //var list: Person = Person(page: 0, totalPages: 0, totalResults: 0, results: [])
    //Nil 통신 이후에 값이 들어옴 그래서 데이터 갱신 해주어야함 서버 통신전에 테이블이 그려지는데 list가 nil에서 통신 후에 값이 들어오기 전에 뷰가 이미 뷰디드로드 전에 그려버려서 갱신 후에 값 들어옴 요청은 했으나 응답은 나중에 옴 tableView는 list에 0개에서 20개로 갱신됨 nil일 때 0개가 안나옴 처음에는 Nil일 수 밖에 없다
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchPerson(query: "kim")
        viewModel.list.bind { person in
            print("viewController bind")
           
            self.tableView.reloadData()
        }

        
          
//        LottoAPIManager.requestLotto(drwNo: 1011) { success, error in
//
//            guard let success = success else {
//                return
//            }
//
//            //LottoAPIManager 자체에서 선언해주어서 따로 안해줘도 된다
//            //DispatchQueue.main.async {
//            self.lottoLable.text = success.drwNoDate
//            //}
//
//        }
        
//        PersonAPIManager.requestPerson(query: "Kim") { person, error in
//            guard let person = person else {
//                return
//            }
//            dump(person)
//            self.list = person
//            self.tableView.reloadData()
//
//        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let data = viewModel.cellForRowAt(at: indexPath)
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.knownForDepartment
        return cell
    }
    
}
