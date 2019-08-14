//
//  RZCartoonSearchHomeViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/27.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonSearchHomeViewController: RZCartoonBaseViewController {

    
    var hotSearchArray = [CartoonSearchHotItemModel]()
    var SearchRelativeArray = [CartoonSearchRelativeItemModel]()
    var searchResultArray = [CartoonCateDetailItemModel]()
    
    lazy var searchHistoryArray : [String] = {
        return UserDefaults.standard.value(forKey: searchHistoryKey) as? [String] ?? [String]()
    }()
    
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 60, height: 30))
        searchBar.showsCancelButton = true  // 取消按钮是否显示
        searchBar.delegate = self
        let btn = searchBar.value(forKey: "cancelButton") as! UIButton
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        searchBar.placeholder = "请输入漫画名称/作者"
        return searchBar
    }()
    
    lazy var historyTable : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.register(RZCartoonBaseTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonBaseTableViewCell")
        table.register(RZCartoonHotSearchTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonHotSearchTableViewCell")
        table.register(RZCartoonSearchHeadView.classForCoder(), forHeaderFooterViewReuseIdentifier: "RZCartoonSearchHeadView")
        return table
    }()

    lazy var searchTable : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.register(RZCartoonBaseTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonSearchRelativeCell")
        return table
    }()
    
    lazy var resultTable : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.register(RZCartoonCateDetailTableViewCell.classForCoder(), forCellReuseIdentifier: "RZCartoonCateDetailTableViewCell")
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHotSearchList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.naviBarStyle(.green)
    }
    
    func getHotSearchList() {
        RZProgressHUD.showHUD()
        searchBar.resignFirstResponder()
        RZCartoonHomePageVM().getSearchHotDetail {[weak self] (code, msg, json) in
            RZProgressHUD.hideHUD()
            if code == 1 {
                let model = json as! CartoonHotSearchModel
                self?.hotSearchArray = model.hotItems ?? []
                self?.historyTable.reloadData()
            } else {
                
            }
            
        }
    }
    
    func getSearchResultByKey(_ targetString : String) {
        searchBar.resignFirstResponder()
        RZCartoonHomePageVM().getSearchKeyResult(["inputText" : targetString]) { (code, msg, json) in
            if code == 1 {
                print(code)
                let model = json as! CartoonSearchRelativeModel
                self.SearchRelativeArray = model.returnData ?? []
                
                self.searchTable.isHidden = false
                self.historyTable.isHidden = true
                self.resultTable.isHidden = true
                self.searchTable.reloadData()
            } else {
                
            }
            
        }
    }
    
    func getSearchResult(_ targetString : String) {
        searchBar.resignFirstResponder()
        RZCartoonHomePageVM().getSearchResult(["argCon" : 0, "q" : targetString]) { (code, msg, json) in
            if code == 1 {
                let model = json as! CartoonCommicsModel
                self.searchResultArray = model.comics ?? []
                self.historyTable.isHidden = true
                self.searchTable.isHidden = true
                self.resultTable.isHidden = false
                self.resultTable.reloadData()
            } else {
                
            }
        }
    }
    
    
    
    override func configNavieBar() {
        super.configNavieBar()
        let titleView = UIView()
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 60, height: 30)
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    

    override func initUI() {
        view.addSubview(historyTable)
        historyTable.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                // Fallback on earlier versions
                make.edges.equalToSuperview()
            }
        }
        
        view.addSubview(searchTable)
        searchTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snap.edges)
        }
        
        view.addSubview(resultTable)
        resultTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snap.edges)
        }
        
        historyTable.tableFooterView = UIView()
        searchTable.tableFooterView = UIView()
        resultTable.tableFooterView = UIView()
        
        historyTable.isHidden = false
        searchTable.isHidden = true
        resultTable.isHidden = true
        
    }
    
    
}

extension RZCartoonSearchHomeViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchData = UserDefaults.standard.value(forKey: searchHistoryKey) as? [String] ?? [String]()
        if searchData.contains(searchBar.text ?? "") {
            guard let index = searchData.firstIndex(of: searchBar.text ?? "") else { return }
            searchData.remove(at: index)
        }
        guard let text = searchBar.text else {
            return
        }
        searchData.insert(text, at: 0)
        UserDefaults.standard.set(searchData, forKey: searchHistoryKey)
        UserDefaults.standard.synchronize()
        self.searchHistoryArray = searchData
        historyTable.reloadData()
        searchBar.resignFirstResponder()
        getSearchResultByKey(text)
        
    }
    
}

extension RZCartoonSearchHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTable {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTable {
            return section == 0 ? self.searchHistoryArray.count : 1
        } else if tableView == searchTable {
            return self.SearchRelativeArray.count
        } else if tableView == resultTable {
            return self.searchResultArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTable {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonBaseTableViewCell", for: indexPath) as! RZCartoonBaseTableViewCell
                cell.textLabel?.text = self.searchHistoryArray[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonHotSearchTableViewCell", for: indexPath) as! RZCartoonHotSearchTableViewCell
                cell.dataArray = self.hotSearchArray as NSArray
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat(MAXFLOAT))
                return cell
            }
            
        } else if (tableView == searchTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonSearchRelativeCell", for: indexPath) as! RZCartoonBaseTableViewCell
            cell.textLabel?.text = self.SearchRelativeArray[indexPath.row].name
            return cell
        } else if tableView == resultTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RZCartoonCateDetailTableViewCell", for: indexPath) as! RZCartoonCateDetailTableViewCell
            cell.model = self.searchResultArray[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == historyTable {
            return indexPath.section == 0 ? 44 : 200
        } else if tableView == resultTable {
            return 180
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTable {
            let model = self.SearchRelativeArray[indexPath.row]
            getSearchResult(model.name ?? "")
        } else if tableView == resultTable {
            let model = self.searchResultArray[indexPath.row]
            self.navigationController?.pushViewController(RZCartoonDetailPageViewController(commicID: model.comicId), animated: true)
            
        } else if tableView == historyTable {
            if indexPath.section == 0 {
                self.getSearchResultByKey(self.searchHistoryArray[indexPath.row])
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == historyTable {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RZCartoonSearchHeadView") as! RZCartoonSearchHeadView
            
            header.descLab.text = section == 0 ? "看看你都搜过什么" : "大家都在搜"
            header.btn.setImage(section == 0 ? UIImage(named: "search_history_delete") : UIImage(named: "search_keyword_refresh"), for: .normal)

            header.cartoonSearchSectionHeadBlock {[weak self] (sender) in
                if section == 0 {
                    self?.searchHistoryArray.removeAll()
                    self?.historyTable.reloadData()
                    UserDefaults.standard.removeObject(forKey: searchHistoryKey)
                    UserDefaults.standard.synchronize()
                } else {
                    self?.getHotSearchList()
                }
            }
            header.backgroundColor = .white
            return header
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        if tableView == historyTable {
            return 44
            
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == historyTable {
            return section == 0 ? 10 : CGFloat.leastNormalMagnitude
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.bg_color
        return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
}
