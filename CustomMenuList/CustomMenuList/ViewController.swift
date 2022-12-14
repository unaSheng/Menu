//
//  ViewController.swift
//  CustomMenuList
//
//  Created by 李文秀 on 2022/11/17.
//

import UIKit

class ViewController: UIViewController {
    
    private let items: [MenuListView.Item] = [
        MenuListView.Item(title: "选择一", image: UIImage(named: "camera_checked"), handler: {_ in}),
        MenuListView.Item(title: "选择二", image: UIImage(named: "camera_unchecked"), handler: {_ in}),
        MenuListView.Item(title: "选择三", image: UIImage(named: "camera_unchecked"), handler: {_ in}),
        MenuListView.Item(title: "选择四", image: UIImage(named: "camera_unchecked"), handler: {_ in}),
        MenuListView.Item(title: "选择五", image: UIImage(named: "camera_unchecked"), handler: {_ in}),
    ]
    
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var testButton: CustomizedButton!
    @IBOutlet weak var testButton2: CustomizedButton!
    @IBOutlet weak var testButton3: CustomizedButton!
    @IBOutlet weak var testButton4: CustomizedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        testButton.updateUI(spacing: 5, style: .imageTextAtHorizontal)
        testButton2.updateUI(spacing: 5, style: .textImageAtHorizontal)
        testButton3.updateUI(spacing: 5, style: .imageTextAtVertical)
        testButton4.updateUI(spacing: 5, style: .textImageAtVertical)
    }
    
    @IBAction func topLeft(_ btn: UIButton) {
        MenuListView.show(items, at: btn)
    }
    
    @IBAction func topRight(_ btn: UIButton) {
        MenuListView.show(items, at: btn)
    }
    
    @IBAction func bottomLeft(_ btn: UIButton) {
        MenuListView.show(items, at: btn)
    }
    
    @IBAction func bottomRight(_ btn: UIButton) {
        MenuListView.show(items, at: btn)
    }
}

