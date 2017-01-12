//
//  ViewController.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.view.backgroundColor = UIColor.white;
        
        let btn = UIButton(type: .custom);
        btn.setTitle("选择", for: UIControlState.normal);
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        btn.setTitleColor(UIColor.black, for: UIControlState.normal);
        btn.addTarget(self, action: #selector(choose), for: UIControlEvents.touchUpInside);
        let bar = UIBarButtonItem(customView: btn);
        self.navigationItem.leftBarButtonItem = bar;
        
    }
    func choose() {
        let photo = PhotoListViewController();
        let navc = UINavigationController(rootViewController: photo);
        navc.navigationBar.barTintColor = navigatorBgColor;
        self.present(navc, animated: true, completion: nil);
    }
}

