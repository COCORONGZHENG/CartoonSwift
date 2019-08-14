//
//  RZCartoonCommentListViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/30.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonCommentListViewController: RZCartoonBaseViewController {
    weak var delegate : RZCartoonScrollViewGestureDelegate?
    var commetList = [CartoonCommentModel]()
    var commentModel : CartoonCommentBaseModel?
    lazy var table : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        table.register(RZCartoonCommentTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonCommentTableViewCell")
        table.tableFooterView = UIView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func initUI() {
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func reloadData() {
        commetList = commentModel?.commentList ?? []
        table.reloadData()
    }
    

}


extension RZCartoonCommentListViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "RZCartoonCommentTableViewCell", for: indexPath) as! RZCartoonCommentTableViewCell
        cell.model = self.commetList[indexPath.row]
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return RZCartoonTool.isIPhoneX() ? 34 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView()
        foot.backgroundColor = UIColor.white
        return foot
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == table {
            guard let delegate = delegate else {return}
            delegate.subViewControllerScrollViewDidScroll(scrollView)
        }
    }
    
    
}
