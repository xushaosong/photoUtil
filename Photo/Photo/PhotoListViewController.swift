//
//  PhotoViewController.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//



import UIKit

import Photos

/// 相册列表
class PhotoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain);
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationItem.titleView = setNavigationTitle(title: "相册列表", color: nil);
        self.view.backgroundColor = UIColor.white;
        
        let btn = UIButton(type: .custom);
        btn.setTitle(kFetchParams(key: "PhotoViewController_dismiss"), for: UIControlState.normal);
        let size = getString(stringName: kFetchParams(key: "PhotoViewController_dismiss") as NSString, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: 1000, height: 40));
        
        btn.frame = CGRect(x: 0, y: 0, width: size.width, height: 40);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        btn.setTitleColor(UIColor.black, for: UIControlState.normal);
        btn.addTarget(self, action: #selector(dismissVC), for: UIControlEvents.touchUpInside);
        let bar = UIBarButtonItem(customView: btn);
        self.navigationItem.rightBarButtonItem = bar;
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView);
        tableView.frame = CGRect(x: 0, y: 0, width: scWidth, height: self.view.frame.size.height);
        tableView.tableFooterView = UIView();
        weak var weakSelf = self;
        tableView.delegate = weakSelf;
        tableView.dataSource = weakSelf;
        tableView.register(CollectionCell.self, forCellReuseIdentifier: "collection_cell")
        tableView.reloadData();
        
        detail(index: 0, animate: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotoUtil.shareInstance.groupLibrarys.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollectionCell = tableView.dequeueReusableCell(withIdentifier: "collection_cell") as! CollectionCell;
        cell.assetCollection = PhotoUtil.shareInstance.groupLibrarys[indexPath.row];
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        if (PhotoUtil.shareInstance.groupLibrarys[indexPath.row].assets?.count != 0) {
            detail(index: indexPath.row, animate: true)
        }
        
    }
    
    func detail(index: Int, animate: Bool) {
        let detail = PhotosViewController();
        
        let group: AssetCollection = PhotoUtil.shareInstance.groupLibrarys[index];
        
        detail.dataArray = group.assets!;
        detail.navigationItem.titleView = setNavigationTitle(title: group.assetCollection?.localizedTitle as! NSString, color: nil)
        self.navigationController?.pushViewController(detail, animated: animate);
    }
    
    func dismissVC() {
        self.navigationController?.dismiss(animated: true, completion: nil);
    }
}
