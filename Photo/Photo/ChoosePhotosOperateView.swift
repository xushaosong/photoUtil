//
//  ChoosePhotosOperateView.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class ChoosePhotosOperateView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NSNotification.Name(rawValue: Asset_Notice), object: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateData() {
        
    }

}
