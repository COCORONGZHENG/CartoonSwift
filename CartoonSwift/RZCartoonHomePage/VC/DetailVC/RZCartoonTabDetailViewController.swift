//
//  RZCartoonTabDetailViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/30.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

protocol RZCartoonScrollViewGestureDelegate : NSObject {
    
    func subViewControllerScrollViewDidScroll(_ scrollView : UIScrollView)
    
}

class RZCartoonTabDetailViewController: RZCartoonBaseViewController {

    weak var delegate : RZCartoonScrollViewGestureDelegate?
    var baseModel : CartoonHopeBaseModel?
    var realTimeModel : CartoonComicRealtimeModel? 
    var guessLikeModel : CartoonGuessLikeBaseModel?
    
    private lazy var table : UITableView = {
        let table  = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.bg_color
        table.register(RZCartoonDetaiContentTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonDetaiContentTableViewCell")
        table.register(RZCartoonDetailOtherProductTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonDetailOtherProductTableViewCell")
        table.register(RZCartoonDetailRealTimeTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonDetailRealTimeTableViewCell")
        table.register(RZCartoonGuessLikeTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonGuessLikeTableViewCell")
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
    
    func reloadTableView() {
        table.reloadData()
    }

}


extension RZCartoonTabDetailViewController : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return baseModel != nil ? 4 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1 && baseModel?.otherWorks?.count == 0) ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonDetaiContentTableViewCell", for: indexPath) as! RZCartoonDetaiContentTableViewCell
            cell.model = baseModel
            return cell
        } else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonDetailOtherProductTableViewCell", for: indexPath) as! RZCartoonDetailOtherProductTableViewCell
            cell.model = baseModel
            return cell
        } else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonDetailRealTimeTableViewCell", for: indexPath) as! RZCartoonDetailRealTimeTableViewCell
            cell.model = realTimeModel
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonGuessLikeTableViewCell", for: indexPath) as! RZCartoonGuessLikeTableViewCell
            cell.model = guessLikeModel
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return RZCartoonDetaiContentTableViewCell.height(for: baseModel)
        } else if indexPath.section == 3{
            return 200
        } else {
            return 44
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1 && baseModel?.otherWorks?.count == 0) ? CGFloat.leastNormalMagnitude : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView()
        foot.backgroundColor = UIColor.bg_color
        return foot
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == table {
            guard let delegate = delegate else {return}
            delegate.subViewControllerScrollViewDidScroll(scrollView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 { navigationController?.pushViewController(RZCartoonOtherProductViewController(baseModel?.otherWorks ?? []), animated: true)
        }
    }
    
}
