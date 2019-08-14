//
//  RZCartoonAnimaDetailViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/5.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import MJRefresh
class RZCartoonAnimaDetailViewController: RZCartoonBaseViewController {
    var isUpdate : Bool = false
    var page : Int = 1
    var hopeModel : CartoonHopeModel?
    var speciaList = [CartoonCateDetailItemModel]()
    lazy var table : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.tableFooterView = UIView()
        table.register(RZCartoonAnimationTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonAnimationTableViewCell")
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getAnimaListFromSever(true)
        })
        table.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.getAnimaListFromSever(false)
        })
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUpdate {
            getCateListFromSever(true)
        } else {
            getAnimaListFromSever(true)
        }
    }
    
    convenience init(_ model : CartoonHopeModel) {
        self.init()
        hopeModel = model
        
    }

    override func initUI() {
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func getCateListFromSever(_ isHeadRefresh : Bool) {
        RZProgressHUD.showHUD()
        if isHeadRefresh {
            page = 1
        }
        RZCartoonHomePageVM().getCateDetailList(param: ["argCon" : self.hopeModel?.argCon ?? 0,"argName" : self.hopeModel?.argName ?? "","argValue" : self.hopeModel?.argValue ?? 0,"page" : page]) { (code, msg, json) in
            RZProgressHUD.hideHUD()
            if code == 1 {
                let model = json as! CartoonCommicsModel
                print(json)
                if isHeadRefresh {
                    self.speciaList.removeAll()
                    self.speciaList = model.comics ?? []
                    self.table.mj_header.endRefreshing()
                } else {
                    self.speciaList.append(contentsOf: model.comics ?? [])
                    if model.hasMore == 1 {
                        self.table.mj_footer.endRefreshing()
                    } else {
                        self.table.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                self.page += 1
                self.table.reloadData()
            } else {
                
            }
        }
    }
    
    
    func getAnimaListFromSever(_ isHeadRefresh : Bool)  {
        RZProgressHUD.showHUD()
        if isHeadRefresh {
            page = 1
        }
        RZCartoonHomePageVM().getSpecialList(parma: ["argCon" : 4,"page" : page]) { (code, msg, json) in
            RZProgressHUD.hideHUD()
            if code == 1 {
                let model = json as! CartoonCommicsModel
                if isHeadRefresh {
                    self.speciaList.removeAll()
                    self.speciaList = model.comics ?? []
                    self.table.mj_header.endRefreshing()
                } else {
                    self.speciaList.append(contentsOf: model.comics ?? [])
                    if model.hasMore == 1 {
                        self.table.mj_footer.endRefreshing()
                    } else {
                       self.table.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                self.table.reloadData()
                self.page += 1
            } else {
                RZProgressHUD.tost("获取SpecialList失败")
            }
        }
    }
}

extension RZCartoonAnimaDetailViewController : UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.speciaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "RZCartoonAnimationTableViewCell", for: indexPath) as! RZCartoonAnimationTableViewCell
        cell.model = self.speciaList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.speciaList[indexPath.row]
        var html: String?
        if item.specialType == 1 {
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_v3.html"
        } else if item.specialType == 2{
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_new.html"
        } else {
            RZProgressHUD.tost("客官，下面没有了")
        }
        guard let host = html else { return }
        let path = "special_id=\(item.specialId)&is_comment=\(item.isComment)"
        let url = [host, path].joined(separator: "?")
        let vc = RZCartoonBaseWebViewController(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    
}
