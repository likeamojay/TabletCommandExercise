//
//  TopLeadingCornerTriangle.swift
//  TabletCommandExercise
//
//  Created by James on 12/11/25.
//

import SwiftUI

struct TopLeadingCornerTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
