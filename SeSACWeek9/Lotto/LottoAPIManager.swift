//
//  LottoAPIManager.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/08/30.
//

import Foundation

//urlSession
//url data task 일반 통신 url upload task 다운로드
//shared - 단순한, 커스텀X 응답 클로저, 백그라운드 X
//default configuration - shared 설정 유사 커스텀 가능(셀룰러 연결 여부, 타임 아웃 간격 요청하고 일정 시간 반응 없으면 문제 발생했다고 알려줌), 응답 클로저 + 딜리게이트

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

struct LottoAPIManager {
    
    //메인스레드
    static func requestLotto(drwNo: Int, completion: @escaping (Lotto?, APIError?) -> Void) {
        
        let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)")!
        
        
        
        //헤더가 있는 경우 urlRequest로 처리
        //let a = URLRequest(url: url)
        //a.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)
        
        //싱글톤패턴 shared init 백그라운드 background (멜론 음악 재생시 뒤에 깔림 ephamal 휘발성)
        //어디에다가 보낼래? url 주소, ComplitionHandler 네트워크 요청 성공시 매개변수에 담아서 보내줌 3개 다 옵셔널
        //데이터 들어있는 데이터
        //response 어떤 url? 에러 여부, 헤더 정보
        //error ni? -> response, data nilX error ? -> response data에 오류가 있음
        //글로벌 스레드 마지막에 main스레드로 바꿔주어야한다
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            
            DispatchQueue.main.async {
                //error nil? 어떤 오류 발생?
                guard error == nil else {
                    //print("Faild Request")
                    completion(nil , .failedRequest)
                    return //early exit
                }
                
                guard let data = data else {
                    //print("No Data Returned")
                    completion(nil, .noData)
                    return
                }
                
                //타입캐스팅을 통해서 내용을 구체적으로 표기
                //response TypeCasting시 문제?
                // 후자는 클로져로 넘어온 전자는 타입이 바뀐 response
                guard let response = response as? HTTPURLResponse else {
                    //print("Unable Response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                //타입캐스팅 한 이유는 statusCode 꺼내려고
                //타입이 바뀐 response
                guard response.statusCode == 200 else {
                    //print("Faild Response")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Lotto.self, from: data)
                    //print(result)
                    //print(result.drwNoDate)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
        }.resume() //요청을 해달라는 메서드 메서드 빠지면 어떤 동작도 실행이 안된다
    }
}
