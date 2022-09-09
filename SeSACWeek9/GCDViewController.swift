//
//  GCDViewController.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/09/02.
//

import UIKit

class GCDViewController: UIViewController {

    let url1 = URL(string: "https://apod.nasa.gov/apod/image/2201/OrionStarFree3_Harbison_5000.jpg")!
    let url2 = URL(string: "https://apod.nasa.gov/apod/image/2112/M3Leonard_Bartlett_3843.jpg")!
    let url3 = URL(string: "https://apod.nasa.gov/apod/image/2112/LeonardMeteor_Poole_2250.jpg")!
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thridImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func serialSync(_ sender: UIButton) {
        print("START")
        
        for i in 1...100 {
            print(i, terminator: " ")
        }
        
        //디스패치 직렬에서 사용하지 않음 교착상태 발생
        //DispatchQueue.main.sync -> X
      
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
        
        
    }
    
   
    @IBAction func serialAsync(_ sender: UIButton) {
        print("START")
        
        //나중에 실행하게 됨 하나의 테스크
//        DispatchQueue.main.async {
//            for i in 1...100 {
//                print(i, terminator: " ")
//            }
//        }
        
        //100개의 테스크가 넘어감
        for i in 1...100 {
            DispatchQueue.main.async {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
        
    }
    
    @IBAction func globalSync(_ sender: UIButton) {
        print("START", terminator: " ")
        
        //다음 작업 할떄까지 기다림 결국 보내줘도 큐에서 선입선출이라 들어온 순서대로 처리
        //글로벌 큐 sync ? 메인스레드에서 처리하는거랑 똑같음 -> 메인스레드에서 처리하게 함
        //이 코드도 쓸일이 없다
        DispatchQueue.global().sync {
            for i in 1...100 {
                print(i, terminator: " ")
            }
            
        }
       
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
        
    }
    
    @IBAction func globalAsync(_ sender: UIButton) {
        
        //섞여서 출력됨 큐한테 테스크 넘기자마자 메인스레드에서 다음거 처리하기 때문에
        print("START\(Thread.isMainThread)", terminator: " ")
        
//        DispatchQueue.global().async {
//            for i in 1...100 {
//                print(i, terminator: " ")
//            }
//        }
        
        //여러곳에 뿌린 후 task와 상관 없이 순서대로 작업처리 큐 선입선출
        for i in 1...100 {
            DispatchQueue.global().async {
                print(i, terminator: " ")
            }
        }
      
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END \(Thread.isMainThread)")
        
        
    }
    
    
    @IBAction func qos(_ sender: UIButton) {
        
        let customQueue = DispatchQueue(label: "concurrentSeSAC", qos: .userInteractive, attributes: .concurrent)
        
        customQueue.async {
            print("START")
        }
        
     
        for i in 1...100 {
            DispatchQueue.global(qos: .background).async{
                print(i, terminator: " ")
            }
            print(i, terminator: " ")
        }
        
        //우선순위 userInteractive 중요도 1
        //중요도가 높으면? 더 많은 스레드에 작업 분배됨
        //2위 userInitiated 3위 Utility / unspecified 사용 안됨
        
        for i in 101...200 {
            DispatchQueue.global(qos: .userInteractive).async{
                print(i, terminator: " ")
            }
            print(i, terminator: " ")
        }
        
        
        
        for i in 201...300 {
            DispatchQueue.global(qos: .utility).async{
                print(i, terminator: " ")
            }
            print(i, terminator: " ")
        }
}
    
    @IBAction func dispatchGroup(_ sender: UIButton) {
        //그룹으로 묶어서 신호를 하나씩 받는다
        let group = DispatchGroup()
        
        
        //다른 스레드로 보냄 동기함수 구문 자체는 비동기지만 순서대로 처리됨
        DispatchQueue.global().async(group: group) {
            for i in 1...100 {
                print(i, terminator: " ")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            
            for i in 101...200 {
                print(i, terminator: " ")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            for i in 201...300 {
                print(i, terminator: " ")
            }
        }
        
        //신호를 준다 끝나는 시점 알려줌 여러API 하나의 뷰에 뿌려줄 때 사용
        group.notify(queue: .main) {
            print("끝") //tableView.reload
        }
        
    }
    
    func request(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        //또다른 글로벌 스레드가 동작을한다 네트워크 통신은 기본적으로 비동기
        //보내놓고 바로 일 처리 시작
        //노티파이쪽으로 신호 보냄 클로저 끝내기 전에
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                //실패한 경우
                completionHandler(UIImage(systemName: "star"))
                return
            }
            //이미지 전달
            let image = UIImage(data: data)
            completionHandler(image)
            
        }.resume()
    }
    
    @IBAction func dispatchGroupNASA(_ sender: UIButton) {
        
//        request(url: url1) { image in
//            print("1")
//            self.request(url: self.url2) { image in
//                print("2")
//
//            self.request(url: self.url3) { image in
//                print("3")
//                print("끝 갱신")
//            }
//        }
//        }
    
        let group = DispatchGroup()
        
        
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url1) { image in
                
                print("1")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url2) { image in
                print("2")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url3) { image in
                print("3")
            }
        }
        
        group.notify(queue: .main) {
            print("끝 완료")
        }
        
    }
    
    @IBAction func enterLeave(_ sender: UIButton) {
        
        let group = DispatchGroup()
        
        var imageList: [UIImage] = []
        
        //함수의 시작과 끝을 알려준다
        group.enter() //레퍼런스 카운트 + 1
        request(url: url1) { image in
            print("1")
            
            imageList.append(image!)
            
            group.leave()//레퍼런스 카운트 - 1
        }
        
        group.enter()
        request(url: url2) { image in
            print("2")
            imageList.append(image!)
            group.leave()
        }
        
        group.enter()
        request(url: url3) { image in
            print("3")
            imageList.append(image!)
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.firstImage.image = imageList[0]
            self.secondImage.image = imageList[1]
            self.thridImage.image = imageList[2]
            print("끝 완료")
        }
        
    }
    
    @IBAction func raceCondition(_ sender: UIButton) {
        
        let group = DispatchGroup()
        
        var nickname = "SeSAC"
        
        DispatchQueue.global(qos: .userInteractive).async(group: group){
            nickname = "고래밥"
            print("first: \(nickname)")
        }
        
        DispatchQueue.global(qos: .userInteractive).async(group: group){
            nickname = "칙촉"
            print("second: \(nickname)")
        }
        
        DispatchQueue.global(qos: .userInteractive).async(group: group){
            nickname = "올라프"
            print("third: \(nickname)")
        }
        
        group.notify(queue: .main){
            print("result: \(nickname)")
        }
        
    }
}
