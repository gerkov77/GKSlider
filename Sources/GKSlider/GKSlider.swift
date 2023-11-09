// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct GKSlider: View {

    let range: Range<Double>
    @Binding var sliderValue: Double
    let configuration: Configuration

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
                    .frame(width: reader.size.width, height: 2)
                    .foregroundStyle(configuration.offTintColor)
                    .overlay {
                        Capsule()
                            .frame(width: position.x)
                            .frame(maxWidth: reader.size.width, alignment: .leading)
                            .foregroundStyle(configuration.onTintColor)
                    }

                GeometryReader { r in
                    Circle()
                        .frame(width: configuration.handleSize)
                        .foregroundStyle(configuration.handleColor)
                        .position(position)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in

                                    let minPosition = min(lastPosition!.x + value.translation.width, r.size.width)
                                    let maxPosition = max(minPosition, r.frame(in: .local).origin.x)
                                    position.x = maxPosition

                                    sliderValue = (position.x * scalelength) / r.size.width + range.lowerBound
                                })
                                .onEnded({ value in
                                    lastPosition?.x = position.x
                                    lastSliderValue = sliderValue
                                })

                        )
                        .onAppear {
                            position = CGPoint(
                                x: r.size.width * (sliderValue - range.lowerBound) / scalelength ,
                                y: r.size.height/2)
                            lastPosition = position
                            lastSliderValue = sliderValue
                        }
                }
            }.frame(height: configuration.handleSize)
        }
    }
}

public extension GKSlider {
    struct Configuration {
        var onTintColor: Color
        var offTintColor: Color
        var handleSize: CGFloat
        var handleColor: Color

      public init(onTintColor: Color = .blue,
                  offTintColor: Color = .black,
                  handleSize: CGFloat = 10,
                  handleColor: Color  = .white) {
            self.onTintColor = onTintColor
            self.offTintColor = offTintColor
            self.handleSize = handleSize
            self.handleColor = handleColor
        }
    }
}

// MARK: Helpers
extension GKSlider {
    private var scalelength: CGFloat {
        range.upperBound - range.lowerBound
    }
}
