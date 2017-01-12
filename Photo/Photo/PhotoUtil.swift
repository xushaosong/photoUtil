//
//  ToolModel.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//


//http://www.jianshu.com/p/42e5d2f75452

enum AssetType {
    case Custom(CGSize, PHImageRequestOptionsDeliveryMode, PHImageRequestOptionsResizeMode) // 自定义
    case CustomSize(CGSize) // 大小固定的默认图片
    case HignQuality
}

import UIKit

import Photos
class PhotoUtil: NSObject {

    static let shareInstance: PhotoUtil = PhotoUtil();

    var photoDetailView: ChoosePhotosDetailView = ChoosePhotosDetailView()
    var photoOperateView: ChoosePhotosOperateView = ChoosePhotosOperateView();
    
    var showSelectDetail: Bool = true;
    var chooseCountEnable: Int = 10;
    var groupLibrarys: Array<AssetCollection>!;
    var selectedAssets: Array<Asset> = [];
    var isSelectOriginImage: Bool = false;
    
    private var cacheAssetSize: Array<NSValue> = []
    private override init(){
        super.init();
        groupLibrarys = PhotoUtil.getLibraryList();
    }
    
    class func getSelectedAssetSize(complete: @escaping (String) -> ()) {
        
        var byte: Int = 0;
        var count: Int = 0;
        
        if (PhotoUtil.shareInstance.selectedAssets.count == 0) {
            complete("");
            return;
        }
        
        let returnSize = {(byte: Int, complete: (String) -> ()) in
            if (byte > 1024 * 1024) {
                let size: CGFloat = CGFloat(byte) / 1024.0 / 1024.0;
                
                complete(String(format: "%.1fMB", size));
            } else if (byte > 1024) {
                let size: CGFloat = CGFloat(byte) / 1024.0;
                complete(String(format: "%.1fKB", size));
            } else {
                complete("\(byte)B");
            }
        };
        
        
        for asset in PhotoUtil.shareInstance.selectedAssets {
            PhotoUtil.getAssetSize(asset: asset, complete: { (data: Data?) in
                if (data == nil) {
                    
                } else {
                    byte += (data?.count)!;
                }
                count += 1;
                if (count == PhotoUtil.shareInstance.selectedAssets.count) {
                    returnSize(byte, complete);
                }
            })
        }
    }
    
    class func actionAsset(asset: Asset) {
        // 此处的asset.isSelected是当前状态
        if (asset.isSelected) {
            deleteSelectedItem(del_asset: asset)
        } else {
            addSelecteItem(asset: asset);
        }
    }
    
    class func addSelecteItem(asset: Asset) {
        asset.isSelected = true;
        PhotoUtil.shareInstance.selectedAssets.append(asset);
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Asset_Notice), object: nil, userInfo: ["data" : asset])
        
    }
    class func deleteSelectedItem(del_asset: Asset) {
        del_asset.isSelected = false;
        for (index, asset) in PhotoUtil.shareInstance.selectedAssets.enumerated() {
            if (asset.asset?.localIdentifier == del_asset.asset?.localIdentifier) {
                PhotoUtil.shareInstance.selectedAssets.remove(at: index);
                break;
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Asset_Notice), object: nil, userInfo: ["data" : del_asset])
    }
    
    class func authoriza() {
        
        if (PHPhotoLibrary.authorizationStatus() != .authorized) {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                
            })
        }
    }
    
    class func getLibraryList() -> Array<AssetCollection> {

        var allCollections: Array<AssetCollection> = []
        
        let options: PHFetchOptions = PHFetchOptions();
        
        let data: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil);
        for index in 0..<data.count {
            let collection = data.object(at: index)
            allCollections.append(AssetCollection.create(collection: collection));
        }
        let smartAlbumsFetchResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchTopLevelUserCollections(with: options) as! PHFetchResult<PHAssetCollection>;
        for index in 0..<smartAlbumsFetchResult.count {
            let collection = smartAlbumsFetchResult.object(at: index)
            allCollections.append(AssetCollection.create(collection: collection));
        }
        for (index, collection) in allCollections.enumerated() {
            if (collection.assetCollection?.localizedTitle == "相机胶卷") {
                allCollections.remove(at: index);
                allCollections.insert(collection, at: 0);
                return allCollections;
            }
        }
        return allCollections;
    }
    
    class func getCollectionsAsset(collection: PHAssetCollection) -> Array<Asset> {
//        let options: PHFetchOptions = PHFetchOptions();
        let result: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: nil);
        var assets: Array<Asset> = [];
        result.enumerateObjects({ (asset, count, data) in
            assets.append(Asset.create(asset: asset));
        })
        
        return assets;
    }
    class func getImage(asset: Asset, type: AssetType, callback:@escaping (UIImage?) -> ()) {
        
        var options :PHImageRequestOptions = PHImageRequestOptions();
        var targetSize: CGSize?;
        
        let scale = UIScreen.main.scale;
        switch type {
        case .Custom(let size, let deliveryMode, let resizeMode):
            targetSize = CGSize(width: size.width * scale, height: size.height * scale)
            options.deliveryMode = deliveryMode;
            options.resizeMode = resizeMode;
            break;
        case .CustomSize(let size):
            targetSize = CGSize(width: size.width * scale, height: size.height * scale);
            options.deliveryMode = .highQualityFormat;
        case .HignQuality:
            targetSize = CGSize(width: scWidth * scale, height: scHeight * scale)
            options.deliveryMode = .highQualityFormat;
            options.resizeMode = .exact;
            break;
        }
        PHCachingImageManager.default().requestImage(for: asset.asset!, targetSize: targetSize!, contentMode: PHImageContentMode.aspectFill, options: options) { (image: UIImage?, dict) in
            
            callback(image!)
        }
        
        if (!PhotoUtil.shareInstance.cacheAssetSize.contains(NSValue(cgSize: targetSize!))) {
            let cache = PHCachingImageManager.default() as! PHCachingImageManager;
            cache.startCachingImages(for: [asset.asset!], targetSize: targetSize!, contentMode: .aspectFill, options: options);
            PhotoUtil.shareInstance.cacheAssetSize.append(NSValue(cgSize: targetSize!));
        }
    }
    
    class func getAssetSize(asset: Asset, complete: ((Data?) -> ())?) {
        if (asset.asset == nil) {
            if (complete != nil) {
                complete!(nil);
            }
        }
        if (asset.highQualityImageData != nil) {
            if (complete != nil) {
                complete!(asset.highQualityImageData);
            }
        }
        let option: PHImageRequestOptions = PHImageRequestOptions();
        option.deliveryMode = .highQualityFormat;
        PHCachingImageManager.default().requestImageData(for: asset.asset!, options: option) { (data, dataUTI, orientation, dict) in
            asset.highQualityImageData = data;
            if (complete != nil) {
                complete!(data);
            }
        }
    }
    
    /// ratio 表示将图片的高宽比切成ratio的比例 高/宽
    class func tailorImageByratio(ratio: CGFloat, image: UIImage) -> UIImage {
        
        // 大于0表示图片高比宽长
        // 小于0表示图片高比宽短
        let rate: CGFloat = image.size.height / image.size.width;
        var newSize: CGSize?;
        
        if (ratio > rate) {
            newSize = CGSize(width: image.size.height / ratio, height: image.size.height);
        } else if (ratio < rate) {
            newSize = CGSize(width: image.size.width, height: image.size.width * ratio)
        } else {
            newSize = CGSize(width: image.size.width, height: image.size.width)
        }
        
        var cgImage: CGImage = image.cgImage!;
        let x: CGFloat = (image.size.width - (newSize?.width)!) / 2;
        let y: CGFloat = (image.size.height - (newSize?.height)!) / 2;
        cgImage = cgImage.cropping(to: CGRect(x: x, y: y, width: (newSize?.width)!, height: (newSize?.height)!))!
        return UIImage(cgImage: cgImage);
        
    }
    class func tailorImage(size: CGSize, image: UIImage) {
        
    }
    
}

