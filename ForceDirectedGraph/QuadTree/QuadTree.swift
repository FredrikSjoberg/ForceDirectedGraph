//
//  QuadTree.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

class Body<T> {
    let position: CGPoint
    let data: T
    
    init(position: CGPoint, data: T) {
        self.position = position
        self.data = data
    }
}

class Quad<T> {
    let bounds: CGRect
    let center: CGPoint
    
    var body: Body<T>?
    var children: [Quad<T>]?
    
    let count: Int
    
    init(bounds: CGRect, center: CGPoint, num: Int, body: Body<T>? = nil, children: [Quad<T>]? = nil) {
        self.bounds = bounds
        self.center = center
        self.body = body
        self.children = children
        self.count = num
    }
}

class QuadTree<T> {
    let root: Quad<T>
    
    init(bounds: CGRect, bodies: [Body<T>]) {
        root = configure(bounds, bodies: bodies)
    }
}

private func configure<T>(bounds: CGRect, bodies: [Body<T>]) -> Quad<T> {
    if bodies.isEmpty {
        return Quad(bounds: bounds, center: bounds.midpoint, num: 0)
    }
    else if bodies.count == 1 {
        return Quad(bounds: bounds, center: bodies.first!.position, num: 1, body: bodies.first!)
    }
    else {
        let children = bounds.subdivide.map{ subBounds -> Quad<T> in
            let clipped = bodies.filter{ subBounds.contains($0.position) }
            return configure(subBounds, bodies: clipped)
        }
        
        let location = bodies.reduce(CGPointZero){ $0 + $1.position } / CGFloat(bodies.count)
        
        return Quad(bounds: bounds, center: location, num: bodies.count, children: children)
    }
}