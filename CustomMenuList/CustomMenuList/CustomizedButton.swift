//
//  CustomizedButton.swift
//  CustomMenuList
//
//  Created by 李文秀 on 2022/11/18.
//

import UIKit

class CustomizedButton: UIButton {
    
    enum Style: Int {
        case imageTextAtHorizontal
        case textImageAtHorizontal
        case imageTextAtVertical
        case textImageAtVertical
    }
    
    func updateUI(spacing: CGFloat = 0, style: Style = .imageTextAtHorizontal) {
        setNeedsLayout()
        layoutIfNeeded()
        
        let titleSize = calculateTitleSize()
        let imageSize = calculateImageSize()
        let originSize = self.bounds.size
        let width = max(titleSize.width, imageSize.width)
        let height = titleSize.height + imageSize.height + spacing
        let contentMarginH = min(0, width - originSize.width)
        let contentMarginV = max(0, height - originSize.height)
        switch style {
        case .imageTextAtHorizontal:
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing * 2, bottom: 0, right: 0)
        case .textImageAtHorizontal:
            self.semanticContentAttribute = .forceRightToLeft
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing * 2, bottom: 0, right: 0)
        case .imageTextAtVertical:
            self.contentEdgeInsets = UIEdgeInsets(top: contentMarginV,
                                                  left: contentMarginH,
                                                  bottom: 0,
                                                  right: 0)
            if titleSize.width > imageSize.width {
                self.imageEdgeInsets = UIEdgeInsets(top: 2 * (imageSize.height - height),
                                                    left: 0,
                                                    bottom: 0,
                                                    right: -(titleSize.width + imageSize.width))
            } else {
                self.imageEdgeInsets = UIEdgeInsets(top:  2 * (imageSize.height - height),
                                                    left: titleSize.width,
                                                    bottom: 0,
                                                    right: 0)
                self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: titleSize.width - width
                                                    , bottom: 0,
                                                    right: 0)
            }
        case .textImageAtVertical:
            self.contentEdgeInsets = UIEdgeInsets(top: contentMarginV,
                                                  left: contentMarginH,
                                                  bottom: 0,
                                                  right: 0)
            if titleSize.width > imageSize.width {
                self.titleEdgeInsets = UIEdgeInsets(top: 2 * (titleSize.height - height),
                                                    left: 2 * (titleSize.width - width),
                                                    bottom: 0,
                                                    right: 0)
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: -(titleSize.width + imageSize.width))
            } else {
                self.titleEdgeInsets = UIEdgeInsets(top: 2 * (titleSize.height - height),
                                                    left: (titleSize.width - width),
                                                    bottom: 0,
                                                    right: 0)
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: titleSize.width,
                                                    bottom: 0, right: 0)
            }
        }
    }
    
    private func calculateTitleSize() -> CGSize {
        guard let titleLabel = self.titleLabel else { return .zero }
        titleLabel.sizeToFit()
        let size = titleLabel.bounds.size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    private func calculateImageSize() -> CGSize {
        guard let imageView = self.imageView, let image = imageView.image else { return .zero }
        return image.size
    }
}
