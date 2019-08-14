//
//  RZCartoonPageControlViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/22.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import HMSegmentedControl
enum RZCartoonPageControlType {
    case none
    case naviSegument
    case buttonSegument
}

class RZCartoonPageControlViewController: RZCartoonBaseViewController {

    var titleArr : [String]!
    var subVCs : [UIViewController]!
    var controltype : RZCartoonPageControlType!
    var currentSeleIndex : Int = 0
    
    lazy var segument : HMSegmentedControl = {
        let segument = HMSegmentedControl()
        segument.addTarget(self, action: #selector(segumentValueChange(_:)), for: .valueChanged)
        return segument
    }()
    
    lazy var  pageVC : UIPageViewController = {
        
       return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    
    convenience init(_ titles : [String],_ subVCs : [UIViewController] = [],_ pageControlType : RZCartoonPageControlType = .none) {
        self.init()
        self.titleArr = titles
        self.subVCs = subVCs
        self.controltype = pageControlType
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initUI() {
        guard let vcs = subVCs else {return}
        
        addChild(pageVC)
        pageVC.delegate = self
        pageVC.dataSource = self
        view.addSubview(pageVC.view)
        pageVC.setViewControllers([vcs[0]], direction: .forward, animated: true) { (complete) in
        }
        
        switch self.controltype {
        case .none:
            pageVC.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            
            break
        case .naviSegument?:
            segument.backgroundColor = UIColor.clear
            segument.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5),NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
            segument.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)]
            segument.selectionIndicatorLocation = .none
            navigationItem.titleView = segument
            segument.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: 40)
            pageVC.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            break
        case .buttonSegument?:
            segument.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
            segument.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(r: 127, g: 221, b: 146,a: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
            segument.selectionIndicatorLocation = .down
            segument.selectionIndicatorColor = UIColor(r: 127, g: 221, b: 146,a: 1.0)
            segument.selectionIndicatorHeight = 2
            segument.borderType = .bottom
            segument.borderColor = UIColor.lightGray
            segument.borderWidth = 0.5
            view.addSubview(segument)
            segument.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(40)
            }
            pageVC.view.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(segument.snp.bottom)
            }
            
            break
            
        default:
            
            break
        }
        
        guard let titlesArray = titleArr else {
            return
        }
        segument.sectionTitles = titlesArray
        currentSeleIndex = 0
        segument.selectedSegmentIndex = currentSeleIndex
        
    }
    
    @objc func segumentValueChange(_  segument : HMSegmentedControl) {
        let index = segument.selectedSegmentIndex
        if index != currentSeleIndex {
            let direction : UIPageViewController.NavigationDirection = index > currentSeleIndex ? .forward : .reverse
            pageVC.setViewControllers([subVCs[index]], direction: direction, animated: true) { (complete) in
                self.currentSeleIndex = index
            }
            
            
        }
        
    }

}

extension RZCartoonPageControlViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = subVCs.firstIndex(of: viewController)  else {
            return nil
        }
        let beforeIndex = index - 1
        guard beforeIndex >= 0 else {return nil}
        return subVCs[beforeIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = subVCs.firstIndex(of: viewController) else {
            return nil
        }
        let afterIndex = index + 1
        guard afterIndex <= subVCs.count - 1 else {
            return nil
        }
        return subVCs[afterIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?.last else {
            return
        }
        guard let index = subVCs.firstIndex(of: vc) else {
            return
        }
        
        segument.setSelectedSegmentIndex(UInt(index), animated: true)
        currentSeleIndex = index
        guard titleArr != nil && controltype == .none else {
            return
        }
        navigationItem.title = titleArr[index]
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

