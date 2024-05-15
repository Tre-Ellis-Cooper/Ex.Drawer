//
//  DefaultHandle.swift
//  Drawer
//
//  Created by Tre'Ellis Cooper on 8/15/24.
//

import SwiftUI

/// A view representing the default drawer handle.
///
/// The default handle is a transparent area with dimensions
/// based on the ``DrawerPosition``.
struct DefaultHandle: View {
    let position: DrawerPosition
    
    var body: some View {
        switch position {
        case .bottom, .top:
            Color.clear.frame(height: 20)
                .contentShape(Rectangle())
        case .leading, .trailing:
            Color.clear.frame(width: 20)
                .contentShape(Rectangle())
        }
    }
}
