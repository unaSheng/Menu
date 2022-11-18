//
//  MenuListView.swift
//  CustomMenuList
//
//  Created by 李文秀 on 2022/11/17.
//

import UIKit

class MenuListView: UIView {
    
    struct Item {
        var title: String
        var image: UIImage?
        var handler: ((Item) -> Void)
    }
    
    class ItemView: UIView {
        
        var didSelectedHandler: ((Item) -> Void)?
        
        private let titleLabel = UILabel()
        private let imageView = UIImageView()
        private var item: Item?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupSubviews()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupSubviews()
        }
        
        func updateUI(item: Item) {
            self.item = item
            titleLabel.text = item.title
            imageView.image = item.image
        }
        
        @objc func tapOnSelf() {
            guard let item = self.item else { return }
            didSelectedHandler?(item)
            item.handler(item)
        }
        
        private func setupSubviews() {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnSelf)))
            
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            titleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
            
            let spacer = UIView()
            spacer.backgroundColor = .clear
            
            let stackView = UIStackView(arrangedSubviews: [titleLabel, spacer, imageView])
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.axis = .horizontal
            addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                stackView.topAnchor.constraint(equalTo: self.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 24),
                imageView.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
    }
    
    private let containerView = UIView()
    private let sourceView: UIView
    private let list: [Item]
    private var itemViewList: [ItemView] = []
    
    private var maxHeight: CGFloat = 0
    private let containerViewWidth: CGFloat = 166
    private let itemViewMargin: CGFloat = 16
    private let itemViewHeight: CGFloat = 55
    private let lineViewHeight: CGFloat = 0.5
    
    init(list: [Item], sourceView: UIView) {
        self.list = list
        self.sourceView = sourceView
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        guard let keyWindow = (UIApplication.shared.windows.first { $0.isKeyWindow }) else { return }
        let margin: CGFloat = 50
        let sourceViewFrame = sourceView.convert(sourceView.bounds, to: keyWindow)
        let originFrame = containerView.frame
        var endFrame: CGRect = originFrame
        let startTranslationX: CGFloat
        var startTranslationY: CGFloat
        if keyWindow.bounds.height - sourceViewFrame.maxY - maxHeight < margin {
            endFrame.origin.y = sourceViewFrame.minY - maxHeight
            startTranslationY = endFrame.height / 2.0
        } else {
            endFrame.origin.y = sourceViewFrame.maxY
            startTranslationY = -endFrame.height / 2.0
        }
        if sourceViewFrame.maxX < containerViewWidth {
            endFrame.origin.x = sourceViewFrame.minX
            startTranslationX = -endFrame.width / 2.0
        } else {
            endFrame.origin.x = sourceViewFrame.maxX - containerViewWidth
            startTranslationX = endFrame.width / 2.0
        }
        let offsetX = endFrame.origin.x - originFrame.origin.x
        let offsetY = endFrame.origin.y - originFrame.origin.y
        let finalTransfrom = containerView.transform.translatedBy(x: offsetX, y: offsetY)
        let startTransfrom = finalTransfrom.scaledBy(x: 0.5, y: 0.5).translatedBy(x: startTranslationX, y: startTranslationY)
        containerView.transform = startTransfrom
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.containerView.transform = finalTransfrom
            self.containerView.alpha = 1
        })
    }
    
    @objc private func tapOnSelf() {
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.containerView.alpha = 0
            self.sourceView.alpha = 1
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    private func setupSubviews() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnSelf)))
        
        containerView.alpha = 0
        containerView.frame = CGRect(origin: .zero, size: CGSize(width: containerViewWidth, height: 300))
        containerView.backgroundColor = UIColor.secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        let itemViewWidth = containerViewWidth - itemViewMargin * 2
        for (index, item) in list.enumerated() {
            let itemView = ItemView()
            itemView.didSelectedHandler = { [weak self] item in
                self?.tapOnSelf()
            }
            itemView.updateUI(item: item)
            containerView.addSubview(itemView)
            let originY = (itemViewHeight + lineViewHeight) * CGFloat(index)
            itemView.frame = CGRect(x: itemViewMargin, y: originY, width: itemViewWidth, height: itemViewHeight)
            maxHeight = itemView.frame.maxY
            if index != list.count - 1 {
                let lineView = UIView()
                lineView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
                containerView.addSubview(lineView)
                lineView.frame = CGRect(x: itemViewMargin, y: itemView.frame.maxY, width: itemViewWidth, height: 0.5)
            }
        }
        let size = CGSize(width: containerViewWidth, height: maxHeight)
        containerView.frame.size = size
    }
    
}

extension MenuListView {
    static func show(_ list: [Item], at sourceView: UIView) {
        guard let keyWindow = (UIApplication.shared.windows.first { $0.isKeyWindow }) else { return }
        sourceView.alpha = 0.5
        let menuListView = MenuListView(list: list, sourceView: sourceView)
        menuListView.frame = keyWindow.bounds
        keyWindow.addSubview(menuListView)
        menuListView.updateUI()
    }
}
