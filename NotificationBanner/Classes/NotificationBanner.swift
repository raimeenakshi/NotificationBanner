/*
 
 The MIT License (MIT)
 Copyright (c) 2017-2018 Dalton Hinterscher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit
import SnapKit

import MarqueeLabel

@objcMembers
open class NotificationBanner: BaseNotificationBanner {
    
    /// The bottom most label of the notification if a subtitle is provided
    public internal(set) var subtitleLabel: MarqueeLabel?
    
    /// The view that is presented on the left side of the notification
    private var leftView: UIView?
    
    /// The view that is presented on the right side of the notification
    private var rightView: UIView?
    
    /// Font used for the title label
    private var titleFont: UIFont = UIFont.systemFont(ofSize: 17.5, weight: UIFont.Weight.bold)
    
    /// Font used for the subtitle label
    private var subtitleFont: UIFont = UIFont.systemFont(ofSize: 15.0)

    public init(
        title: String? = nil,
        subtitle: String? = nil,
        leftView: UIView? = nil,
        rightView: UIView? = nil,
        style: BannerStyle = .info,
        colors: BannerColorsProtocol? = nil,
        bannerIndex: Int
    ) {
        
        super.init(style: style, colors: colors, bannerIndex: bannerIndex)
        
        if let leftView = leftView {
            contentView.addSubview(leftView)
            
            let size = (leftView.frame.height > 0) ? min(44, leftView.frame.height) : 44
            
            leftView.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview().offset(heightAdjustment / 4)
                make.left.equalToSuperview().offset(10)
                make.size.equalTo(size)
            })
        }
        
        if let rightView = rightView {
            contentView.addSubview(rightView)
            
            let size = (rightView.frame.height > 0) ? min(44, rightView.frame.height) : 44
            rightView.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview().offset(heightAdjustment / 4)
                make.right.equalToSuperview().offset(-10)
                make.size.equalTo(size)
            })
        }
        
        let labelsView = UIView()
        contentView.addSubview(labelsView)
        
        if let title = title {
            titleLabel = MarqueeLabel()
            (titleLabel as! MarqueeLabel).type = .left
            titleLabel!.font = titleFont
            titleLabel!.textColor = .white
            titleLabel!.text = title
            labelsView.addSubview(titleLabel!)
            
            titleLabel!.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                if let _ = subtitle {
                    titleLabel!.numberOfLines = 1
                } else {
                    titleLabel!.numberOfLines = 2
                }
            }
        }
        
        if let subtitle = subtitle {
            subtitleLabel = MarqueeLabel()
            subtitleLabel!.type = .left
            subtitleLabel!.font = subtitleFont
            subtitleLabel!.numberOfLines = 1
            subtitleLabel!.textColor = .white
            subtitleLabel!.text = subtitle
            labelsView.addSubview(subtitleLabel!)
            
            subtitleLabel!.snp.makeConstraints { (make) in
                if title != nil {
                    make.top.equalTo(titleLabel!.snp.bottom).offset(2.5)
                    make.left.equalTo(titleLabel!)
                    make.right.equalTo(titleLabel!)
                }
                else {
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                }
            }
        }
        
        labelsView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(heightAdjustment / 4)
            
            if let leftView = leftView {
                make.left.equalTo(leftView.snp.right).offset(padding)
            } else {
                make.left.equalToSuperview().offset(padding)
            }
            
            if let rightView = rightView {
                make.right.equalTo(rightView.snp.left).offset(-padding)
            } else {
                make.right.equalToSuperview().offset(-padding)
            }
            
            if let subtitleLabel = subtitleLabel {
                make.bottom.equalTo(subtitleLabel)
            } else {
                make.bottom.equalTo(titleLabel!)
            }
        }
        
        updateMarqueeLabelsDurations()
        
    }
    
    public convenience init(
        attributedTitle: NSAttributedString,
        attributedSubtitle: NSAttributedString? = nil,
        leftView: UIView? = nil,
        rightView: UIView? = nil,
        style: BannerStyle = .info,
        colors: BannerColorsProtocol? = nil,
        bannerIndex: Int
    ) {
        
        let subtitle: String? = (attributedSubtitle != nil) ? "" : nil
        self.init(title: "", subtitle: subtitle, leftView: leftView, rightView: rightView, style: style, colors: colors, bannerIndex: bannerIndex)
        titleLabel!.attributedText = attributedTitle
        subtitleLabel?.attributedText = attributedSubtitle
    }
    
    public init(customView: UIView, bannerIndex: Int) {
        super.init(style: .customView, bannerIndex: bannerIndex)
        self.customView = customView
        
        contentView.addSubview(customView)
        customView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        spacerView.backgroundColor = customView.backgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func updateMarqueeLabelsDurations() {
        super.updateMarqueeLabelsDurations()
        subtitleLabel?.speed = .duration(CGFloat(duration <= 1 ? 1 : duration - 1))
    }
    
}

public extension NotificationBanner {
    
    func applyStyling(
        cornerRadius: CGFloat? = nil,
        titleFont: UIFont? = nil,
        titleColor: UIColor? = nil,
        titleTextAlign: NSTextAlignment? = nil,
        subtitleFont: UIFont? = nil,
        subtitleColor: UIColor? = nil,
        subtitleTextAlign: NSTextAlignment? = nil
    ) {
        
        if let cornerRadius = cornerRadius {
            contentView.layer.cornerRadius = cornerRadius
        }
        
        if let titleFont = titleFont {
            titleLabel!.font = titleFont
        }
        
        if let titleColor = titleColor {
            titleLabel!.textColor = titleColor
        }
        
        if let titleTextAlign = titleTextAlign {
            titleLabel!.textAlignment = titleTextAlign
        }
        
        if let subtitleFont = subtitleFont {
            subtitleLabel!.font = subtitleFont
        }
        
        if let subtitleColor = subtitleColor {
            subtitleLabel!.textColor = subtitleColor
        }
        
        if let subtitleTextAlign = subtitleTextAlign {
            subtitleLabel!.textAlignment = subtitleTextAlign
        }
        
        if titleFont != nil || subtitleFont != nil {
            updateBannerHeight()
        }
    }
    
}
