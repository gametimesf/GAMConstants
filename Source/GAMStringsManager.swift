//
//  GAMStringsManager.swift
//  Gametime
//
//  Created by Mike Silvis on 8/16/16.
//
//

import UIKit

class GAMStringsManager: NSObject {
    static let sharedInstance = GAMStringsManager()

    func stringForID(key : String?) -> String {
        guard let key = key else { return "" }

        return findString(key, safeToNotExist: false)
    }

    func stringForIDWithList(key : String?, args: CVaListPointer) -> String {
        guard let key = key else { return "" }

        return NSString(format: findString(key, safeToNotExist: false), locale: NSLocale.currentLocale(), arguments: args) as String
    }

    func stringForID(key : String?, safetoNotExist: Bool) -> String {
        guard let key = key else { return "" }

        return findString(key, safeToNotExist: safetoNotExist)
    }

    //
    // MARK: Finders
    //

    private func findString(key: String, safeToNotExist: Bool) -> String {
        if let string = findInterceptedString(key) {
            return string
        }

        return findLocalizedString(key, safeToNotExist: safeToNotExist)
    }

    private func findLocalizedString(key : String, safeToNotExist: Bool) -> String {
        let string = NSLocalizedString(key, comment: "")

        if string == key {
            assert(safeToNotExist, "Key: \(key) does not exist. Please add it")
        }

        if safeToNotExist && string.isEmpty {
            return key
        }

        return string
    }

    private func findInterceptedString(key : String) -> String? {
        return GAMInterceptionManager.sharedInstance.hotfixStringForKey(key)
    }

}

extension String {
    func localized() -> String {
        return GAMStringsManager.sharedInstance.stringForID(self)
    }

    func localizedWithArgs(args : CVarArgType...) -> String {
        return withVaList(args) {
            return GAMStringsManager.sharedInstance.stringForIDWithList(self, args: $0)
        } as String
    }
}

extension UIBarButtonItem {
    @IBInspectable var localizedText: String? {
        get {
            return title
        }
        set {
            title = newValue?.localized()
        }
    }
}

extension UIViewController {
    @IBInspectable var localizedTitle: String? {
        get {
            return title
        }
        set {
            title = newValue?.localized()
        }
    }
}

extension UIButton {
    @IBInspectable var localizedText: String? {
        get {
            return titleLabel?.text
        }
        set {
            setTitle(newValue?.localized(), forState: .Normal)
        }
    }
}

extension UILabel {
    @IBInspectable var localizedText: String? {
        get {
            return text
        }
        set {
            text = newValue?.localized()
        }
    }
}