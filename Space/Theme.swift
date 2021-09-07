import UIKit

struct Theme {
    struct Font {
        static func scaleFont(_ font: UIFont) -> UIFont {
            // Using the default scale, but you can always switch this out for a scale that works better for your app.
            // Example, if you wanted to use the size scaling that largeTitle provides:
            // return UIFontMetrics(forTextStyle: UIFont.TextStyle.largeTitle).scaledFont(for: font)
            return UIFontMetrics.default.scaledFont(for: font)
        }
        /* These are the reading fonts
         If using custom fonts, make sure:
         - The file is included in the project
         - The file name is in the Info.plist
         - You spelled the font name correctly (Check using Font Book, if in doubt.)
         */
        static func regular(size: CGFloat) -> UIFont {
            return scaleFont(UIFont(name: "AvenirNext-Regular", size: size)!)
        }
        static func demiBold(size: CGFloat) -> UIFont {
            return scaleFont(UIFont(name: "AvenirNext-DemiBold", size: size)!)
        }
        static func bold(size: CGFloat) -> UIFont {
            return scaleFont(UIFont(name: "AvenirNext-Bold", size: size)!)
        }
        
        // These are your display or decorative fonts.
        // Great for titles; fewer than 3-4 words.
        static func decorative(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-Regular", size: size)!
        }
    }
    
    struct Color {
        // If you need to set colors in code, use these properties.
        // All these properties reference colors defined in ThemeColors.xcassets
        static let accent = UIColor(named: "AccentColor")!
        static let background = UIColor(named: "BackgroundColor")!
        static let darkAccentColor = UIColor(named: "DarkAccentColor")!
        static let textOnDark = UIColor(named: "TextOnDarkColor")!
        static let textOnLight = UIColor(named: "TextOnLightColor")!
        static let tint = UIColor(named: "TintColor")!
    }
}
