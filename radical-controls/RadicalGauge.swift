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
    private let dashSettings: [CGFloat] = [5, 8]
    
    @State var currentValue:CGFloat
    var minValue:CGFloat
    var maxValue:CGFloat
    
    
    fileprivate func createGesture() -> some Gesture {
        // Initially tried using a Geometryreader but the frame was bigger than expecetd. So hardcoded width/heights until I can figure a better way
        return DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged{ value in
                let x = value.location.x - 300 * 0.5
                let y = (value.location.y  - 300 * 0.5) * -1
                var angle = atan2(y, x) * 180.0 / CGFloat.pi
                
                if(angle < 0) {
                    angle += 360
                }
                
                if( angle < 230){
                    angle = 225 - angle
                } else {
                    angle = 225 + 360 - angle
                }
                
                let updatedValue = self.maxValue * (angle / 270.0)
                self.currentValue = min(updatedValue, self.maxValue)
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center, spacing: 0){
                // Padding is important here. As we can't use strokeborder due to the use of trim, we need ot push the stroke inside the frame by padding the circle by half the stroke width
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(ColorManager.emptyGauge,
                              style: StrokeStyle(
                                  lineWidth: self.indicatorLength,
                                  lineCap: .butt,
                                  lineJoin: .miter,
                                  dash: self.dashSettings))
                   
                    .rotationEffect(Angle(degrees: 135))
                    .gesture(self.createGesture())
                    .frame(minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: 300)
                    .padding(self.indicatorLength / 2)
            }
            
            // Rounded on trim to cover a bug where the rounded value would go to the max, but the trim was showing some inactive
            Circle()
                .trim(from: 0, to: currentValue.rounded() / maxValue * 0.75)
                .stroke(LinearGradient(gradient: Gradient(colors: [
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
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: 135))
                .padding(self.indicatorLength / 2)
                .allowsHitTesting(false)
                .animation(.easeIn(duration: 0.5))
            
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
