<picture>
    <source srcset="../../../Ex.Media/blob/develop/Drawer/DrawerDemo-Dark.gif" media="(prefers-color-scheme: dark)">
    <source srcset="../../../Ex.Media/blob/develop/Drawer/DrawerDemo-Light.gif" media="(prefers-color-scheme: light)">
    <img src="../../../Ex.Media/blob/develop/Drawer/DrawerDemo-Light.gif" align="left" width="345" height="460">
</picture>

<img src="../../../Ex.Media/blob/develop/Misc/Spacer.png" width="332" height="0">

<picture>
    <!-- Original: 738 x 130 | Adjusted: 1/2 @ 90% -->
    <source srcset="../../../Ex.Media/blob/develop/Drawer/DrawerLogo-Dark.png" media="(prefers-color-scheme: dark)">
    <source srcset="../../../Ex.Media/blob/develop/Drawer/DrawerLogo-Light.png" media="(prefers-color-scheme: light)">
    <img src="../../../Ex.Media/blob/develop/Drawer/DrawerLogo-Light.png" width="332" height="59">
</picture>

#### Explore an example drawer implementation.
###### In the Example Series, we engineer solutions to custom UI/UX <br> systems and components, focusing on production quality code.
###### Stay tuned for updates to the series:
[![Follow](https://img.shields.io/github/followers/Tre-Ellis-Cooper?style=social)](https://github.com/Tre-Ellis-Cooper)

<br>

[![LinkedIn](https://img.shields.io/static/v1?style=social&logo=linkedin&label=LinkedIn&message=Tre%27Ellis%20Cooper)](https://www.linkedin.com/in/tre-ellis-cooper-629306106/)&nbsp;
[![Twitter](https://img.shields.io/static/v1?style=social&logo=x&label=Twitter&message=@_cooperlative)](https://www.twitter.com/_cooperlative/)<br>
[![Instagram](https://img.shields.io/static/v1?style=social&logo=instagram&label=Instagram&message=@_cooperlative)](https://www.instagram.com/_cooperlative/)

<br>

![Repo Size](https://img.shields.io/github/repo-size/Tre-Ellis-Cooper/Ex.Drawer?color=green)&nbsp;
![Last Commit](https://img.shields.io/github/last-commit/Tre-Ellis-Cooper/Ex.Drawer?color=C23644)

<br>

## Usage

#### Using the drawer:
* Create a `Drawer` by providing a content view and handle view.
```swift
struct ExampleView: View {
    var body: some View {
        Drawer {
            Text("Content!") 
        } handle { position in
            CustomHandle(position: position)
        }
    }
}
```

<br>

* If the handle doesn't depend on drawer placement, use the initializer that takes a "nullary" closure:
```swift
struct ExampleView: View {
    var body: some View {
        Drawer {
            Text("Content!") 
        } handle {
            CustomHandle()
        }
    }
}
```

<br>

* Configure the drawer's' attributes using the custom view modifiers: `.cornerRadius(_:)`, `.panelStyle(_:)`, `.placement(_:)`, `.detents(_:)`, `.interactiveDetents(_:)`.
```swift
struct ExampleView: View {
    var body: some View {
        Drawer {
            ...
        }
        .cornerRadius(12)
        .placement(.bottom)
        .panelStyle(.regularMaterial)
        .detents([.medium, .large])
        .interactiveDetents([.large])
    }
}
```

<br>

Try adding the Source directory to your project to use the `Drawer` in your app!

## Exploration

<details>
    
<summary>Code Design</summary>

### Code Design

When building applications, it's often tempting to create elements tailored strictly for the task at hand. However, if you've worked on a project long enough, you'll soon realize that the ability to make quick adjustments and alterations to components is just as crucial as developing them in the first place. The `Drawer` is designed with this flexibility in mind, allowing developers to tweak, repurpose, and visually adjust it without extensive refactoring. Below is a breakdown of the code structure and the rationale behind it.

#### Auxillary Components

Before delving into the specifics of the `Drawer` itself, let's explore the auxiliary components that define its behavior and functionality: the `Detent` type, the `DrawerPosition` enum, and the `Buildable` protocol.

###### The `Detent` Type

A `Detent` represents a resting position for the drawer, defining where it will settle once released. This is achieved by specifying a `value` attribute, which is a decimal representing a percentage of the available space. For example, a `Detent` with a `value` of 0.5 means the drawer will cover 50% of the available space when at rest.

We opted for a percentage-based representation because it avoids the complications that can arise from explicit sizing. Using pixels or points to specify a `Detent` ties it to a fixed value, regardless of context. For instance, a height of 200 px/pts might work well in portrait mode but not in landscape. A percentage-based height, however, adapts to different contexts, making it more versatile. This approach also aligns with SwiftUI's preference for implicit layouts.

When defining and providing `Detent` objects to the `Drawer`, ease and convenience are key. A traditional initializer can be cumbersome for creating an object with a single value, so `Detent` conforms to `ExpressibleByFloatLiteral`. This conformance allows for creating `Detent` types from a raw `Float` value and sanitizing any unreasonable values via the required initializer.
```swift
struct Detent: ExpressibleByFloatLiteral {    
    ...

    let value: CGFloat
    
    init(floatLiteral value: CGFloat.NativeType) {
        ...
        
        self.value = min(max(value, lower), upper)
    }
}
```
To simplify the creation and use of detents further, we expose static values for common decimals:
```swift
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
```
> The value of a detent is automatically clamped to `Detent.all`. Depending on the application, these values can be adjusted to allow or disallow different detents. Since the `Drawer` computes its position in terms of detents, its behavior will automatically adjust based on these values.

###### The `DrawerPosition` Enum

The next component, `DrawerPosition`, is an enum that defines the possible orientations of the drawer within its container:
```swift
enum DrawerPosition {
    case bottom
    case leading
    case top
    case trailing
}
```

While a bottom-placed drawer is standard and often sufficient, there are scenarios where a top-oriented or side-oriented drawer may be required. This enum allows for flexible positioning, supporting various use cases beyond the traditional drawer configuration.

###### The `Buildable` Protocol

The `Buildable` protocol defines a contract for setting object values using key paths and returning the updated object. It provides a default implementation that creates a mutable version of self, sets the key path value, and returns the updated object.
```swift
protocol Buildable {
    func set<Value>(
        _ keyPath: WritableKeyPath<Self, Value>,
        to value: Value
    ) -> Self
}

extension Buildable {
    func set<Value>(
        _ keyPath: WritableKeyPath<Self, Value>,
        to value: Value
    ) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
```
This protocol allows conforming types to be configured through method chaining, enabling a `SwiftUI.View`-like configuration syntax for the `Drawer` and other custom objects.

#### The Drawer Implementation

Now that we understand the auxiliary types, let's introduce the `Drawer` API. The default initializer is for rendering a drawer with custom content and a handle that depends on the `DrawerPosition` value.
```swift
struct Drawer<Content: View, Handle: View>: View {
    let content: Content
    let handle: (DrawerPosition) -> Handle
    
    ...
    
    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder handle: @escaping (DrawerPosition) -> Handle
    ) {
        self.content = content()
        self.handle = handle
    }
    
    ...
}
```
The `Drawer` also provides two convenience initializers: one for rendering custom content with a handle that isn't dependent on `DrawerPosition`, and one for using a default handle:
```swift
extension Drawer where Handle: View {
    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder handle: @escaping () -> Handle
    ) {
        self.init(content: content, handle: { _ in handle() })
    }
}

extension Drawer where Handle == DefaultHandle {
    init (@ViewBuilder content: () -> Content) {
        self.init(content: content, handle: DefaultHandle.init)
    }
}
```
To support method chaining configuration, the `Drawer` conforms to the `Buildable` protocol and provides custom modifiers:
```swift
struct Drawer<Content: View, Handle: View>: View {
    ...
    
    private var allDetents: Set<Detent> = []
    private var interactiveDetents: Set<Detent> = []
    
    private var cornerRadius: CGFloat = .zero
    private var panelStyle: AnyShapeStyle = .init(.white)
    private var position: DrawerPosition = .bottom
    
    ...
}

extension Drawer: Buildable {
    func cornerRadius(_ radius: CGFloat) -> Self {
        set(\.cornerRadius, to: radius)
    }

    func detents(_ detents: [Detent]) -> Self {
        set(\.allDetents, to: Set(detents))
    }
    
    func interactiveDetents(_ detents: [Detent]) -> Self {
        set(\.interactiveDetents, to: Set(detents))
    }
    
    func panelStyle<S: ShapeStyle>(_ style: S) -> Self {
        set(\.panelStyle, to: AnyShapeStyle(style))
    }
    
    func position(_ position: DrawerPosition) -> Self {
        set(\.position, to: position)
    }
}
```
> It's important to call these custom modifiers before any standard library view modifiers, as the latter perform type erasure on the returned view.

##### The `Drawer` Body

The `Drawer` body consists of a switch statement that renders the appropriate panel based on the current position:
```swift
struct Drawer<Content: View, Handle: View>: View {
    ...
    
    private var position = DrawerPosition.bottom
    
    ...

    var body: some View {
        GeometryReader { geometry in
            switch position {
            case .bottom:
                _Panel(content: content, handle: handle(.bottom))
                    ...
            case .leading:
                _Panel(content: content, handle: handle(.leading))
                    ...
            case .top:
                _Panel(content: content, handle: handle(.top))
                    ...
            case .trailing:
                _Panel(content: content, handle: handle(.trailing))
                    ...
            }
        }
    }
}
```
By abstracting panel behavior into a private member, we encapsulate the transition between `DrawerPosition` values if it changes at runtime. This approach allows the drawer to gracefully manage transitions between different positions.
```swift
struct Drawer<Content: View, Handle: View>: View {
    ...
    
    private var placement = DrawerPlacement.bottom
    
    ...

    var body: some View {
        GeometryReader { geometry in
            switch placement {
            case .bottom:
                _Panel(content: content, handle: handle(.bottom))
                    ...
                    .transition(.move(edge: .bottom))
            case .leading:
                _Panel(content: content, handle: handle(.leading))
                    ...
                    .transition(.move(edge: .leading))
            case .top:
                _Panel(content: content, handle: handle(.top))
                    ...
                    .transition(.move(edge: .top))
            case .trailing:
                _Panel(content: content, handle: handle(.trailing))
                    ...
                    .transition(.move(edge: .trailing))
            }
        }
    }
}
```
This universal handling of position changes ensures consistent behavior across different drawer orientations.

##### The `_Panel` View

At the core of the `Drawer` implementation is the `_Panel` view component. It uses a `ZStack` to layer the drawer panel, content, and handle from bottom to top. The layout logic is encapsulated in a `DrawerLayout` object, which computes view traits:
```swift
private struct _Panel<Content: View, Handle: View>: View {
    let content: Content
    let handle: Handle
    
    private let gestureSpace = "drawer_space"
    
    ...
    
    var cornerRadius: CGFloat = .zero
    var geometry: CGSize = .zero
    var panelStyle: AnyShapeStyle = .init(.white)
    
    ...
    
    var body: some View {
        let traits = DrawerLayout(...)
            ...
        let gesture = DragGesture(
          minimumDistance: .zero,
          coordinateSpace: .named(gestureSpace))
            ...
        
        ZStack(...) {
            // Panel view
            Color.clear
                .background(panelStyle,
                  in: RoundedRectangle(cornerRadius: cornerRadius))
                ...
            // Content view
            content
                ...
            // Handle view
            handle
                .gesture(gesture)
        }
        ...
        .coordinateSpace(name: gestureSpace)
        .gesture(gesture, ...)
    }
}
```
> The minimum drag distance is set to `.zero` to ensure the drawer's drag gesture takes priority over internal controls, preventing scroll views or sliders from hijacking the drag gesture.

#### Conclusion

This breakdown of the `Drawer` component highlights the considerations made to ensure it remains flexible and maintainable. By understanding the auxiliary types, API, and internal implementation, you can see how the `Drawer` succeeds in adapting to various use cases. I hope you found this exploration insightful. Would you agree that the `Drawer` effectively balances flexibility with functionality?

For more details on the `DrawerLayout` object and its role in facilitating testability for the `Drawer` component, check out the Code Testing section.

</details>

<details>

<summary>Code Testing</summary>

### Code Testing

In UI component development, ensuring that components remain as "dumb" as possible—meaning they handle minimal logic and are mostly concerned with rendering—greatly enhances maintainability and testability. This philosophy guided the design of the `Drawer` component, where all view-related computations are delegated to a dedicated layout object, `DrawerLayout`.

The `DrawerLayout` is a `Buildable` object responsible for computing and returning the traits necessary for rendering a drawer given a specific `CGSize`. It encapsulates all the logic related to positioning, sizing, and handling drag gestures, thus allowing the `Drawer` view to focus purely on rendering.
```swift
struct DrawerLayout: Buildable {
    let ratio: Binding<CGFloat>
    let detent: Binding<Detent>
    
    var allDetents: Set<Detent> = []
    var interactiveDetents: Set<Detent> = []
    var position: DrawerPosition = .bottom
    
    ...
    
    func traits(for geometry: CGSize) -> Traits { ... }
    
    struct Traits: Buildable {
        var contentAlignment: Alignment = .bottom
        var contentSize: ProposedViewSize = .unspecified
        var isContentDisabled = false
        var panelOffset: CGPoint = .zero
        var panelSize: ProposedViewSize = .unspecified
        
        var onDrag: (CGSize) -> Void = { _ in }
        var onDragEnd: (CGSize) -> Void = { _ in }
    }
}
```
Within the `Drawer` component, the `_Panel` view leverages `DrawerLayout` to compute all the necessary traits before rendering. This keeps the view "dumb" and defers all the complex logic to `DrawerLayout`, enabling easy testing and maintenance.
```swift
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
        ...
        .offset(x: traits.panelOffset.x)
        .offset(y: traits.panelOffset.y)
        .coordinateSpace(name: gestureSpace)
        .gesture(gesture,
          including: traits.isContentDisabled ? .gesture : .subviews)
    }
    
    ...
}
```
> While it might seem more conventional to use a `@StateObject` or `@ObservedObject` to manage the `DrawerLayout`, doing so introduced challenges that conflicted with SwiftUI best practices:
> 1. `@ObservedObject`: This property wrapper implies that the object is maintained outside the view, making it unsuitable for a self-contained UI component like the `Drawer`. Additionally, creating a private `@ObservedObject` within the view is discouraged as it leads to the object being recreated whenever the view updates, potentially causing state loss.
> 2. `@StateObject`: While `@StateObject` ensures the state object persists across view updates, it doesn't allow modifying the object’s attributes at runtime, which is necessary for our custom modifiers.
>
> Given these constraints, instantiating `DrawerLayout` within the view body ensures that layout computations are always current and correctly applied, without the pitfalls of improper state management.

By abstracting behavior into `DrawerLayout`, you can test various drawer states and scenarios independently from the view. For example, you can verify that a drawer in a bottom position with specific detents correctly updates its ratio and current detent when a drag ends:
```swift
final class DrawerLayoutTests: XCTestCase {
    var layout: DrawerLayout!
    
    ...
    
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
}
```
This approach allows for granular testing of the drawer's logic, ensuring that any defects can be identified and fixed with confidence, while protecting against regressions.

</details>

###### Do you agree that the design is adaptative and easy to use? Have any questions, comments, or just want to give feedback? Share your ideas with me on social media:
[![LinkedIn](https://img.shields.io/static/v1?style=social&logo=linkedin&label=LinkedIn&message=Tre%27Ellis%20Cooper)](https://www.linkedin.com/in/tre-ellis-cooper-629306106/)&nbsp;
[![Twitter](https://img.shields.io/static/v1?style=social&logo=x&label=Twitter&message=@_cooperlative)](https://www.twitter.com/_cooperlative/)&nbsp;
[![Instagram](https://img.shields.io/static/v1?style=social&logo=instagram&label=Instagram&message=@_cooperlative)](https://www.instagram.com/_cooperlative/)
