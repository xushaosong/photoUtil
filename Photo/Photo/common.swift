//
//  common.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import Foundation
import UIKit

let Asset_Notice: String = "Asset_Status_Change"
let photoDetailViewHeight: CGFloat = 70;
let photoOperateViewHeight: CGFloat = 50;

let scWidth: CGFloat = UIScreen.main.bounds.size.width;
let scHeight: CGFloat = UIScreen.main.bounds.size.height;
let navigatorBgColor: UIColor = UIColor(red: 202/255.0, green: 30/255.0, blue: 201/255.0, alpha: 1);

// 获取本地语言库
func kFetchParams(key: String) -> String {
    return Bundle.main.localizedString(forKey: key, value: nil, table: nil);
}
// 计算字体
// 计算字符串长度
func getString(stringName: NSString, font: UIFont, maxSize: CGSize) -> CGSize {
    let dictFont = [
        NSFontAttributeName : font
    ];
    let paragraphStyle = NSMutableParagraphStyle();
    paragraphStyle.lineBreakMode = .byWordWrapping;
    var labelSize = stringName.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: dictFont, context: nil).size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

func getImagePath( imageName: String) -> UIImage {
    if (imageName == nil || imageName == "") {
        return UIImage();
    }
    var imageName = imageName
    let bundlePath = Bundle.main.path(forResource: "photos", ofType: "bundle");
    
    if (!imageName.hasSuffix(".png") && !imageName.hasSuffix(".jpg")) {
        imageName = imageName + ".png";
    }
    let imgPath = bundlePath! + "/" + imageName;
    let image = UIImage(contentsOfFile: imgPath);
    if (image == nil) {
        return UIImage();
    }
    return image!;
}
// 设置导航栏标题
func setNavigationTitle(title: NSString, color: UIColor?) -> UILabel {
    let font = UIFont.boldSystemFont(ofSize: 18);
    let size = getString(stringName: title, font: font, maxSize: CGSize(width: 10000, height: 25));
    
    let navTitle = UILabel();
    navTitle.text = title as String;
    if (color == nil) {
        navTitle.textColor = UIColor.white;
    } else {
        navTitle.textColor = color;
    }
    navTitle.font = font;
    navTitle.frame = CGRect(x: 0, y: 0, width: size.width, height: 40);
    return navTitle;
}


