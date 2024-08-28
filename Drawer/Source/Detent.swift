//
//  Detent.swift
//  Drawer
//
//  Created by Tre'Ellis Cooper on 6/15/24.
//

import Foundation

/// A struct representing a drawer detent (resting position).
///
/// Its literal value is the ratio of the drawer coverage to the available
/// space. For example, ``Detent.medium`` has a literal value of 0.5 which
/// specifies a resting coverage that is 50% of the available space.
struct Detent: ExpressibleByFloatLiteral {
    static let all: ClosedRange<Detent> = 0.0 ... 1.0
    static let hidden: Detent = 0.0
    static let large: Detent = 1.0
    static let medium: Detent = 0.5
    static let small: Detent = 0.05

    let value: CGFloat
    
    init(floatLiteral value: CGFloat.NativeType) {
        self.value = min(max(value, 0.0), 1.0)
    }
}

// MARK: - Hashable Conformance
extension Detent: Hashable { }

// MARK: - Comparable Conformance
extension Detent: Comparable {
    static func < (lhs: Detent, rhs: Detent) -> Bool {
        lhs.value < rhs.value
    }
}
