import UIKit
public enum SDKTheme {
    case light
    case dark
    case system
}

public struct SDKThemeColors {
    public var primary: UIColor
    public var background: UIColor
    public var text: UIColor

    public static var light: SDKThemeColors {
        return SDKThemeColors(
            primary: UIColor.systemBlue,
            background: UIColor.white,
            text: UIColor.black
        )
    }

    public static var dark: SDKThemeColors {
        return SDKThemeColors(
            primary: UIColor.systemTeal,
            background: UIColor.black,
            text: UIColor.white
        )
    }
}
public class SDKThemeManager {
    public static var currentTheme: SDKTheme = .system
    public static var customColors: SDKThemeColors?

    public static func configure(theme: SDKTheme) {
        currentTheme = theme
    }

    public static func applyTheme(to view: UIView) {
        switch currentTheme {
        case .light:
            view.overrideUserInterfaceStyle = .light
        case .dark:
            view.overrideUserInterfaceStyle = .dark
        case .system:
            view.overrideUserInterfaceStyle = .unspecified
        }

        let colors = themeColors()
        view.backgroundColor = colors.background

        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = colors.text
            } else if let button = subview as? UIButton {
                button.backgroundColor = colors.primary
                button.setTitleColor(colors.text, for: .normal)
            }else if let table = subview as? UITableView{
                table.backgroundColor = colors.background
                
            }
            else {
                applyTheme(to: subview)
            }
        }
    }

    public static func themeColors() -> SDKThemeColors {
        if let custom = customColors { return custom }

        switch currentTheme {
        case .light: return .light
        case .dark: return .dark
        case .system:
            return UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        }
    }
}
