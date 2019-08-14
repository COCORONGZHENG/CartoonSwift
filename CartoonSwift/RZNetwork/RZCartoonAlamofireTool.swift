//
//  RZCartoonAlamofireTool.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/23.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
import RxAlamofire

public typealias CartoonCompleteBlock = ((Int,String,Any) -> Void)

var manage : SessionManager?

class RZCartoonAlamofireTool: NSObject {
    
    class func getFullURL(url : String) -> String {
        let fullURL = cartoonBaseURL + url
        return fullURL
    }
    
    class func getDetailMessageWith(URL url : String,Parmeter parmeters : [String : Any],CompleteBlock : @escaping CartoonCompleteBlock) {
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        let URLStr = getFullURL(url: url)
        
        /* alamofire请求方式
        request(URLStr, method: .get, parameters: parmeters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
        }
            原生请求方式
        URLSession.shared.dataTask(with: (URL(string: url)!)) { (data, response, error) in
            debugPrint(response)
        }
        **/
      
        Alamofire.request(URLStr, method: .get, parameters: parmeters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case.success(let json):
                let dict = json as! Dictionary<String,AnyObject>
                print(dict["data"]!)
                
                CompleteBlock(dict["code"]! as! Int,dict["data"]?["message"] as! String,dict)
                
            case.failure(let error):
                print("\(error)")
                CompleteBlock(-1,"失败",error)
            }
        }
        
    }
    
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    @discardableResult
    class func getRequest(_ url:String,_ params : [String : Any]? = nil) -> Observable<[String : Any]> {
        
        return Observable<[String : Any]>.create({ (observable) -> Disposable in
            let fullstr = getFullURL(url: url)
            let headers: HTTPHeaders = [
                "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                "Accept": "application/json"
            ]
            self.sharedSessionManager.request(fullstr, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                switch response.result {
                case.success(let json):
                    let dict = json as! [String : Any]
                    print(dict)
                    observable.onNext(dict)
                    observable.onCompleted()
                case.failure(let error):
                    print("\(error)")
                    observable.onError(error)
                }
            }
            return Disposables.create()
        })
        
    }
    
    
}
