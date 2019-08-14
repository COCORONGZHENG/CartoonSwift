//
//  RZCartoonDetailFirstTableViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/31.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonDetaiContentTableViewCell: RZCartoonBaseTableViewCell {

    private lazy var textView : UITextView = {
        let text = UITextView()
        text.isUserInteractionEnabled = false
        text.textColor = UIColor.gray
        text.font = UIFont.systemFont(ofSize: 15)
        
        return text
    }()
    
   
    override func initUI() {
        let lab = UILabel()
        lab.textColor = .black
        lab.text = "作品介绍"
        lab.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            make.height.equalTo(20)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(-15)
            make.top.equalTo(lab.snp.bottom)
            make.left.equalTo(15)
        }
        
        
    }
    
    var model : CartoonHopeBaseModel? {
        didSet {
            guard let model = model else {
                return
            }
            textView.text = "【\(model.comic?.cate_id ?? "") \(model.comic?.description ?? "")】"
            
        }
    }
    
    // 计算作品介绍高度
    class func height(for detailStatic: CartoonHopeBaseModel?) -> CGFloat {
        var height: CGFloat = 50.0
        guard let model = detailStatic else { return height }
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = "【\(model.comic?.cate_id ?? "")】\(model.comic?.description ?? "")"
        height += textView.sizeThatFits(CGSize(width: kScreenWidth - 30, height: CGFloat.infinity)).height
        return height
    }
    
}

class RZCartoonDetailOtherProductTableViewCell : RZCartoonBaseTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : CartoonHopeBaseModel? {
        didSet {
            guard let model = model else {
                return
            }
            textLabel?.text = "其他作品"
            detailTextLabel?.text = "\(model.otherWorks?.count ?? 0)本"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        }
    }

    
    
}


class RZCartoonDetailRealTimeTableViewCell : RZCartoonBaseTableViewCell {
    
    var model : CartoonComicRealtimeModel? {
        
        didSet {
            guard let model = model else {return}
            let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            text.insert(NSAttributedString(string: "\(model.monthly_ticket ?? "")", attributes: [NSAttributedString.Key.foregroundColor : UIColor.orange,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]), at: 6)
            text.append(NSAttributedString(string: "\(model.total_ticket ?? "")", attributes: [NSAttributedString.Key.foregroundColor : UIColor.orange,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            textLabel?.attributedText = text
            textLabel?.textAlignment = .center
        }
        
    }
    
    
    override func initUI() {
        
    }
    
}

class RZCartoonGuessLikeTableViewCell : RZCartoonBaseTableViewCell {
    
    private var guessLikeArr = [CartoonGuessLikeModel]()
    
    private lazy var collect : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.backgroundColor = .white
        collect.delegate = self
        collect.dataSource = self
        collect.isScrollEnabled = false
        collect.register(RZCartoonHopeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonHopeCollectionViewCell")
        return collect
    }()
    
    override func initUI() {
        contentView.addSubview(collect)
        collect.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    var model : CartoonGuessLikeBaseModel? {
        didSet {
            guard let model = model else {return}
            guessLikeArr = model.comics ?? []
            collect .reloadData()
        }
    }
    
}

extension RZCartoonGuessLikeTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guessLikeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RZCartoonHopeCollectionViewCell", for: indexPath) as! RZCartoonHopeCollectionViewCell
        cell.cellType = .withTitle
        cell.guessLikeModel = guessLikeArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 30) / 4)
        let height = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = guessLikeArr[indexPath.item]
        guard let commicid = Int(model.comic_id ?? "") else {
            return
        }
        let vc = RZCartoonTool.getControllerfromview(view: self)
    vc?.navigationController?.pushViewController(RZCartoonDetailPageViewController(commicID: commicid), animated: true)
        
    }

    
}
