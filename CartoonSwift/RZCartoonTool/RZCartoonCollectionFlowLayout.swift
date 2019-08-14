//
//  RZCartoonCollectionFlowLayout.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/22.
//  Copyright © 2019 rz. All rights reserved.
//

import Foundation
import UIKit
private let SectionBackground = "UCollectionReusableView"

protocol UICollectionViewCartoonLayout : UICollectionViewDelegateFlowLayout {
    func collection(_ collect:UICollectionView,layout collectionLayout : UICollectionViewFlowLayout,bg_colorForSection section : Int) -> UIColor
}
extension UICollectionViewCartoonLayout {
    func collection(_ collect:UICollectionView,layout collectionLayout : UICollectionViewFlowLayout,bg_colorForSection section : Int) -> UIColor {
        return collect.backgroundColor ?? UIColor.clear
    }
}


private class UCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor = UIColor.white
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! UCollectionViewLayoutAttributes
        copy.backgroundColor = self.backgroundColor
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? UCollectionViewLayoutAttributes else {
            return false
        }
        
        if !self.backgroundColor.isEqual(rhs.backgroundColor) {
            return false
        }
        return super.isEqual(object)
    }
}

private class UCollectionReusableView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attr = layoutAttributes as? UCollectionViewLayoutAttributes else {
            return
        }
        
        self.backgroundColor = attr.backgroundColor
    }
}


class RZCartoonCollectionFlowLayout: UICollectionViewFlowLayout {
    
    private var attributeArray = [UICollectionViewLayoutAttributes]()
    
    
    override init() {
        super.init()
        setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
   
    func setUp()  {
        self.register(UICollectionReusableView.classForCoder(), forDecorationViewOfKind:SectionBackground )
    }
    
    override func prepare() {
        super.prepare()
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? UICollectionViewCartoonLayout else {
            return
        }
        self.attributeArray.removeAll()
        for section in 0 ..< numberOfSections {
            let index = IndexPath(item: 0, section: section)
            guard let numberOfRows = collectionView?.numberOfItems(inSection: section),
            numberOfRows > 0,
            let firstItem = layoutAttributesForItem(at: index as IndexPath),
            let lastItem = layoutAttributesForItem(at: IndexPath(item: numberOfRows - 1, section: section)) else {
                    return
            }
            
            var inset = self.sectionInset
            if let insetDelegate = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) {
                inset = insetDelegate
            }
            
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = inset.left
            sectionFrame.origin.y -= inset.top
            
            let headLayout = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: index)
            let footLayout = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: index)
            
            if self.scrollDirection == .horizontal {
                sectionFrame.origin.y -= headLayout?.frame.height ?? 0
                sectionFrame.size.width += inset.left + inset.right
                sectionFrame.size.height = (collectionView?.frame.height ?? 0) + (headLayout?.frame.height ?? 0) + (footLayout?.frame.height ?? 0)
            } else {
                sectionFrame.origin.y -= headLayout?.frame.height ?? 0
                sectionFrame.size.width = collectionView?.frame.width ?? 0
                sectionFrame.size.height = sectionFrame.size.height + inset.top + inset.bottom + (headLayout?.frame.height ?? 0) + (footLayout?.frame.height ?? 0)
            }
            
            let attr = UICollectionViewLayoutAttributes(forDecorationViewOfKind: SectionBackground, with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
//            attr.backgroundColor = delegate.collect(
            
            self.attributeArray.append(attr)
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var atti = super.layoutAttributesForElements(in: rect)
        atti?.append(contentsOf: attributeArray.filter({ (atti) -> Bool in
            return rect.intersects(atti.frame)
        }))
        return atti
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == SectionBackground {
            return attributeArray[indexPath.section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
    
    
}
