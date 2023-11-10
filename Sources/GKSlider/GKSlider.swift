// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct GKSlider: View {
    let configuration: Configuration
    let range: Range<Double>

    @Binding var sliderValue: Double

    @State private(set) var position = CGPoint(x: 0.0, y: 0.0)
    @State private var lastPosition: CGPoint?
    @State private var lastSliderValue: Double = 0.0

    public init(range: Range<Double>,
                sliderValue: Binding<Double>,
                configuration: Configuration = Configuration()) {
        self.range = range
        _sliderValue = sliderValue
        self.configuration = configuration
    }

    public var body: some View {
        GeometryReader { reader in
            ZStack {
                Capsule()
                    .frame(
                        width: configuration.axis == .horizontal ? reader.size.width : configuration.barHeight,
                        height: configuration.axis == .vertical ? reader.size.height : configuration.barHeight
                    )
                    .foregroundStyle(configuration.offTintColor)
                    .overlay {
                        switch configuration.axis {
                        case .horizontal:
                            Capsule()
                                .frame(width: position.x)
                                .frame(maxWidth: reader.size.width, alignment: .leading)
                                .foregroundStyle(configuration.onTintColor)
                        case .vertical:
                            Capsule()
                                .frame(height: reader.size.height - position.y)
                                .frame(maxHeight: reader.size.height, alignment: .bottomTrailing)
                                .foregroundStyle(configuration.onTintColor)
                        }
                    }

                GeometryReader { r in
                    Circle()
                        .frame(width: configuration.handleSize)
                        .foregroundStyle(configuration.handleColor)
                        .position(position)
                        .gesture(
                            DragGesture()
                                .onChanged { onDragChanged($0, r: r) }
                                .onEnded { _ in onDragEnded() }
                        )
                        .onAppear { onAppear(r) }
                }
            }
        }.fixedSize(
            horizontal: configuration.axis == .vertical,
            vertical: configuration.axis == .horizontal
        )
    }
}

public extension GKSlider {
    struct Configuration {
        var axis: Axis
        var onTintColor: Color
        var offTintColor: Color
        var barHeight: CGFloat
        var handleSize: CGFloat
        var handleColor: Color

        public init(axis: Axis = .horizontal,
                    onTintColor: Color = .blue,
                    offTintColor: Color = .black,
                    barHeight: CGFloat = 2,
                    handleSize: CGFloat = 10,
                    handleColor: Color  = .white) {
            self.axis = axis
            self.onTintColor = onTintColor
            self.offTintColor = offTintColor
            self.barHeight = barHeight
            self.handleSize = handleSize
            self.handleColor = handleColor
        }
    }
}

// MARK: Helpers
extension GKSlider {
    private var scaleLength: CGFloat {
        range.upperBound - range.lowerBound
    }

    private func onAppear(_ r: GeometryProxy) {
        switch configuration.axis {
        case .horizontal:
            position = CGPoint(
                x: r.size.width * (sliderValue - range.lowerBound) / scaleLength,
                y: r.size.height / 2)
        case .vertical:
            position = CGPoint(
                x: r.size.width / 2,
                y: r.size.height * (sliderValue - range.lowerBound) / scaleLength)
        }

        lastPosition = position
        lastSliderValue = sliderValue
    }

    private func onDragChanged(_ value: DragGesture.Value, r: GeometryProxy) {
        switch configuration.axis {
        case .horizontal:
            let minPosition = min(lastPosition!.x + value.translation.width, r.size.width)
            let maxPosition = max(minPosition, r.frame(in: .local).minX)
            position.x = maxPosition

            sliderValue = (position.x * scaleLength) / r.size.width + range.lowerBound
        case .vertical:
            let minPosition = min(lastPosition!.y + value.translation.height, r.size.height)
            let maxPosition = max(minPosition, r.frame(in: .local).minY)
            position.y = maxPosition

            sliderValue = (position.y * scaleLength) / r.size.height + range.lowerBound
        }
    }

    private func onDragEnded() {
        lastPosition = position
        lastSliderValue = sliderValue
    }
}
