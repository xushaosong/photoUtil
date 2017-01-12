//
//  CollectionCell.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/10.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {

    let nameLabel: UILabel = UILabel();
    let countNameLabel: UILabel = UILabel();
    let countLabel: UILabel = UILabel();
    let firstImg: UIImageView = UIImageView();
    let arrow: UIImageView = UIImageView();
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    
        self.contentView.addSubview(nameLabel);
        self.contentView.addSubview(firstImg);
        self.contentView.addSubview(arrow);
        self.contentView.addSubview(countNameLabel);
        self.contentView.addSubview(countLabel);
        
        self.setConstraint();
        
        firstImg.layer.cornerRadius = 20;
        firstImg.layer.masksToBounds = true;
        firstImg.backgroundColor = UIColor.lightGray;
        
        nameLabel.font = UIFont.systemFont(ofSize: 16);
        nameLabel.textColor = UIColor(red: 117/255.0, green: 218/255.0, blue: 213/255.0, alpha: 1);
        
        countNameLabel.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1);
        countNameLabel.text = "图片数量：";
        countNameLabel.font = UIFont.systemFont(ofSize: 12);
        
        countLabel.textColor = UIColor(red: 27/255.0, green: 177/255.0, blue: 165/255.0, alpha: 1);
        countLabel.font = UIFont.systemFont(ofSize: 13);
        
        arrow.image = getImagePath(imageName: "default_carCenter_grayRightArraw.png")
    }
    
    var assetCollection: AssetCollection? {
        didSet {
            nameLabel.text = assetCollection?.assetCollection?.localizedTitle;
            if (assetCollection?.assets != nil && assetCollection?.assets?.first != nil && assetCollection?.assets?.first?.asset != nil) {
                countLabel.text = "\((assetCollection?.assets?.count)!)";
                
                PhotoUtil.getImage(asset: (assetCollection?.assets?.first)!, type: AssetType.CustomSize(self.bounds.size)) { (image) in
                    if (image != nil) {
                        self.firstImg.image = PhotoUtil.tailorImageByratio(ratio: 1, image: image!)
                    }
                }
            } else {
                firstImg.image = getImagePath(imageName: "default_main_skin_layer_disable.png");
                countLabel.text = "0";
            }
        }
    }
    
    func setConstraint() {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.firstImg.translatesAutoresizingMaskIntoConstraints = false;
        self.arrow.translatesAutoresizingMaskIntoConstraints = false;
        
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.countNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let leftImgCons = NSLayoutConstraint(item: self.firstImg, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 15);
        let centerYImgCons = NSLayoutConstraint(item: self.firstImg, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        let widthImgCons = NSLayoutConstraint(item: self.firstImg, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 40);
        let heightImgCons = NSLayoutConstraint(item: self.firstImg, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 40);
        leftImgCons.isActive = true;
        centerYImgCons.isActive = true;
        widthImgCons.isActive = true;
        heightImgCons.isActive = true;
        
        let leftLabelCons = NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.firstImg, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 15);
        let centerYLabelCons = NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -10);
        leftLabelCons.isActive = true;
        centerYLabelCons.isActive = true;
        
        let leftCountNameCons = NSLayoutConstraint(item: self.countNameLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.firstImg, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 15);
        let centerYCountNameCons = NSLayoutConstraint(item: self.countNameLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 10);
        
        leftCountNameCons.isActive = true;
        centerYCountNameCons.isActive = true;
        
        let leftCountLabelCons = NSLayoutConstraint(item: self.countLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.countNameLabel, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0);
        let centerYCountLabelCons = NSLayoutConstraint(item: self.countLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.countNameLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        leftCountLabelCons.isActive = true;
        centerYCountLabelCons.isActive = true;
        
        let rightArrowCons = NSLayoutConstraint(item: self.arrow, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.rightMargin, multiplier: 1, constant: -15);
        let widthArrowCons = NSLayoutConstraint(item: self.arrow, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 10);
        let heightArrowCons = NSLayoutConstraint(item: self.arrow, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 15);
        let centerYArrowCons = NSLayoutConstraint(item: self.arrow, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        
        
        
        rightArrowCons.isActive = true;
//        leftArrowCons.isActive = true;
        widthArrowCons.isActive = true;
        heightArrowCons.isActive = true;
        centerYArrowCons.isActive = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
