//
//  CGPoint+Extensions.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGPoint {
    public var magnitude: CGFloat {
        return sqrt(x*x + y*y)
    }
    
    public var normalized: CGPoint {
        return self / magnitude
    }
    
    public func randomize(value: CGFloat) -> CGPoint {
        return CGPoint(x: x + CGFloat(drand48()) * value - value / 2 , y: y + CGFloat(drand48()) * value - value / 2)
    }
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x-rhs.x, y: lhs.y-rhs.y)
}

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
}

public func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x*rhs, y: lhs.y*rhs)
}

public func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x/rhs, y: lhs.y/rhs)
}