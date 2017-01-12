//
//  ShowOriginImageView.swift
//  Photo
//
//  Created by xss@ttyhuo.cn on 2017/1/11.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class ShowOriginImageView: UIView {

    
    let imageView: UIImageView = UIImageView();
    let titleLabel: UILabel = UILabel();
    let sizeLabel: UILabel = UILabel();
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAction));
        self.addGestureRecognizer(tap);
        
        self.addSubview(imageView);
        self.addSubview(titleLabel);
        self.addSubview(sizeLabel);
        self.addSubview(activityIndicator);
        
        self.setConstraint();
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = getImagePath(imageName: "default_account_gender_radiobtn_normal.png");
        titleLabel.font = UIFont.systemFont(ofSize: 14);
        titleLabel.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1);
        titleLabel.text = "原图";
        
        sizeLabel.font = UIFont.systemFont(ofSize: 14);
        sizeLabel.textColor = UIColor.white;
        sizeLabel.text = "XXX"
        sizeLabel.isHidden = true;
        
        activityIndicator.color = UIColor.white;
        activityIndicator.activityIndicatorViewStyle = .white;
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true;
        setFrame();
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notice:)), name: NSNotification.Name(rawValue: Asset_Notice), object: nil);
        
    }
    func updateData(notice: Notification) {
        if (PhotoUtil.shareInstance.isSelectOriginImage) {
            weak var weakSelf = self;
            PhotoUtil.getSelectedAssetSize(complete: { (sizeText) in
                weakSelf?.activityIndicator.stopAnimating()
                weakSelf?.sizeLabel.isHidden = false;
                weakSelf?.sizeLabel.text = sizeText;
                weakSelf?.setFrame();
            })
        }
    }
    func clickAction() {
        
        PhotoUtil.shareInstance.isSelectOriginImage = !PhotoUtil.shareInstance.isSelectOriginImage;
        if (PhotoUtil.shareInstance.isSelectOriginImage) {
            imageView.image = getImagePath(imageName: "default_busline_icon_site_mylocation.png");
            titleLabel.textColor = UIColor.white;
            
            activityIndicator.startAnimating();
            weak var weakSelf = self;
            PhotoUtil.getSelectedAssetSize(complete: { (sizeText) in
                weakSelf?.activityIndicator.stopAnimating()
                weakSelf?.sizeLabel.isHidden = false;
                weakSelf?.sizeLabel.text = sizeText;
                weakSelf?.setFrame();
            })
        } else {
            imageView.image = getImagePath(imageName: "default_account_gender_radiobtn_normal.png");
            titleLabel.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1);
            sizeLabel.isHidden = true;
        }
        
        setFrame();
    }
    
    func setConstraint() {
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.sizeLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
        
        let imgLeft = NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0);
        let imgCenterY = NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        let imgWidth = NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 15);
        let imgHeight = NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 15);
        imgLeft.isActive = true;
        imgCenterY.isActive = true;
        imgWidth.isActive = true;
        imgHeight.isActive = true;
        
        let titleLeft = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.imageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 5);
        let titleCenterY = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        titleLeft.isActive = true;
        titleCenterY.isActive = true;
        
        let sizeLeft = NSLayoutConstraint(item: self.sizeLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 5);
        let sizeCenterY = NSLayoutConstraint(item: self.sizeLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        sizeLeft.isActive = true;
        sizeCenterY.isActive = true;
        
        let activityLeft = NSLayoutConstraint(item: self.activityIndicator, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 5);
        let activityCenterY = NSLayoutConstraint(item: self.activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0);
        activityLeft.isActive = true;
        activityCenterY.isActive = true;
        
    }
    func setFrame() {
        
        let titleSize = getString(stringName: titleLabel.text as! NSString, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: 10000, height: 40));
        
        if (PhotoUtil.shareInstance.isSelectOriginImage) {
            
            if (sizeLabel.isHidden) {
                self.frame = CGRect(x: 0, y: 0, width: titleSize.width + 20 + 20, height: 40);
            } else {
                let sizeLabelSize = getString(stringName: sizeLabel.text as! NSString, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: 1000, height: 40));
                self.frame = CGRect(x: 0, y: 0, width: titleSize.width + 20 + sizeLabelSize.width + 5, height: 40);
            }
            
        } else {
            self.frame = CGRect(x: 0, y: 0, width: titleSize.width + 20, height: 40);
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
