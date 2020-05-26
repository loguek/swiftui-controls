//
//  RadicalGauge.swift
//  radical-controls
//
//  Created by Kevin Logue on 25/05/2020.
//  Copyright © 2020 Kevin Logue. All rights reserved.
//

import SwiftUI

struct RadicalGauge: View {
    private let indicatorLength: CGFloat = 30
    private let dashSettings: [CGFloat] = [4, 8]
    
    @State var currentValue:CGFloat
    var minValue:CGFloat
    var maxValue:CGFloat
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.gray,
                        style: StrokeStyle(
                            lineWidth: self.indicatorLength,
                            lineCap: .butt,
                            lineJoin: .miter,
                            dash: self.dashSettings))
            .frame(width: 300, height: 300)
            .opacity(0.5)
            .rotationEffect(Angle(degrees: 135))
            .padding()
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                     .onEnded {
                        
                    print($0.location)
            })
            
            Circle()
                .trim(from: 0, to: currentValue / maxValue * 0.75)
                    .stroke(Color.red,
                            style: StrokeStyle(
                                lineWidth: self.indicatorLength,
                                lineCap: .butt,
                                lineJoin: .miter,
                                dash: self.dashSettings))
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: 135))
                .padding()
                .allowsHitTesting(false)
            
            Text("\(Int(self.currentValue.rounded()))")
        }
    }
}

struct RadicalGauge_Previews: PreviewProvider {
    static var previews: some View {
        RadicalGauge(
            currentValue: 25,
            minValue: 0,
            maxValue: 100.0
        )
    }
}
