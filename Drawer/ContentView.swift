//
//  ContentView.swift
//  Drawer
//
//  Created by Tre'Ellis Cooper on 6/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var detentOptions = Values.defaultDetents
    @State private var focusedOption: DetentOption?
    @State private var position: DrawerPosition = .bottom
    
    @State private var cornerRadius: CGFloat = 35
    @State private var panelColor = Colors.highlight
    @State private var foregroundColor = Colors.primaryBackground

    var body: some View {
        ZStack {
            Images.backgroundGrid
                .resizable()
                .ignoresSafeArea()
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 30) {
                    Heading()
                    PlacementPicker()
                }
                .padding(25) 
                
                // MARK: Drawer
                let detents = detentOptions.map(\.detent)
                let interactiveDetents = detentOptions
                    .filter(\.enabled)
                    .map(\.detent)
                
                Drawer(content: SettingsPanel)
                    .position(position)
                    .panelStyle(panelColor)
                    .cornerRadius(cornerRadius)
                    .detents(detents)
                    .interactiveDetents(interactiveDetents)
                    .animation(.smooth, value: position)
            }
        }
        .foregroundStyle(Colors.primaryText)
    }
}

// MARK: - View Components
extension ContentView {
    @ViewBuilder private func AddDetentButton() -> some View {
        Button(action: addNewDetentOption) {
            Icons.plus
                .resizable()
                .frame(width: 12, height: 12)
                .padding(.horizontal, 14)
                .frame(maxHeight: .infinity)
                .overlay {
                    Border(
                        shape: RoundedRectangle(cornerRadius: 12),
                        color: Color.black,
                        lineWidth: 2
                    )
                    .blendMode(.destinationOut)
                }
        }
    }
    
    @ViewBuilder private func Border<S: InsettableShape>(
        shape InsettableShape: S,
        color Color: Color = Colors.secondaryText,
        lineWidth width: CGFloat = 1
    ) -> some View {
        Color
            .allowsHitTesting(false)
            .clipShape(
                InsettableShape
                    .inset(by: width / 2)
                    .stroke(lineWidth: width)
            )
    }
    
    @ViewBuilder private func CornerRadiusSlider() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.cornerRadius)
                .bold()
            Text(Strings.cornerRadiusBlurb)
            Slider(
                value: $cornerRadius,
                range: Values.cornerRadii,
                step: Values.cornerRadiiStep
            )
        }
    }
    
    @ViewBuilder private func DetentCell(
        option: DetentOption
    ) -> some View {
        let focused = focusedOption?.id == option.id
        let borderColor = focused ?
            foregroundColor : .black
        let blendMode = focused ?
            BlendMode.normal : BlendMode.destinationOut
        
        HStack(spacing: .zero) {
            Button(action: pass(option, to: focusOption)) {
                ZStack(alignment: .leading) {
                    Color.black
                        .blendMode(.destinationOut)
                    VStack(alignment: .leading) {
                        Text(option.ratioLabel)
                            .bold()
                        Text(option.enabledLabel)
                            .frame(width: 50, alignment: .leading)
                    }
                    .padding(.horizontal, 12)
                    .padding(.trailing, 15)
                }
            }
            if option.locked {
                Icons.lock
                    .resizable()
                    .frame(width: 10, height: 14)
                    .padding(.horizontal, 15)
                    .frame(maxHeight: .infinity)
            } else {
                Button(action: pass(option, to: deleteOption)) {
                    Icons.close
                        .resizable()
                        .frame(width: 10, height: 10)
                        .padding(.horizontal, 15)
                        .frame(maxHeight: .infinity)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            Border(
                shape: RoundedRectangle(cornerRadius: 12),
                color: borderColor,
                lineWidth: 2
            )
            .blendMode(blendMode)
        )
        .foregroundStyle(foregroundColor)
        .transition(.move(edge: .bottom))
    }
    
    @ViewBuilder private func DetentOptions(
        _ focused: Binding<DetentOption>
    ) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Toggle(
                isOn: focused.enabled,
                label: {
                    Text(Strings.contentEnabled)
                        .bold()
                }
            )
            .padding(12)
            .tint(.green)
            VStack(alignment: .leading, spacing: 12) {
                Text(Strings.ratio)
                    .bold()
                Text(Strings.detentRatioBlurb)
                Slider(
                    value: focused.ratio,
                    range: Values.detentOptionRange,
                    step: Values.detentOptionStep
                )
            }
            .padding(12)
            .padding(.vertical, 8)
            .background(
                Color.black
                    .blendMode(.destinationOut)
            )
        }
        .disabled(focused.locked.wrappedValue)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            Border(
                shape: RoundedRectangle(cornerRadius: 12),
                color: Color.black,
                lineWidth: 2
            )
            .blendMode(.destinationOut)
        )
    }
    
    @ViewBuilder private func DetentSettings() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text(Strings.detents)
                    .bold()
                Text(Strings.detentsBlurb)
            }
            .padding(.horizontal, 25)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    AddDetentButton()
                        .frame(width: 45)
                    ForEach(detentOptions, content: DetentCell)
                }
                .padding(.horizontal, 25)
                .animation(.easeInOut, value: detentOptions)
            }
            .frame(height: 50)
            
            if let option = Binding($focusedOption) {
                DetentOptions(option)
                    .padding(.horizontal, 25)
            }
        }
    }
    
    @ViewBuilder private func Divider() -> some View {
        Color.black
            .frame(height: 2)
            .padding(.vertical)
            .blendMode(.destinationOut)
    }
    
    @ViewBuilder private func Heading() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading) {
                Text(Strings.ex)
                    .font(.footnote.bold())
                    .opacity(0.5)
                Text(Strings.drawer)
                    .font(.title.bold())
            }
            Text(Strings.deploymentTarget)
                .font(.caption.bold())
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(
                    Colors.primaryBackground
                        .clipShape(Capsule())
                )
                .overlay(
                    Border(shape: Capsule())
                )
        }
    }
    
    @ViewBuilder private func PanelStylePicker() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.backgroundStyle)
                .bold()
            Text(Strings.backgroundStyleBlurb)
            HStack(spacing: 8) {
                Text("\(Strings.color):")
                    .bold()
                ColorPicker(Strings.panelStyle, selection: $panelColor)
                    .labelsHidden()
                    .onChange(of: panelColor, updateForegroundColor)
            }
        }
    }
    
    @ViewBuilder private func PlacementPicker() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.placement)
                .bold()
            VStack(spacing: 18) {
                Text(Strings.placementBlurb)
                Picker(Strings.placement, selection: $position) {
                    Text(Strings.top)
                        .tag(DrawerPosition.top)
                    Text(Strings.bottom)
                        .tag(DrawerPosition.bottom)
                    Text(Strings.left)
                        .tag(DrawerPosition.leading)
                    Text(Strings.right)
                        .tag(DrawerPosition.trailing)
                }
                .pickerStyle(.segmented)
                .background(
                    Colors.primaryBackground
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 1)
                )
            }
        }
        .font(.caption)
    }
    
    @ViewBuilder private func SettingsPanel() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 12) {
                Text(Strings.settings)
                    .bold()
                    .padding(.top, 6)
                VStack(alignment: .leading) {
                    PanelStylePicker()
                        .padding(.horizontal, 25)
                        .padding(.top, 12)
                    Divider()
                        .padding(.horizontal, 25)
                    CornerRadiusSlider()
                        .padding(.horizontal, 25)
                    Divider()
                        .padding(.horizontal, 25)
                    DetentSettings()
                    Spacer(minLength: 12.5)
                }
                .background(
                    foregroundColor
                        .opacity(0.09)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 12.5)
                )
                .compositingGroup()
            }
            .font(.caption)
            .padding(.vertical, 25)
            .buttonStyle(PlainButtonStyle())
            .tint(foregroundColor)
            .foregroundStyle(foregroundColor)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
    
    @ViewBuilder private func Slider(
        value: Binding<CGFloat>,
        range: ClosedRange<CGFloat>,
        step: CGFloat
    ) -> some View {
        let minimumLabel = String(
            format: Strings.integerFormat,
            range.lowerBound)
        let maximumLabel = String(
            format: Strings.integerFormat,
            range.upperBound)
        
        SwiftUI.Slider(value: value, in: range, step: step) {
            EmptyView()
        } minimumValueLabel: {
            Text(minimumLabel)
                .bold()
                .padding(.trailing, 8)
        } maximumValueLabel: {
            Text(maximumLabel)
                .bold()
                .padding(.leading, 8)
        }
    }
}

// MARK: - Helper Functions/Behavior
extension ContentView {
    private func pass<V>(
        _ value: V,
        to function: @escaping (V) -> Void
    ) -> () -> Void {
        return { function(value) }
    }
    
    private func addNewDetentOption() {
        detentOptions.insert(DetentOption(), at: .zero)
    }
    
    private func deleteOption(_ option: DetentOption) {
        detentOptions.removeAll { $0.id == option.id }
    }
    
    private func focusOption(_ option: DetentOption) {
        focusedOption = option
    }
    
    private func updateForegroundColor() {
        var red = CGFloat.zero
        var green = CGFloat.zero
        var blue = CGFloat.zero
        var alpha = CGFloat.zero
        
        UIColor(panelColor)
            .getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        if 0.2126 * red + 0.7152 * green + 0.0722 * blue < 0.6 {
            foregroundColor = .white
        } else {
            foregroundColor = .black
        }
    }
}

#Preview {
    ContentView()
}
