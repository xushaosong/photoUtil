//
//  ChoosePhotosDetailView.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class ChoosePhotosDetailView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView?;
    
    let sendBtn: UIButton = UIButton(type: UIButtonType.custom);

    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1);
        let flow = UICollectionViewFlowLayout();
        flow.itemSize = CGSize(width: photoDetailViewHeight, height: photoDetailViewHeight - 10);
        flow.scrollDirection = .horizontal;
        flow.minimumLineSpacing = 5;
        flow.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0);
        weak var weakSelf = self;
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow);
        collectionView?.backgroundColor = UIColor.clear;
        collectionView?.delegate = weakSelf;
        collectionView?.dataSource = weakSelf;
        collectionView?.register(AssetItemCell.self, forCellWithReuseIdentifier: "cell")
        
        self.sendBtn.setTitle("发送", for: UIControlState.normal);
        self.sendBtn.setTitleColor(UIColor.white, for: UIControlState.normal);
        self.sendBtn.titleLabel?.numberOfLines = 0;
        self.sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        self.sendBtn.layer.masksToBounds = true;
        self.sendBtn.layer.cornerRadius = 4;
        self.sendBtn.backgroundColor = UIColor(red: 52/255.0, green: 182/255.0, blue: 232/255.0, alpha: 1);
        
        self.addSubview(collectionView!);
        self.addSubview(sendBtn);
        
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false;
        self.sendBtn.translatesAutoresizingMaskIntoConstraints = false;
        
        let leftCol = NSLayoutConstraint(item: self.collectionView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0);
        let topCol = NSLayoutConstraint(item: self.collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0);
        let bottomCol = NSLayoutConstraint(item: self.collectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        leftCol.isActive = true;
        topCol.isActive = true;
        bottomCol.isActive = true;
        
        let leftSend = NSLayoutConstraint(item: self.sendBtn, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.collectionView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 5);
        let rightSend = NSLayoutConstraint(item: self.sendBtn, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -5);
        let centerYSend = NSLayoutConstraint(item: self.sendBtn, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        let heightSend = NSLayoutConstraint(item: self.sendBtn, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 40);
        let widthSend = NSLayoutConstraint(item: self.sendBtn, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 80);
        leftSend.isActive = true;
        rightSend.isActive = true;
        centerYSend.isActive = true;
        heightSend.isActive = true;
        widthSend.isActive = true;
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notice:)), name: NSNotification.Name(rawValue: Asset_Notice), object: nil);
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoUtil.shareInstance.selectedAssets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AssetItemCell;
        cell.asset = PhotoUtil.shareInstance.selectedAssets[indexPath.row];
        cell.showDetailCell = true;
        cell.controlActionCall = {(asset) in
            PhotoUtil.actionAsset(asset: asset)
        };
        return cell;
    }
    
    func updateData(notice: NSNotification) {
//        let obj_asset = notice.userInfo?["data"] as! Asset;
//        for (index, asset) in PhotoUtil.shareInstance.selectedAssets.enumerated() {
//            if (obj_asset.asset?.localIdentifier == asset.asset?.localIdentifier) {
//                collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)]);
//                break;
//            }
//        }
        if (PhotoUtil.shareInstance.selectedAssets.count == 0) {
            self.sendBtn.setTitle("发送", for: UIControlState.normal);
        } else {
            self.sendBtn.setTitle("发送(\(PhotoUtil.shareInstance.selectedAssets.count))", for: UIControlState.normal);
        }
        collectionView?.reloadData();
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        context?.move(to: CGPoint(x: 0, y: 0));
        context?.addLine(to: CGPoint(x: scWidth, y: 0));
        context?.setLineWidth(1);
        context?.setStrokeColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        context?.strokePath();
    }
}
