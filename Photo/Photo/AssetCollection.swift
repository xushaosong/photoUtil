//
//  AssetCollection.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit
import Photos
class AssetCollection: NSObject {
    var assetCollection: PHAssetCollection?
    var assets: Array<Asset>?;
    
    class func create(collection: PHAssetCollection) -> AssetCollection {
        let assetCollection: AssetCollection = AssetCollection();
        assetCollection.assetCollection = collection;
        
        let queue: DispatchQueue = DispatchQueue(label: "queue");
        assetCollection.assets = PhotoUtil.getCollectionsAsset(collection: collection);
        return assetCollection
    }
    
}
