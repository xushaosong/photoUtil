//
//  AssetItemCell.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class AssetItemCell: UICollectionViewCell {
    
    var controlActionCall: ((Asset) -> ())?;
    
    var image: UIImage?;
    var asset: Asset? {
        didSet {
            if (asset?.asset != nil) {
                PhotoUtil.getImage(asset: asset!, type: AssetType.CustomSize(self.bounds.size)) { (image) in
                    if (image != nil) {
                        self.image = image;
                        self.setNeedsDisplay();
                    } else {
                        self.image = nil;
                    }
                }
            } else {
                image = nil;
            }
        }
    }
    var showDetailCell: Bool = false {
        didSet {
            if (showDetailCell) {
                control.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 35, height: 35);
            } else {
                control.frame = CGRect(x: self.bounds.width - 40, y: self.bounds.height - 40, width: 40, height: 40);
            }
            self.setNeedsDisplay();
        }
    }
    
    let control: UIControl = UIControl();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.white;
        control.addTarget(self, action: #selector(selectedToggle), for: UIControlEvents.touchUpInside);
        
        control.frame = CGRect(x: self.bounds.width - 40, y: self.bounds.height - 40, width: 40, height: 40);
        
        self.contentView.addSubview(control);
    }
    func selectedToggle() {
        
        if (self.controlActionCall != nil) {
            self.controlActionCall!(asset!);
        }
        
        setNeedsDisplay();
    }
    override func draw(_ rect: CGRect) {
        
        if (image != nil) {
            let context = UIGraphicsGetCurrentContext()
            PhotoUtil.tailorImageByratio(ratio: self.bounds.size.height / self.bounds.size.width, image: image!).draw(in: self.bounds, blendMode: CGBlendMode.normal, alpha: 1)
            
            if (self.showDetailCell) {
                getImagePath(imageName: "default_busnavi_tip_cancle.png").draw(in: CGRect(x: self.bounds.width - 25, y: 5, width: 20, height: 20))
            } else {
                if (asset?.isSelected)! {
                    getImagePath(imageName: "selected.png").draw(in: CGRect(x: self.bounds.width - 25, y: self.bounds.height - 25, width: 20, height: 20));
                } else {
                    getImagePath(imageName: "selected_no.png").draw(in: CGRect(x: self.bounds.width - 25, y: self.bounds.height - 25, width: 20, height: 20));
                }
            }
            context?.strokePath()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
