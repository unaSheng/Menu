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
        contentEdgeInsets = .zero
        imageEdgeInsets = .zero
        titleEdgeInsets = .zero
        
        setNeedsLayout()
        layoutIfNeeded()
        
        switch style {
        case .imageTextAtHorizontal:
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
        case .textImageAtHorizontal:
            self.semanticContentAttribute = .forceRightToLeft
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
        case .imageTextAtVertical, .textImageAtVertical:
            let titleSize = calculateTitleSize()
            let imageSize = calculateImageSize()
            let originSize = self.bounds.size
            let width = max(titleSize.width, imageSize.width)
            let height = titleSize.height + imageSize.height + spacing
            let contentMarginH = width - originSize.width
            let contentMarginV = height - originSize.height
            let contentVerticalInset = contentMarginV / 2.0
            let contentHorizontalInset = contentMarginH / 2.0
            let verticalOffset = titleSize.height - imageSize.height
            let imageVerticalInset = (imageSize.height + spacing + verticalOffset) / 2.0
            let imageHorizontalInset = titleSize.width / 2.0
            let titleVerticalInset = (titleSize.height + spacing - verticalOffset) / 2.0
            let titleHorizontalInset = imageSize.width / 2.0
            
            let multiply: CGFloat = style == .imageTextAtVertical ? -1 : 1
            self.contentEdgeInsets = UIEdgeInsets(top: contentVerticalInset,
                                                  left: contentHorizontalInset,
                                                  bottom: contentVerticalInset,
                                                  right: contentHorizontalInset)
            self.imageEdgeInsets = UIEdgeInsets(top: imageVerticalInset * multiply,
                                                left: imageHorizontalInset,
                                                bottom: imageVerticalInset * -multiply,
                                                right: -imageHorizontalInset)
            self.titleEdgeInsets = UIEdgeInsets(top: titleVerticalInset * -multiply,
                                                left: -titleHorizontalInset,
                                                bottom: titleVerticalInset * multiply,
                                                right: titleHorizontalInset)
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
