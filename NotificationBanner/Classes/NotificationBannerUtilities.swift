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

class NotificationBannerUtilities: NSObject {

    class func isNotchFeaturedIPhone() -> Bool {
        if #available(iOS 11, *) {
            if UIApplication.shared.currentWindow?.safeAreaInsets.bottom ?? 0.0 > 0.0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    class func hasDynamicIsland() -> Bool {
        if #available(iOS 11, *) {
            if UIApplication.shared.currentWindow?.safeAreaInsets.top ?? 0.0 > 50.0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}

// As an extension for reusability
extension UIApplication {
    var currentWindow: UIWindow? {
        var appWindow: UIWindow?
        if #available(iOS 13.0, *) {
            let windowScene = connectedScenes.compactMap { $0 as? UIWindowScene }
            let activeWindow = windowScene.first { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            let keyWindow = activeWindow.flatMap { $0.windows.first(where: { $0.isKeyWindow }) }
            appWindow = keyWindow
        }

        return appWindow ?? UIApplication.shared.delegate?.window ?? nil
    }
}

