//
//  Asset.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit
import Photos
class Asset: NSObject {

    var isSelected: Bool = false;
    var asset: PHAsset?
    var highQualityImageData: Data?
    
    class func create(asset: PHAsset) -> Asset {
        let a = Asset();
        a.asset = asset;
        return a;
    }
    
}
