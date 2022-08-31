//
//  URLSession + Extension.swift
//  SeSACWeek9
//
//  Created by 권민서 on 2022/08/30.
//

import Foundation

extension URLSession {
    
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    
    //반환값 무시하고 쓸게
    @discardableResult
    func customDataTask(_ endpoint: URLRequest, completionHandler: @escaping completionHandler) -> URLSessionDataTask {
        
        let task = dataTask(with: endpoint, completionHandler: completionHandler)
        task.resume()
        
        return task
    }
    
    static func requset<T: Codable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (T?, APIError?) -> Void) {
        
        //~shared session / urlRequest -> endpoint
        session.customDataTask(endpoint) { data, response, error in
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
                    let result = try JSONDecoder().decode(T.self, from: data)
                    //print(result)
                    //print(result.drwNoDate)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
        }
        
    }
    
}
