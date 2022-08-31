//
//  PersonAPIManager.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/08/30.
//

import Foundation

class PersonAPIManager {
    
    static func requestPerson(query: String, completion: @escaping (Person?, APIError?) -> Void) {
        
        let url = URL(string: "https://api.themoviedb.org/3/search/person?api_key=3f9e2de9a5e1d3cdd15e85fe6401b6b3&language=en-US&query=\(query)&page=1&include_adult=false&region=ko-KR")!
        
        let scheme = "https"
        let host = "api.themoviedb.org"
        let path = "/3/search/person"
        
        let language = "ko-KR"
        let key = "3f9e2de9a5e1d3cdd15e85fe6401b6b3"
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "region", value: language)
        ]
        
        //0831
//        URLSession.requset(endpoint: component.url!) { success, fail in
//            <#code#>
//        }
        
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
                    let result = try JSONDecoder().decode(Person.self, from: data)
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
