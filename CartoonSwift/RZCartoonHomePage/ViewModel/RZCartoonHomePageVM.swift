//
//  RZCartoonHomePageVM.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/22.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import RxSwift

class RZCartoonHomePageVM: NSObject {
    /*使用single请求方法---没有使用**/
    
    func getHomepageCartoonList(parameters : [String : Any]) -> Single<CartoonHopeBaseModel> {
        return Single<CartoonHopeBaseModel>.create(subscribe: { (subscribe) -> Disposable in
            RZCartoonAlamofireTool.getDetailMessageWith(URL: BoutiqueList, Parmeter: parameters, CompleteBlock: { (code, msg, response) in
                if code == 1 {
                    
                    let dic = response as! Dictionary<String,AnyObject>
                    let returnData = dic["data"]?["returnData"]! as? Dictionary<String,AnyObject>
                    let model = CartoonHopeBaseModel.deserialize(from: returnData)
                    subscribe(.success(model ?? CartoonHopeBaseModel()))
                    
                    
                } else {
                    subscribe(.error(response as! Error))
                }
            })
            return Disposables.create()
        })
    }
    
    
     /*使用Observable请求方法---推荐列表接口**/
    func getHomepageCartoonList(parameters : [String : Any],completeBlock : @escaping CartoonCompleteBlock) {
     
        _ = RZCartoonAlamofireTool.getRequest(BoutiqueList, parameters).subscribe(onNext: { (response) in
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            let model = CartoonHopeBaseModel.deserialize(from: returnData)
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
            //            print(response)
        }, onError: { (error) in
            print(error)
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(BoutiqueList) 请求完成")
        }) {
            
        }
    }
    
    /*Vip列表接口**/
    func getVipList(_ completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(VipList).subscribe(onNext: { (response) in
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            let model = CartoonHopeBaseModel.deserialize(from: returnData)
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
//            print(data)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(VipList) 请求完成")

        }) {
            
        }
        
    }
    /*订阅列表接口**/
    func getSubscribeList(_ completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(NewSubscribeList).subscribe(onNext: { (response) in
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            let model = CartoonHopeBaseModel.deserialize(from: returnData)
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
//            print(data)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(NewSubscribeList) 请求完成")
        }) {
            
        }
        
    }
    /*排行列表接口**/
    func getSortList(_ completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(SortList).subscribe(onNext: { (response) in
            
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            let model = CartoonHopeBaseModel.deserialize(from: returnData)
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
//            print(data)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(SortList) 请求完成")
        }) {
            
        }
        
    }
    
    /// 分类列表接口
    ///
    /// - Parameter completeBlock: 回调
    func getCateList(_ completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(CateList).subscribe(onNext: { (response) in
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            let model = CartoonHopeBaseModel.deserialize(from: returnData)
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(CateList) 请求完成")
        }) {
            
        }
        
    }
    
    func getCommicDetail(param : [String : Any],_ completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(CommicDetail, param).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            var model = CartoonHopeBaseModel.deserialize(from: returnData)
            if model == nil {
                model = CartoonHopeBaseModel()
            }
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(CommicDetail) 请求完成")
        }) {
            
        }
    }
    
    func getCommentList(param : [String : Any],completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(CommentList, param).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            let model = CartoonCommentBaseModel.deserialize(from: returnData)
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(CommentList) 请求完成")
        }) {
            
        }
        
        
    }
    
    
    func getRealTimeDetail(param : [String : Any],completeBlock : @escaping CartoonCompleteBlock) {
        
        _ = RZCartoonAlamofireTool.getRequest(RealtimeList, param).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            
            let returnData = data["returnData"] as? [String : Any]
            
            let model = CartoonDetailRealtimeModel.deserialize(from: returnData)
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(RealtimeList) 请求完成")
        }) {
            
        }
    }

    
    func getGuessLikeList(completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(GuessLikeList).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            let model = CartoonGuessLikeBaseModel.deserialize(from: returnData)
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(GuessLikeList) 请求完成")
        }) {
            
        }
    }
   
    
    func getCateDetailList(param : [String : Any],completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(CommicList, param).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            var model = CartoonCommicsModel.deserialize(from: returnData)
            if model == nil {
                model = CartoonCommicsModel()
            }
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(CommicList) 请求完成")
        }) {
            
        }
    }
    
    
    func getSpecialList(parma : [String : Any],completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(SpecialList, parma).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            var model = CartoonCommicsModel.deserialize(from: returnData)
            if model == nil {
                model = CartoonCommicsModel()
            }
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(SpecialList) 请求完成")
        }) {
            
        }
    }
    
    
    func getChapterDetail(param : [String : Any],completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(ChapterDetail, param).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            var model = CartoonChapterModel.deserialize(from: returnData)
            if model == nil {
                model = CartoonChapterModel()
            }
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(SpecialList) 请求完成")
        }) {
            
        }
        
    }
    
    
    func getSearchHotDetail(_ completeBlock : @escaping CartoonCompleteBlock) {
        _ =  RZCartoonAlamofireTool.getRequest(SearchHot).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            var model = CartoonHotSearchModel.deserialize(from: returnData)
            if model == nil {
                model = CartoonHotSearchModel()
            }
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
            
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
             debugPrint("\(SearchHot) 请求完成")
        }) {
            
        }
        
    }
    
    
    func getSearchKeyResult(_ param : [String : Any],completeBlock : @escaping CartoonCompleteBlock) {
        
        _ = RZCartoonAlamofireTool.getRequest(SearchRelative, param).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            var model = CartoonSearchRelativeModel.deserialize(from: data)
            if model == nil {
                model = CartoonSearchRelativeModel()
            }
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(SearchRelative) 请求完成")
        }) {
            
        }
        
    }
    
    
    
    func getSearchResult(_ param : [String : Any],completeBlock : @escaping CartoonCompleteBlock) {
        _ = RZCartoonAlamofireTool.getRequest(SearchResult, param).subscribe(onNext: { (response) in
            print(response)
            let data = response["data"] as! [String : Any]
            let returnData = data["returnData"] as? [String : Any]
            var model = CartoonCommicsModel.deserialize(from: returnData)
            if model == nil {
                model =  CartoonCommicsModel()
            }
            completeBlock(response["code"]! as! Int,data["message"] as! String,model!)
        }, onError: { (error) in
            completeBlock(-1,"失败",error)
        }, onCompleted: {
            debugPrint("\(SearchResult) 请求完成")
        }) {
            
        }
        
    }
    
    
    
    
}
