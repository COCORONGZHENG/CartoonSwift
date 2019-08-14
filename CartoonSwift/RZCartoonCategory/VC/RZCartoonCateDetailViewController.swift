//
//  RZCartoonCateDetailViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/2.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
class RZCartoonCateDetailViewController: RZCartoonBaseViewController {
    var page : Int = 0
    var spinnerName : String?
    var hopeModel : CartoonHopeModel?
    var cateList = [CartoonCateDetailItemModel]()
    lazy var table : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(RZCartoonCateDetailTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonCateDetailTableViewCell")
        table.tableFooterView = UIView()
//        table.estimatedRowHeight = 200
//        table.rowHeight = UITableView.automaticDimension
        table.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getCateListFromSever(true)
        })
        table.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.getCateListFromSever(false)
        })
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.naviBarStyle(.green)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCateListFromSever(true)
    }
    
    convenience init(_ model : CartoonHopeModel) {
        self.init()
        self.hopeModel = model
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
                guard let spinnerModel = model.defaultParameters else {return}
                self.spinnerName = spinnerModel.defaultConTagType
                if isHeadRefresh {
                    self.cateList.removeAll()
                    self.cateList = model.comics ?? []
                    self.table.mj_header.endRefreshing()
                } else {
                    self.cateList.append(contentsOf: model.comics ?? [])
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

    override func initUI() {
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
            
        }
       
    }

}

extension RZCartoonCateDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /**
        var cell : RZCartoonCateDetailTableViewCell? = nil
        cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonCateDetailTableViewCell") as? RZCartoonCateDetailTableViewCell
        if cell == nil {
            cell = RZCartoonCateDetailTableViewCell(style: .default, reuseIdentifier: "RZCartoonCateDetailTableViewCell")
        }
        有些同学会出现的cell滚动后控件重叠现象可解决 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonCateDetailTableViewCell", for: indexPath) as! RZCartoonCateDetailTableViewCell
        cell.spinnerName = self.spinnerName
        cell.indexpath = indexPath
        cell.model = self.cateList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let model = self.cateList[indexPath.row]
    navigationController?.pushViewController(RZCartoonDetailPageViewController(commicID: model.comicId), animated: true)
        
    }
}
