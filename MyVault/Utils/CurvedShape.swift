//
//  CurvedShape.swift
//  MyVault
//
//  Created by Mudara on 2023-09-26.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) -> some View {
        clipShape(CurvedShape(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight))
    }
}

struct CurvedShape: Shape {
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topRightRadius = min(topRight, rect.width / 2, rect.height / 2)
        let topLeftRadius = min(topLeft, rect.width / 2, rect.height / 2)
        let bottomLeftRadius = min(bottomLeft, rect.width / 2, rect.height / 2)
        let bottomRightRadius = min(bottomRight, rect.width / 2, rect.height / 2)
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        
        path.addArc(center: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius), radius: topLeftRadius, startAngle: Angle.degrees(180), endAngle: Angle.degrees(270), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        
        path.addArc(center: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius), radius: topRightRadius, startAngle: Angle.degrees(270), endAngle: Angle.degrees(0), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        
        path.addArc(center: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius), radius: bottomRightRadius, startAngle: Angle.degrees(0), endAngle: Angle.degrees(90), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        
        path.addArc(center: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius), radius: bottomLeftRadius, startAngle: Angle.degrees(90), endAngle: Angle.degrees(180), clockwise: false)
        
        return path
    }
}
