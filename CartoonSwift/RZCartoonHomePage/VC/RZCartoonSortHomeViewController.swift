//
//  RZCartoonSortHomeViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/27.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import MJRefresh
class RZCartoonSortHomeViewController: RZCartoonBaseViewController {

    var sorListArr = [CartoonHopeModel]()
    lazy var table : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.backgroundColor = UIColor.bg_color
        table.delegate = self
        table.dataSource = self
        table.register(RZCartoonSortListTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonSortListTableViewCell")
        table.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getSortListFromSever()
        })
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSortListFromSever()
        
    }
    
    override func initUI() {
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func getSortListFromSever() {
        
        RZCartoonHomePageVM().getSortList { (code, msg, json) in
            self.table.mj_header.endRefreshing()
            if code == 1 {
                let model = json as! CartoonHopeBaseModel
                self.sorListArr = model.rankinglist ?? []
                for item in self.sorListArr {
                    item.itemHeight = 0.4 * kScreenWidth
                
                }
                self.table.reloadData()
                
            } else {
                
            }
        }
    }
}


extension RZCartoonSortHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sorListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonSortListTableViewCell", for: indexPath) as! RZCartoonSortListTableViewCell
        let model = self.sorListArr[indexPath.row]
        cell.model = model
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.sorListArr[indexPath.row]
        return model.itemHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.sorListArr[indexPath.row]
        let vc = RZCartoonCateDetailViewController(model)
        vc.title = model.rankingType
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
