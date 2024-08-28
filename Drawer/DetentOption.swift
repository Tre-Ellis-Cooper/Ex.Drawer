//
//  DetentOption.swift
//  Drawer
//
//  Created by Tre'Ellis Cooper on 7/3/24.
//

import Foundation

/// An object representing a detent option for the drawer
/// settings panel.
class DetentOption: Identifiable {
    let id: String = UUID().uuidString
    
    var enabled: Bool = false
    var locked: Bool = false
    var ratio: CGFloat = .zero
    
    var detent: Detent {
        .init(floatLiteral: ratio)
    }
    var enabledLabel: String {
        enabled ? Strings.enabled : Strings.disabled
    }
    var ratioLabel: String {
        String(format: Strings.ratioFormat, detent.value)
    }
    
    init(
        ratio: CGFloat = .zero,
        enabled: Bool = false,
        locked: Bool = false
    ) {
        self.enabled = enabled
        self.locked = locked
        self.ratio = ratio
    }
}

// MARK: - Equatable Conformance
extension DetentOption: Equatable {
    static func == (lhs: DetentOption, rhs: DetentOption) -> Bool {
        return lhs.id == rhs.id
    }
}
