//
//  DrawerLayoutTests.swift
//  DrawerTests
//
//  Created by Tre'Ellis Cooper on 7/3/24.
//

import XCTest
import SwiftUI

@testable import Drawer

/// Test cases for `BottomLayout`.
final class DrawerLayoutTests: XCTestCase {
    var layout: DrawerLayout!
    
    override func setUp() {
        super.setUp()
        
        layout = DrawerLayout(
            ratio: .test(.zero),
            detent: .test(.hidden)
        )
    }
    
    // MARK: - Test Content Alignment
    func test_content_alignment_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .traits(for: .zero)
        
        XCTAssertEqual(
            traits.contentAlignment, .top,
            "Incorrect content alignment."
        )
    }
    
    func test_content_alignment_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .traits(for: .zero)
        
        XCTAssertEqual(
            traits.contentAlignment, .trailing,
            "Incorrect content alignment."
        )
    }
    
    func test_content_alignment_top_position() {
        let traits = layout
            .set(\.position, to: .top)
            .traits(for: .zero)
        
        XCTAssertEqual(
            traits.contentAlignment, .bottom,
            "Incorrect content alignment."
        )
    }
    
    func test_content_alignment_trailing_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .traits(for: .zero)
        
        XCTAssertEqual(
            traits.contentAlignment, .trailing,
            "Incorrect content alignment."
        )
    }
    
    // MARK: - Test Content Size
    func test_content_size_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.contentSize.height, 100,
            "Incorrect content height value."
        )
        XCTAssertNil(
            traits.contentSize.width,
            "Incorrect valid ratio values."
        )
    }
    
    func test_content_size_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.contentSize.width, 100,
            "Incorrect content height value."
        )
        XCTAssertNil(
            traits.contentSize.height,
            "Incorrect valid ratio values."
        )
    }
    
    func test_content_size_top_position() {
        let traits = layout
            .set(\.position, to: .top)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.contentSize.height, 100,
            "Incorrect content height value."
        )
        XCTAssertNil(
            traits.contentSize.width,
            "Incorrect valid ratio values."
        )
    }
    
    func test_content_size_trailing_position() {
        let traits = layout
            .set(\.position, to: .trailing)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.contentSize.width, 100,
            "Incorrect content width value."
        )
        XCTAssertNil(
            traits.contentSize.height,
            "Incorrect content height value."
        )
    }
    
    // MARK: - Test Panel Size
    func test_panel_size_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.panelSize.height, 160,
            "Incorrect panel height value."
        )
        XCTAssertNil(
            traits.panelSize.width,
            "Incorrect panel width value."
        )
    }
    
    func test_panel_size_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.panelSize.width, 160,
            "Incorrect content width value."
        )
        XCTAssertNil(
            traits.panelSize.height,
            "Incorrect content height value."
        )
    }
    
    func test_panel_size_top_position() {
        let traits = layout
            .set(\.position, to: .top)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.panelSize.height, 160,
            "Incorrect panel height value."
        )
        XCTAssertNil(
            traits.panelSize.width,
            "Incorrect panel width value."
        )
    }
    
    func test_panel_size_trailing_position() {
        let traits = layout
            .set(\.position, to: .trailing)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.panelSize.width, 160,
            "Incorrect content width value."
        )
        XCTAssertNil(
            traits.panelSize.height,
            "Incorrect content height value."
        )
    }
    
    // MARK: - Test Panel Offset
    func test_panel_offset_bottom_position() {
        let traits = layout
            .set(\.ratio.wrappedValue, to: 0.5)
            .set(\.position, to: .bottom)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.panelOffset.x, .zero,
            "Incorrect panel X offset."
        )
        XCTAssertEqual(
            traits.panelOffset.y, 50,
            "Incorrect panel Y offset."
        )
    }
    
    func test_panel_offset_leading_position() {
        let traits = layout
            .set(\.ratio.wrappedValue, to: 0.5)
            .set(\.position, to: .leading)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.panelOffset.x, -110,
            "Incorrect panel X offset."
        )
        XCTAssertEqual(
            traits.panelOffset.y, .zero,
            "Incorrect panel Y offset."
        )
    }
    
    func test_panel_offset_top_position() {
        let traits = layout
            .set(\.ratio.wrappedValue, to: 0.5)
            .set(\.position, to: .top)
            .traits(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(
            traits.panelOffset.x, .zero,
            "Incorrect panel X offset."
        )
        XCTAssertEqual(
            traits.panelOffset.y, -110,
            "Incorrect panel Y offset."
        )
    }
    
    func test_panel_offset_trailing_position() {
        let traits = layout
            .set(\.ratio.wrappedValue, to: 0.5)
            .set(\.position, to: .trailing)
            .traits(for: CGSize(width: 100, height: 100))
        
        XCTAssertEqual(
            traits.panelOffset.y, .zero,
            "Incorrect panel X offset."
        )
        XCTAssertEqual(
            traits.panelOffset.x, 50,
            "Incorrect panel Y offset."
        )
    }
    
    // MARK: - Test is Content Disabled
    func test_content_enabled() {
        let traits = layout
            .set(\.detent.wrappedValue, to: .large)
            .set(\.interactiveDetents, to: [.large])
            .traits(for: .zero)
        
        XCTAssertFalse(
            traits.isContentDisabled,
            "Incorrect `isContentDisabled` value."
        )
    }
    
    func test_content_disabled() {
        let traits = layout
            .set(\.detent.wrappedValue, to: .small)
            .set(\.interactiveDetents, to: [.large])
            .traits(for: .zero)
        
        XCTAssertTrue(
            traits.isContentDisabled,
            "Incorrect `isContentDisabled` value."
        )
    }
    
    // MARK: - Test Positive Drag
    func test_positive_drag_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDrag(CGSize(width: 25, height: 25))
        
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.25,
            "Incorrect ratio computed."
        )
    }
    
    func test_positive_drag_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDrag(CGSize(width: 25, height: 25))
        
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.75,
            "Incorrect ratio computed."
        )
    }
    
    func test_positive_drag_top_position() {
        let traits = layout
            .set(\.position, to: .top)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDrag(CGSize(width: 25, height: 25))
        
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.75,
            "Incorrect ratio computed."
        )
    }
    
    func test_positive_drag_trailing_position() {
        let traits = layout
            .set(\.position, to: .trailing)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDrag(CGSize(width: 25, height: 25))
        
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.25,
            "Incorrect ratio computed."
        )
    }
    
    // MARK: - Test Negative Drag
    func test_negative_drag_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDrag(CGSize(width: -25, height: -25))
        
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.75,
            "Incorrect ratio value."
        )
    }
    
    func test_negative_drag_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDrag(CGSize(width: -25, height: -25))
        
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.25,
            "Incorrect ratio value."
        )
    }
    
    func test_negative_drag_top_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDrag(CGSize(width: -25, height: -25))
        
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.25,
            "Incorrect ratio computed."
        )
    }
    
    func test_negative_drag_trailing_position() {
        let traits = layout
            .set(\.position, to: .trailing)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDrag(CGSize(width: -25, height: -25))
        
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.75,
            "Incorrect ratio value."
        )
    }
    
    // MARK: - Test Positive Drag End (No Detents)
    func test_positive_drag_end_no_detents_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDragEnd(CGSize(width: 25, height: 25))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, 0.25,
            "Incorrect detent computed."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.25,
            "Incorrect ratio computed."
        )
    }
    
    func test_positive_drag_end_no_detents_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDragEnd(CGSize(width: 25, height: 25))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, 0.75,
            "Incorrect detent computed."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.75,
            "Incorrect ratio computed."
        )
    }
    
    func test_positive_drag_end_no_detents_top_position() {
        let traits = layout
            .set(\.position, to: .top)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDragEnd(CGSize(width: 25, height: 25))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, 0.75,
            "Incorrect detent computed."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.75,
            "Incorrect ratio computed."
        )
    }
    
    func test_positive_drag_end_no_detents_trailing_position() {
        let traits = layout
            .set(\.position, to: .trailing)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDragEnd(CGSize(width: 25, height: 25))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, 0.25,
            "Incorrect detent computed."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.25,
            "Incorrect ratio computed."
        )
    }
    
    // MARK: - Test Negative Drag End (No Detents)
    func test_negative_drag_end_no_detents_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDragEnd(CGSize(width: -25, height: -25))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, 0.75,
            "Incorrect detent computed."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.75,
            "Incorrect ratio computed."
        )
    }
    
    func test_negative_drag_end_no_detents_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDragEnd(CGSize(width: -25, height: -25))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, 0.25,
            "Incorrect detent computed."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.25,
            "Incorrect ratio computed."
        )
    }
    
    func test_negative_drag_end_no_detents_top_position() {
        let traits = layout
            .set(\.position, to: .top)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDragEnd(CGSize(width: -25, height: -25))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, 0.25,
            "Incorrect detent computed."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.25,
            "Incorrect ratio computed."
        )
    }
    
    func test_negative_drag_end_no_detents_trailing_position() {
        let traits = layout
            .set(\.position, to: .trailing)
            .set(\.detent.wrappedValue, to: .medium)
            .traits(for: CGSize(width: 100, height: 100))

        traits.onDragEnd(CGSize(width: -25, height: -25))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, 0.75,
            "Incorrect detent computed."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, 0.75,
            "Incorrect ratio computed."
        )
    }
    
    // MARK: - Test Positive Drag End (w/ Detents)
    func test_positive_drag_end_detents_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .set(\.detent.wrappedValue, to: .medium)
            .set(\.allDetents, to: [.small, .medium, .large])
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDragEnd(CGSize(width: 26, height: 26))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, .small,
            "Incorrect detent value."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, Detent.small.value,
            "Incorrect ratio value."
        )
    }
    
    func test_positive_drag_end_detents_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .set(\.detent.wrappedValue, to: .medium)
            .set(\.allDetents, to: [.small, .medium, .large])
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDragEnd(CGSize(width: 26, height: 26))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, .large,
            "Incorrect detent value."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, Detent.large.value,
            "Incorrect ratio value."
        )
    }
    
    func test_positive_drag_end_detents_top_position() {
        let traits = layout
            .set(\.position, to: .top)
            .set(\.detent.wrappedValue, to: .medium)
            .set(\.allDetents, to: [.small, .medium, .large])
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDragEnd(CGSize(width: 26, height: 26))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, .large,
            "Incorrect detent value."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, Detent.large.value,
            "Incorrect ratio value."
        )
    }
    
    func test_positive_drag_end_detents_trailing_position() {
        let traits = layout
            .set(\.position, to: .trailing)
            .set(\.detent.wrappedValue, to: .medium)
            .set(\.allDetents, to: [.small, .medium, .large])
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDragEnd(CGSize(width: 26, height: 26))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, .small,
            "Incorrect detent value."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, Detent.small.value,
            "Incorrect ratio value."
        )
    }
    
    // MARK: - Test Negative Drag End (w/ Detents)
    func test_negative_drag_end_detents_bottom_position() {
        let traits = layout
            .set(\.position, to: .bottom)
            .set(\.detent.wrappedValue, to: .medium)
            .set(\.allDetents, to: [.small, .medium, .large])
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDragEnd(CGSize(width: -26, height: -26))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, .large,
            "Incorrect layout detent value."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, Detent.large.value,
            "Incorrect layout detent value."
        )
    }
    
    func test_negative_drag_end_detents_leading_position() {
        let traits = layout
            .set(\.position, to: .leading)
            .set(\.detent.wrappedValue, to: .medium)
            .set(\.allDetents, to: [.small, .medium, .large])
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDragEnd(CGSize(width: -26, height: -26))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, .small,
            "Incorrect layout detent value."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, Detent.small.value,
            "Incorrect layout detent value."
        )
    }
    
    func test_negative_drag_end_detents_top_position() {
        let traits = layout
            .set(\.position, to: .top)
            .set(\.detent.wrappedValue, to: .medium)
            .set(\.allDetents, to: [.small, .medium, .large])
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDragEnd(CGSize(width: -26, height: -26))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, .small,
            "Incorrect layout detent value."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, Detent.small.value,
            "Incorrect layout detent value."
        )
    }
    
    func test_negative_drag_end_detents_trailing_position() {
        let traits = layout
            .set(\.position, to: .trailing)
            .set(\.detent.wrappedValue, to: .medium)
            .set(\.allDetents, to: [.small, .medium, .large])
            .traits(for: CGSize(width: 100, height: 100))
        
        traits.onDragEnd(CGSize(width: -26, height: -26))
        
        XCTAssertEqual(
            layout.detent.wrappedValue, .large,
            "Incorrect layout detent value."
        )
        XCTAssertEqual(
            layout.ratio.wrappedValue, Detent.large.value,
            "Incorrect layout detent value."
        )
    }
}

extension Binding {
    static func test(_ value: Value) -> Binding<Value> {
        var value: Value = value
        return Binding(get: { value }, set: { value = $0 })
    }
}
