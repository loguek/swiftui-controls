//
//  RadicalGauge.swift
//  radical-controls
//
//  Created by Kevin Logue on 25/05/2020.
//  Copyright © 2020 Kevin Logue. All rights reserved.
//

import SwiftUI

struct GaugeShape: Shape {
    var thickness:CGFloat = 20
    var startAngle:Angle
    var endAngle:Angle
    
    var animatableData: Double {
        get { self.endAngle.degrees }
        set { self.endAngle = Angle(degrees: newValue) }
    }
    
  func path(in rect: CGRect) -> Path {
    var p = Path()
    let minLength = min(rect.size.width, rect.size.height)
    
    
    let cen =  CGPoint(x: rect.size.width/2, y: rect.size.height/2)
    let r0 = minLength / 2 - self.thickness
    let r1 = minLength / 2
    p.addArc(center: cen, radius: r0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
    p.addArc(center: cen, radius: r1, startAngle: endAngle, endAngle: startAngle, clockwise: true)
    p.closeSubpath()
    return p
  }
}

struct RadicalGauge: View {
    private let indicatorLength: CGFloat = 30
    private let dashSettings: [CGFloat] = [7, 7]
    
    @State private var endAngleDegrees:Double = 135
    
    @State var currentValue:CGFloat
    var minValue:CGFloat
    var maxValue:CGFloat
    
    fileprivate func createGesture(_ geometry: GeometryProxy) -> some Gesture {
        let frame = geometry.frame(in: .local)
        return DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged{ value in
                let x = value.location.x - frame.width * 0.5
                let y = (value.location.y  - frame.height * 0.5) * -1
                var angle = atan2(y, x) * 180.0 / CGFloat.pi
                
                if(angle < 0) {
                    angle += 360
                }
                
                if( angle <= 230){
                    angle = 225 - angle
                } else if angle <= 310 {
                    return
                } else {
                    angle = 225 + 360 - angle
                }
                
                let updatedValue = self.maxValue * (angle / 270.0)
                self.currentValue = max(self.minValue, min(updatedValue, self.maxValue))
                self.updateAngle()
        }
    }
    
    fileprivate func updateAngle() {
        self.endAngleDegrees = (Double.init(self.currentValue / self.maxValue) * 0.75 * 360) + 135
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center, spacing: 0){
                GeometryReader { geometry in
                    Circle()
                        .strokeBorder(ColorManager.emptyGauge,
                                  style: StrokeStyle(
                                      lineWidth: self.indicatorLength,
                                      lineCap: .butt,
                                      lineJoin: .miter,
                                      dash: self.dashSettings))
                        .rotationEffect(Angle(degrees: 90))
                        .mask(GaugeShape(
                            thickness: self.indicatorLength,
                            startAngle: Angle(degrees: 135),
                            endAngle: Angle(degrees: 45)
                        ))
                        .gesture(self.createGesture(geometry))
                }.overlay(
                    Circle()
                     .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        ColorManager.activeGauge1,
                        ColorManager.activeGauge2])
                        ,
                                           startPoint: .topTrailing,
                                           endPoint: .bottomTrailing),
                                style: StrokeStyle(
                                    lineWidth: self.indicatorLength,
                                    lineCap: .butt,
                                    lineJoin: .miter,
                                    dash: self.dashSettings))
                    .rotationEffect(Angle(degrees: 90))
                    .mask(GaugeShape(
                        thickness: self.indicatorLength,
                        startAngle: Angle(degrees: 135),
                        endAngle: Angle(degrees: self.endAngleDegrees)
                    ).animation(.easeIn(duration: 0.5)))
                    .allowsHitTesting(false)
                    
                )
            }
            
            Text("\(Int(self.currentValue.rounded()))")
        }.onAppear {
            self.updateAngle()
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
