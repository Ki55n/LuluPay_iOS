import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "customCyanColor" asset catalog color resource.
    static let customCyan = DeveloperToolsSupport.ColorResource(name: "customCyanColor", bundle: resourceBundle)

    /// The "forgotPin" asset catalog color resource.
    static let forgotPin = DeveloperToolsSupport.ColorResource(name: "forgotPin", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "CheckCircle" asset catalog image resource.
    static let checkCircle = DeveloperToolsSupport.ImageResource(name: "CheckCircle", bundle: resourceBundle)

    /// The "Help" asset catalog image resource.
    static let help = DeveloperToolsSupport.ImageResource(name: "Help", bundle: resourceBundle)

    /// The "Log_out" asset catalog image resource.
    static let logOut = DeveloperToolsSupport.ImageResource(name: "Log_out", bundle: resourceBundle)

    /// The "Visa" asset catalog image resource.
    static let visa = DeveloperToolsSupport.ImageResource(name: "Visa", bundle: resourceBundle)

    /// The "account_icon" asset catalog image resource.
    static let accountIcon = DeveloperToolsSupport.ImageResource(name: "account_icon", bundle: resourceBundle)

    /// The "agreements" asset catalog image resource.
    static let agreements = DeveloperToolsSupport.ImageResource(name: "agreements", bundle: resourceBundle)

    /// The "appearance" asset catalog image resource.
    static let appearance = DeveloperToolsSupport.ImageResource(name: "appearance", bundle: resourceBundle)

    /// The "card_background" asset catalog image resource.
    static let cardBackground = DeveloperToolsSupport.ImageResource(name: "card_background", bundle: resourceBundle)

    /// The "cards" asset catalog image resource.
    static let cards = DeveloperToolsSupport.ImageResource(name: "cards", bundle: resourceBundle)

    /// The "close" asset catalog image resource.
    static let close = DeveloperToolsSupport.ImageResource(name: "close", bundle: resourceBundle)

    /// The "delete-key" asset catalog image resource.
    static let deleteKey = DeveloperToolsSupport.ImageResource(name: "delete-key", bundle: resourceBundle)

    /// The "link" asset catalog image resource.
    static let link = DeveloperToolsSupport.ImageResource(name: "link", bundle: resourceBundle)

    /// The "logo" asset catalog image resource.
    static let logo = DeveloperToolsSupport.ImageResource(name: "logo", bundle: resourceBundle)

    /// The "money-sack 1" asset catalog image resource.
    static let moneySack1 = DeveloperToolsSupport.ImageResource(name: "money-sack 1", bundle: resourceBundle)

    /// The "notify" asset catalog image resource.
    static let notify = DeveloperToolsSupport.ImageResource(name: "notify", bundle: resourceBundle)

    /// The "password" asset catalog image resource.
    static let password = DeveloperToolsSupport.ImageResource(name: "password", bundle: resourceBundle)

    /// The "person" asset catalog image resource.
    static let person = DeveloperToolsSupport.ImageResource(name: "person", bundle: resourceBundle)

    /// The "profile" asset catalog image resource.
    static let profile = DeveloperToolsSupport.ImageResource(name: "profile", bundle: resourceBundle)

    /// The "rate_us" asset catalog image resource.
    static let rateUs = DeveloperToolsSupport.ImageResource(name: "rate_us", bundle: resourceBundle)

    /// The "req_money" asset catalog image resource.
    static let reqMoney = DeveloperToolsSupport.ImageResource(name: "req_money", bundle: resourceBundle)

    /// The "security" asset catalog image resource.
    static let security = DeveloperToolsSupport.ImageResource(name: "security", bundle: resourceBundle)

    /// The "send_money" asset catalog image resource.
    static let sendMoney = DeveloperToolsSupport.ImageResource(name: "send_money", bundle: resourceBundle)

    /// The "settings" asset catalog image resource.
    static let settings = DeveloperToolsSupport.ImageResource(name: "settings", bundle: resourceBundle)

    /// The "transfer" asset catalog image resource.
    static let transfer = DeveloperToolsSupport.ImageResource(name: "transfer", bundle: resourceBundle)

    /// The "withdraw" asset catalog image resource.
    static let withdraw = DeveloperToolsSupport.ImageResource(name: "withdraw", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "customCyanColor" asset catalog color.
    static var customCyan: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .customCyan)
#else
        .init()
#endif
    }

    /// The "forgotPin" asset catalog color.
    static var forgotPin: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .forgotPin)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "customCyanColor" asset catalog color.
    static var customCyan: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .customCyan)
#else
        .init()
#endif
    }

    /// The "forgotPin" asset catalog color.
    static var forgotPin: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .forgotPin)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    /// The "customCyanColor" asset catalog color.
    static var customCyan: SwiftUI.Color { .init(.customCyan) }

    /// The "forgotPin" asset catalog color.
    static var forgotPin: SwiftUI.Color { .init(.forgotPin) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "customCyanColor" asset catalog color.
    static var customCyan: SwiftUI.Color { .init(.customCyan) }

    /// The "forgotPin" asset catalog color.
    static var forgotPin: SwiftUI.Color { .init(.forgotPin) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "CheckCircle" asset catalog image.
    static var checkCircle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .checkCircle)
#else
        .init()
#endif
    }

    /// The "Help" asset catalog image.
    static var help: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .help)
#else
        .init()
#endif
    }

    /// The "Log_out" asset catalog image.
    static var logOut: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logOut)
#else
        .init()
#endif
    }

    /// The "Visa" asset catalog image.
    static var visa: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .visa)
#else
        .init()
#endif
    }

    /// The "account_icon" asset catalog image.
    static var accountIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accountIcon)
#else
        .init()
#endif
    }

    /// The "agreements" asset catalog image.
    static var agreements: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .agreements)
#else
        .init()
#endif
    }

    /// The "appearance" asset catalog image.
    static var appearance: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appearance)
#else
        .init()
#endif
    }

    /// The "card_background" asset catalog image.
    static var cardBackground: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cardBackground)
#else
        .init()
#endif
    }

    /// The "cards" asset catalog image.
    static var cards: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cards)
#else
        .init()
#endif
    }

    /// The "close" asset catalog image.
    static var close: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .close)
#else
        .init()
#endif
    }

    /// The "delete-key" asset catalog image.
    static var deleteKey: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .deleteKey)
#else
        .init()
#endif
    }

    /// The "link" asset catalog image.
    static var link: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .link)
#else
        .init()
#endif
    }

    /// The "logo" asset catalog image.
    static var logo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "money-sack 1" asset catalog image.
    static var moneySack1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .moneySack1)
#else
        .init()
#endif
    }

    /// The "notify" asset catalog image.
    static var notify: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .notify)
#else
        .init()
#endif
    }

    /// The "password" asset catalog image.
    static var password: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .password)
#else
        .init()
#endif
    }

    /// The "person" asset catalog image.
    static var person: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .person)
#else
        .init()
#endif
    }

    /// The "profile" asset catalog image.
    static var profile: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profile)
#else
        .init()
#endif
    }

    /// The "rate_us" asset catalog image.
    static var rateUs: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rateUs)
#else
        .init()
#endif
    }

    /// The "req_money" asset catalog image.
    static var reqMoney: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .reqMoney)
#else
        .init()
#endif
    }

    /// The "security" asset catalog image.
    static var security: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .security)
#else
        .init()
#endif
    }

    /// The "send_money" asset catalog image.
    static var sendMoney: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sendMoney)
#else
        .init()
#endif
    }

    /// The "settings" asset catalog image.
    static var settings: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .settings)
#else
        .init()
#endif
    }

    /// The "transfer" asset catalog image.
    static var transfer: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .transfer)
#else
        .init()
#endif
    }

    /// The "withdraw" asset catalog image.
    static var withdraw: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .withdraw)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "CheckCircle" asset catalog image.
    static var checkCircle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .checkCircle)
#else
        .init()
#endif
    }

    /// The "Help" asset catalog image.
    static var help: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .help)
#else
        .init()
#endif
    }

    /// The "Log_out" asset catalog image.
    static var logOut: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logOut)
#else
        .init()
#endif
    }

    /// The "Visa" asset catalog image.
    static var visa: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .visa)
#else
        .init()
#endif
    }

    /// The "account_icon" asset catalog image.
    static var accountIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .accountIcon)
#else
        .init()
#endif
    }

    /// The "agreements" asset catalog image.
    static var agreements: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .agreements)
#else
        .init()
#endif
    }

    /// The "appearance" asset catalog image.
    static var appearance: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appearance)
#else
        .init()
#endif
    }

    /// The "card_background" asset catalog image.
    static var cardBackground: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cardBackground)
#else
        .init()
#endif
    }

    /// The "cards" asset catalog image.
    static var cards: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cards)
#else
        .init()
#endif
    }

    /// The "close" asset catalog image.
    static var close: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .close)
#else
        .init()
#endif
    }

    /// The "delete-key" asset catalog image.
    static var deleteKey: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .deleteKey)
#else
        .init()
#endif
    }

    /// The "link" asset catalog image.
    static var link: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .link)
#else
        .init()
#endif
    }

    /// The "logo" asset catalog image.
    static var logo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "money-sack 1" asset catalog image.
    static var moneySack1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .moneySack1)
#else
        .init()
#endif
    }

    /// The "notify" asset catalog image.
    static var notify: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .notify)
#else
        .init()
#endif
    }

    /// The "password" asset catalog image.
    static var password: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .password)
#else
        .init()
#endif
    }

    /// The "person" asset catalog image.
    static var person: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .person)
#else
        .init()
#endif
    }

    /// The "profile" asset catalog image.
    static var profile: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profile)
#else
        .init()
#endif
    }

    /// The "rate_us" asset catalog image.
    static var rateUs: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rateUs)
#else
        .init()
#endif
    }

    /// The "req_money" asset catalog image.
    static var reqMoney: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .reqMoney)
#else
        .init()
#endif
    }

    /// The "security" asset catalog image.
    static var security: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .security)
#else
        .init()
#endif
    }

    /// The "send_money" asset catalog image.
    static var sendMoney: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sendMoney)
#else
        .init()
#endif
    }

    /// The "settings" asset catalog image.
    static var settings: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .settings)
#else
        .init()
#endif
    }

    /// The "transfer" asset catalog image.
    static var transfer: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .transfer)
#else
        .init()
#endif
    }

    /// The "withdraw" asset catalog image.
    static var withdraw: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .withdraw)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

