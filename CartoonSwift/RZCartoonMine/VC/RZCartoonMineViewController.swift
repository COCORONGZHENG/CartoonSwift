//
//  RZCartoonMineViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/19.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonMineViewController: RZCartoonBaseViewController {

    lazy var titleArray : NSArray = {
        return [["我的VIP","充值妖气币"],["消费记录","我的订阅","我的封印图"],["我的消息/优惠券","妖果商城","在线阅读免流量"],["帮助中心","我要反馈","给我们评分","成为作者","设置"]]
    }()
    
    lazy var iconArray : NSArray = {
        return [["mine_vip","mine_coin"],["mine_accout","mine_subscript","mine_seal"],["mine_message","mine_cashew","mine_freed"],["mine_feedBack","mine_mail","mine_judge","mine_author","mine_setting"]]
    }()
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    lazy var table : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(RZCartoonBaseTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonMineTableViewCell")
        table.backgroundColor = UIColor.bg_color
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.naviBarStyle(.clear)
    }
    
    override func initUI() {
        let head = RZCartoonMineHeadView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 200))
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            
        if #available(iOS 11.0, *) {
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            make.top.equalToSuperview()
        } else {
            make.edges.equalToSuperview()
        }
        }
        table.tableFooterView = UIView()
        table.parallaxHeader.view = head
        table.parallaxHeader.height = 200
        table.parallaxHeader.minimumHeight = navigationBarY
        table.parallaxHeader.mode = .fill
        
    }
    

}


extension RZCartoonMineViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr =  self.titleArray[section] as! NSArray
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "RZCartoonMineTableViewCell", for: indexPath) as! RZCartoonBaseTableViewCell
        let titleArr = self.titleArray[indexPath.section] as! NSArray
        let iconArr = self.iconArray[indexPath.section] as! NSArray
        cell.imageView?.image = UIImage(named: iconArr[indexPath.row] as! String)
        cell.textLabel?.text = titleArr[indexPath.row] as? String
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RZProgressHUD.tost("暂未实现")
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.bg_color
        return view
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == table {
            navigationItem.title = scrollView.contentOffset.y > -140 ? "我的" : ""
            if  scrollView.contentOffset.y > -140 {
                navigationController?.naviBarStyle(.green)
            } else {
                navigationController?.naviBarStyle(.clear)
            }
        }
        
        
    }
    
    
    
}
