//
//  Constants.swift
//  Drawer
//
//  Created by Tre'Ellis Cooper on 6/15/24.
//

import SwiftUI

typealias Assets = Constants.Assets
typealias Strings = Constants.Strings
typealias Values = Constants.Values

typealias AssetKeys = Assets.Keys
typealias Colors = Assets.Colors
typealias Icons = Assets.Icons
typealias Images = Assets.Images

/// An enum housing general constants for the example app.
enum Constants {
    enum Assets {
        enum Keys {
            // Colors
            static let highlightColor = "HighlightColor"
            static let primaryBackgroundColor = "PrimaryBackgroundColor"
            static let primaryTextColor = "PrimaryTextColor"
            static let secondaryBackgroundColor = "SecondaryBackgroundColor"
            static let secondaryTextColor = "SecondaryTextColor"
            
            // Icons
            static let closeIcon = "xmark"
            static let lockIcon = "lock"
            static let plusIcon = "plus"
            
            // Images
            static let backgroundGrid = "BackgroundGrid"
        }
        
        enum Colors {
            static let highlight = Color(Keys.highlightColor)
            static let primaryBackground = Color(Keys.primaryBackgroundColor)
            static let primaryText = Color(Keys.primaryTextColor)
            static let secondaryBackground = Color(Keys.secondaryBackgroundColor)
            static let secondaryText = Color(Keys.secondaryTextColor)
        }
        
        enum Icons {
            static let close = Image(systemName: Keys.closeIcon)
            static let lock = Image(systemName: Keys.lockIcon)
            static let plus = Image(systemName: Keys.plusIcon)
        }
        
        enum Images {
            static let backgroundGrid = Image(Keys.backgroundGrid)
        }
    }
    
    enum Strings {
        static let backgroundStyle = "Background Style"
        static let bottom = "Bottom"
        static let color = "Color"
        static let contentEnabled = "Content Enabled"
        static let cornerRadius = "Corner Radius"
        static let deploymentTarget = "Target: iOS \(Utility.minimumOS)"
        static let detents = "Detents"
        static let disabled = "Disabled"
        static let drawer = "Drawer"
        static let enabled = "Enabled"
        static let ex = "Ex."
        static let integerFormat = "%0.f"
        static let left = "Left"
        static let panelStyle = "Panel Style"
        static let placement = "Placement"
        static let ratioFormat = "%0.2f"
        static let ratio = "Ratio"
        static let right = "Right"
        static let settings = "Settings"
        static let top = "Top"
        
        static let backgroundStyleBlurb = "The Drawer exposes a background"
            + " style attribute which accepts any ShapeStyle. Try changing the"
            + " color."
        static let cornerRadiusBlurb = "The Drawer component exposes a corner"
            + " radius attribute. Try adjusting it."
        static let detentsBlurb = "The Drawer exposes attributes for its"
            + " resting positions (detents). Experiment with enabling or"
            + " disabling as well as adding or removing detents below."
        static let detentRatioBlurb = "Set the coverage ratio for the selected"
            + " detent."
        static let placementBlurb = "The Drawer component allows for"
            + " configurable placement. It can be oriented to the top, bottom,"
            + " left, or right of its container."
    }
    
    enum Utility {
        static let notAvailable = "N/A"
        static let minimumOSKey = "MinimumOSVersion"
        static let minimumOS = Bundle.main.infoDictionary?[minimumOSKey]
            as? String ?? notAvailable
    }
    
    enum Values {
        static let cornerRadii = CGFloat.zero ... 60
        static let cornerRadiiStep: CGFloat = 1
        static let detentOptionRange = CGFloat.zero ... 1
        static let detentOptionStep: CGFloat = 0.01
        static let defaultDetents = [
            DetentOption(ratio: Detent.small.value),
            DetentOption(ratio: 0.61),
            DetentOption(
                ratio: Detent.large.value,
                enabled: true,
                locked: true
            )
        ]
    }
}
