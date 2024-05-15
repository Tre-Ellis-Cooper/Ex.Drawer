//
//  Drawer.swift
//  Drawer
//
//  Created by Tre'Ellis Cooper on 6/15/24.
//

import SwiftUI

/// A view that renders a drawer component.
///
/// A `Drawer` renders the provided content/handle view builders on a panel
/// that can be panned across its container. You can specify the drawer's
/// pinned edge by using the ``Drawer/position(_:)`` modifier.
///
/// If you want more control over the drawer panel styling, you can use the
/// ``Drawer/cornerRadius(_:)`` or ``Drawer/panelStyle(_:)`` modifiers.
///
/// To control the drawer behavior, specifically its resting positions and
/// interactive resting positions, use the ``Drawer/detents(_:)`` and
/// ``Drawer/interactiveDetents(_:)`` modifiers.
///
/// The provided content view is layed out as you would expect from other
/// organizing views in the standard library: it uses only the space it needs
/// and is centered within the alotted space (the drawer panel). The drawer
/// panel, however, assumes all of the drawer's alloted space.
///
/// The following example creates an instance that renders `CustomView` and
/// `CustomHandle`on a material panel and establishes its detents
/// (resting positions) as ``Detent/medium`` and ``Detent/large``.
///
///     Drawer(
///         content: CustomView.init, 
///         handle: CustomHandle.init
///     )
///     .panelStyle(.regularMaterial)
///     .detents([.medium, .large])
struct Drawer<Content: View, Handle: View>: View {
    let content: Content
    let handle: (DrawerPosition) -> Handle
    
    private var allDetents: Set<Detent> = []
    private var interactiveDetents: Set<Detent> = []
    
    private var cornerRadius: CGFloat = .zero
    private var panelStyle: AnyShapeStyle = .init(.white)
    private var position: DrawerPosition = .bottom
    
    /// Creates an instance that renders a drawer component with the provided
    /// content view builder and a handle view builder that expects a
    /// ``DrawerPosition`` parameter.
    ///
    /// - parameter content: The view builder for drawer content.
    /// - parameter handle: The view builder for the drawer handle.
    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder handle: @escaping (DrawerPosition) -> Handle
    ) {
        self.content = content()
        self.handle = handle
    }
    
    var body: some View {
        GeometryReader { geometry in
            switch position {
            case .bottom:
                _Panel(content: content, handle: handle(.bottom))
                    .set(\.allDetents, to: allDetents)
                    .set(\.cornerRadius, to: cornerRadius)
                    .set(\.geometry, to: geometry.size)
                    .set(\.interactiveDetents, to: interactiveDetents)
                    .set(\.panelStyle, to: panelStyle)
                    .set(\.position, to: .bottom)
                    .transition(.move(edge: .bottom))
            case .leading:
                _Panel(content: content, handle: handle(.leading))
                    .set(\.allDetents, to: allDetents)
                    .set(\.cornerRadius, to: cornerRadius)
                    .set(\.geometry, to: geometry.size)
                    .set(\.interactiveDetents, to: interactiveDetents)
                    .set(\.panelStyle, to: panelStyle)
                    .set(\.position, to: .leading)
                    .transition(.move(edge: .leading))
            case .top:
                _Panel(content: content, handle: handle(.top))
                    .set(\.allDetents, to: allDetents)
                    .set(\.cornerRadius, to: cornerRadius)
                    .set(\.geometry, to: geometry.size)
                    .set(\.interactiveDetents, to: interactiveDetents)
                    .set(\.panelStyle, to: panelStyle)
                    .set(\.position, to: .top)
                    .transition(.move(edge: .top))
            case .trailing:
                _Panel(content: content, handle: handle(.trailing))
                    .set(\.allDetents, to: allDetents)
                    .set(\.cornerRadius, to: cornerRadius)
                    .set(\.geometry, to: geometry.size)
                    .set(\.interactiveDetents, to: interactiveDetents)
                    .set(\.panelStyle, to: panelStyle)
                    .set(\.position, to: .trailing)
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

// MARK: - Convenience Initializers
extension Drawer where Handle: View {
    /// Creates an instance that renders a drawer component with the provided
    /// content view builder and a handle view builder that **does not**
    /// expect a ``DrawerPosition`` parameter.
    ///
    /// Use this if your handle does should not depend on the instance's
    /// current position.
    ///
    /// - parameter content: The view builder for drawer content.
    /// - parameter handle: The view builder for the drawer handle.
    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder handle: @escaping () -> Handle
    ) {
        self.init(content: content, handle: { _ in handle() })
    }
}

extension Drawer where Handle == DefaultHandle {
    /// Creates an instance that renders the provided content and assumes the
    /// default drawer handle. See ``DefaultHandle`` for details.
    ///
    /// - parameter content: The view builder for drawer content.
    init (@ViewBuilder content: () -> Content) {
        self.init(content: content, handle: DefaultHandle.init)
    }
}

// MARK: - Buildable Conformance
extension Drawer: Buildable {
    /// Sets the corner radius for the drawer panel.
    ///
    /// - parameter radius: The specified corner radius.
    func cornerRadius(_ radius: CGFloat) -> Self {
        set(\.cornerRadius, to: radius)
    }
    
    /// Sets the possible detents (resting positions) for the drawer.
    ///
    /// The drawer will always attempt to settle at the nearest detent.
    /// Therefore, if no detents are provided, the drawer will rest wherever
    /// it is released.
    ///
    /// - note: See ``Detent`` for info on creating detents.
    /// - parameter detents: The array of possible detents.
    func detents(_ detents: [Detent]) -> Self {
        set(\.allDetents, to: Set(detents))
    }
    
    /// Sets the actionable detents (resting positions) for the drawer.
    ///
    /// In order for interaction to be possible, the array of interactive
    /// detents must contain the current detent. Consequently, if no
    /// interactive detents are set, the drawer **content** will never
    /// be actionable.
    ///
    /// - note: See ``Detent`` for info on creating detents.
    /// - parameter detents: The array of interactive detents.
    func interactiveDetents(_ detents: [Detent]) -> Self {
        set(\.interactiveDetents, to: Set(detents))
    }
    
    /// Sets the style for the drawer panel.
    ///
    /// - parameter style: The specified `ShapeStyle`.
    func panelStyle<S: ShapeStyle>(_ style: S) -> Self {
        set(\.panelStyle, to: AnyShapeStyle(style))
    }
    
    /// Sets the placement (pinned edge) of the drawer.
    ///
    /// The default placement is the bottom edge of the container.
    ///
    /// - note: See ``DrawerPosition`` for info on possible placements.
    /// - parameter placement: The specified drawer placement.
    func position(_ position: DrawerPosition) -> Self {
        set(\.position, to: position)
    }
}

// MARK: - Drawer._Panel
// Drawer implementation detail.
private struct _Panel<Content: View, Handle: View>: View {
    let content: Content
    let handle: Handle
    
    private let gestureSpace = "drawer_space"
    
    @State private var detent = Detent.small
    @State private var ratio = Detent.small.value
    
    var cornerRadius: CGFloat = .zero
    var geometry: CGSize = .zero
    var panelStyle: AnyShapeStyle = .init(.white)
    var position: DrawerPosition = .bottom
    
    var allDetents: Set<Detent> = []
    var interactiveDetents: Set<Detent> = []
    
    var body: some View {
        let traits = DrawerLayout(ratio: $ratio, detent: $detent)
            .set(\.allDetents, to: allDetents)
            .set(\.interactiveDetents, to: interactiveDetents)
            .set(\.position, to: position)
            .traits(for: geometry)
        let gesture = DragGesture(
          minimumDistance: 10,
          coordinateSpace: .named(gestureSpace))
            .onChanged(pass(\.translation, to: traits.onDrag))
            .onEnded(pass(\.predictedEndTranslation, to: traits.onDragEnd))
        
        ZStack(alignment: traits.contentAlignment) {
            // Panel view
            Color.clear
                .background(panelStyle,
                  in: RoundedRectangle(cornerRadius: cornerRadius))
                .frame(height: traits.panelSize.height)
                .frame(width: traits.panelSize.width)
            // Content view
            content
                .disabled(traits.isContentDisabled)
                .frame(maxHeight: traits.contentSize.height)
                .frame(maxWidth: traits.contentSize.width)
            // Handle view
            handle
                .gesture(gesture)
        }
        .clipped()
        .geometryGroup()
        .offset(x: traits.panelOffset.x)
        .offset(y: traits.panelOffset.y)
        .coordinateSpace(name: gestureSpace)
        .gesture(gesture,
          including: traits.isContentDisabled ? .gesture : .subviews)
    }

    private func pass<Object, Value>(
        _ keypath: KeyPath<Object, Value>,
        to closure: @escaping (Value) -> Void
    ) -> (Object) -> Void {
        return { object in
            closure(object[keyPath: keypath])
        }
    }
}

// MARK: - _Panel Buildable Conformance
extension _Panel: Buildable { }
