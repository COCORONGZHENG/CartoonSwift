//
//  RZCartoonChapterDetailCollecCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/7.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import RxSwift

class RZCartoonChapterDetailCollecCell: RZCartoonBaseCollectionViewCell {
    lazy var iconView : UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()
    
    override func setUpUI() {
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    var model : CartoonChapterImageModel? {
        didSet {
            guard let model = model else {
                return
            }
            iconView.kf.setImage(with: URL(string: model.location ?? ""),placeholder:UIImage(named: "yaofan"))
        }
    }
}


class RZCartoonChapterHeader: RZCartoonBaseView {
    lazy var backButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav_back_black"), for: .normal)
        _ = btn.rx.tap.subscribe({ (event) in
          let vc = RZCartoonTool.getControllerfromview(view: self)
            vc?.navigationController?.popViewController(animated: true)
        })
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        return titleLabel
    }()
    
    override func initUI() {
        self.backgroundColor = .white
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.left.bottom.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        }
    }
    
}


enum CartoonChapterFootAction : Int {
    case deviceDirection = 0
    case lighting = 1
    case chapterList = 2
}

typealias CartoonChapterActionBlock = (_ btn : UIButton?) -> Void

class RZCartoonChapterFooter: RZCartoonBaseView {
    
    var chapterBlock : CartoonChapterActionBlock?
    
    lazy var menuSlider: UISlider = {
        let menuSlider = UISlider()
        menuSlider.value = Float(UIScreen.main.brightness)
        menuSlider.thumbTintColor = UIColor.mainGreen
        menuSlider.minimumTrackTintColor = UIColor.mainGreen
        menuSlider.isContinuous = false
        _ = menuSlider.rx.value.subscribe({ (value) in
            UIScreen.main.brightness = CGFloat(menuSlider.value)
        })
        return menuSlider
    }()
    
    lazy var deviceDirectionButton: UIButton = {
        let deviceDirectionButton = UIButton(type: .custom)
        deviceDirectionButton.tag = CartoonChapterFootAction.deviceDirection.rawValue
        deviceDirectionButton.setImage(UIImage(named: "readerMenu_changeScreen_horizontal"), for: .normal)
        deviceDirectionButton.setImage(UIImage(named: "readerMenu_changeScreen_vertical"), for: .selected)
        _ = deviceDirectionButton.rx.tap.subscribe({ (event) in
            guard let block = self.chapterBlock else {return}
            deviceDirectionButton.isSelected = !deviceDirectionButton.isSelected
            block(deviceDirectionButton)
        })
        
        return deviceDirectionButton
    }()
    
    lazy var lightButton: UIButton = {
        let lightButton = UIButton(type: .system)
        lightButton.tag = CartoonChapterFootAction.lighting.rawValue
        _ = lightButton.rx.tap.subscribe({ (event) in
            guard let block = self.chapterBlock else {return}
            block(lightButton)
        })
        lightButton.setImage(UIImage(named: "readerMenu_luminance")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return lightButton
    }()
    
    lazy var chapterButton: UIButton = {
        let chapterButton = UIButton(type: .system)
        chapterButton.tag = CartoonChapterFootAction.chapterList.rawValue
        _ = chapterButton.rx.tap.subscribe({ (event) in
            guard let block = self.chapterBlock else {return}
            block(chapterButton)
        })
        chapterButton.setImage(UIImage(named: "readerMenu_catalog")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return chapterButton
    }()
    
    
    func CartoonChapterActionBlock(_ block : CartoonChapterActionBlock?) {
        self.chapterBlock = block
        
    }
    
    override func initUI() {
        self.backgroundColor = .white
        addSubview(menuSlider)
        menuSlider.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40))
            make.height.equalTo(30)
            
        }
        
        addSubview(deviceDirectionButton)
        addSubview(lightButton)
        addSubview(chapterButton)
        
        deviceDirectionButton.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.centerY.equalToSuperview().offset(15)
            make.width.equalTo(60)
            
        }
        
        chapterButton.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.centerY.equalToSuperview().offset(15)
            make.width.equalTo(60)
        }
        
        lightButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.centerY.equalToSuperview().offset(15)
        }
    }
    
}
