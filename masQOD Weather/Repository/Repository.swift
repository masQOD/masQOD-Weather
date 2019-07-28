//
//  Repository.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 28/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Repository{
    typealias jsonCompletion = (JSON, Repository) -> ()
    
    var baseUrl: String?
    var sessionManager: SessionManager?
    
    
    
    func RequestAsync(url: String, headers: Dictionary<String, String>? = nil, httpMethod: HTTPMethod = .get, parameters: Parameters? = nil, completion: @escaping jsonCompletion, errorCompletion: @escaping jsonCompletion)
    {
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10000
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 100000000
        sessionManager = SessionManager(configuration: config)
        
        var defaultHeaders = ["Content-Type":"application/json"]
        
        if(headers != nil)
        {
            for key in headers!.keys {
                defaultHeaders.updateValue(headers![key]!, forKey: key)
            }
        }
        
        
        let urlString = url
        sessionManager?.request(urlString, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default , headers: defaultHeaders)
            .validate()
            .responseJSON{
                response in
                
                switch response.result{
                case .success(let data):
                    let result = JSON(data)
                    completion(result, self)
                case .failure:
                    
                    if let statusCode = response.response?.statusCode{
                        if(statusCode == 200){
                            completion(JSON(""), self)
                            //                            errorCompletion(["error" : "Anda tidak terhubung dengan internet"])
                        }
                        else if(statusCode == 400){
                            errorCompletion(["error": "Connection Failure"], self)
                        }
                            //                        else if(statusCode == 401){
                            //                            //session abis
                            //                        }
                        else
                        {
                            var result: JSON?
                            if(!NetworkReachabilityManager()!.isReachable)
                            {
                                result = ["error" : "Connection Failure"]
                            }
                            else if let data = response.data {
                                
                                //                                result = JSON(data: data)
                                do {
                                    result = try JSON(data: data)
                                } catch _ {
                                    result = nil
                                }
                            }
                            else
                            {
                                result = JSON("")
                            }
                            
                            errorCompletion(result!, self)
                        }
                    }
                    else{
                        var result: JSON?
                        result = ["error" : "Connection Failure"]
                        errorCompletion(result!, self)
                    }
                    
                    
                }
        }
    }
}
