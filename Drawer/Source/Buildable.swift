//
//  Buildable.swift
//  Drawer
//
//  Created by Tre'Ellis Cooper on 6/15/24.
//

import Foundation

/// A protocol that allows conforming objects to be configured via
/// method chaining.
///
/// The following example creates an object that conforms to ``Buildable`` 
/// and configures that object by setting `attribute1` to `value1` and
/// `attribute2` to `value2`:
///
///     let buildable = BuildableObject()
///         .set(\.attribute1, to: value1)
///         .set(\.attribute2, to: value2)
protocol Buildable {
    func set<Value>(
        _ keyPath: WritableKeyPath<Self, Value>,
        to value: Value
    ) -> Self
}

// MARK: - Default Implementations
extension Buildable {
    /// Creates a mutable version of `self` and sets the keypath to the
    /// provided value before returning `self`.
    ///
    /// - parameter keyPath: The keypath to write to.
    /// - parameter value: The value to set.
    func set<Value>(
        _ keyPath: WritableKeyPath<Self, Value>,
        to value: Value
    ) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
