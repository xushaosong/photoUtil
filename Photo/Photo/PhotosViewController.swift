//
//  PhotosViewController.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

/// 某个相册图片集



import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var dataArray: Array<Asset> = [];
    var collectionView: UICollectionView?;
    let itemSize: CGSize = CGSize(width: (scWidth - 25) / 4, height: (scWidth - 25) / 4);
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        

        self.view.backgroundColor = UIColor.white;
        
        let btn = UIButton(type: .custom);
        btn.setImage(getImagePath(imageName: "back_white.png"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 40);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        btn.setTitleColor(UIColor.black, for: UIControlState.normal);
        btn.addTarget(self, action: #selector(navigatorback), for: UIControlEvents.touchUpInside);
        let bar = UIBarButtonItem(customView: btn);
        self.navigationItem.leftBarButtonItem = bar;
        
    }
    func navigatorback() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Asset_Notice), object: nil);
        self.navigationController?.popViewController(animated: true);
    }
    
    let originImageView: ShowOriginImageView = ShowOriginImageView();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weak var weakSelf = self;
        
        let collectionView_layout = UICollectionViewFlowLayout();
        collectionView_layout.itemSize = itemSize;
        collectionView_layout.minimumLineSpacing = 5;
        collectionView_layout.minimumInteritemSpacing = 5;
        collectionView_layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        collectionView_layout.footerReferenceSize = CGSize(width: scWidth, height: 20);
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: scWidth, height: getCollectionViewHeight()), collectionViewLayout: collectionView_layout);
        collectionView?.backgroundColor = UIColor.white;
        collectionView?.delegate = weakSelf;
        collectionView?.dataSource = weakSelf;
        
        self.view.addSubview(collectionView!);
        
        if (PhotoUtil.shareInstance.showSelectDetail) {
            self.view.addSubview(PhotoUtil.shareInstance.photoDetailView)
            PhotoUtil.shareInstance.photoDetailView.frame = CGRect(x: 0, y: (collectionView?.frame.maxY)!, width: scWidth, height: photoDetailViewHeight)
            
            let barItem = UIBarButtonItem(customView: originImageView);
            self.navigationItem.rightBarButtonItem = barItem;
            
        } else {
            self.view.addSubview(PhotoUtil.shareInstance.photoOperateView)
            PhotoUtil.shareInstance.photoOperateView.frame = CGRect(x: 0, y: (collectionView?.frame.maxY)!, width: scWidth, height: photoOperateViewHeight)
        }
        
        collectionView?.register(AssetItemCell.self, forCellWithReuseIdentifier: "colleciton");
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notice:)), name: NSNotification.Name(rawValue: Asset_Notice), object: nil);
    }
    func updateData(notice: NSNotification) {
        let obj_asset = notice.userInfo?["data"] as! Asset;
        for (index, asset) in dataArray.enumerated() {
            if (obj_asset.asset?.localIdentifier == asset.asset?.localIdentifier) {
                collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)]);
                break;
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: AssetItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colleciton", for: indexPath) as! AssetItemCell;
        item.asset = dataArray[indexPath.item];
        item.controlActionCall = {(asset) in
            PhotoUtil.actionAsset(asset: asset);
        };
        return item;
    }
    
    
    func getCollectionViewHeight() -> CGFloat {
        return PhotoUtil.shareInstance.showSelectDetail ? self.view.frame.size.height - photoDetailViewHeight : self.view.frame.size.height - photoOperateViewHeight;
    }
}
