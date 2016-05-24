//
//  Link.swift
//  GraphSK
//
//  Created by Fredrik Sjöberg on 23/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

public class Link: Force {
    
    private(set) public var springLength: (Edge) -> CGFloat = { _ in 50 }
    public func springLength(value: CGFloat) -> Link {
        springLength = { _ in value }
        return self
    }
    
    public func springLength(closure: (Edge) -> CGFloat) -> Link {
        springLength = closure
        return self
    }
    
    
    private(set) public var springCoefficient: (Edge) -> CGFloat = { _ in 0.0002 }
    public func springCoefficient(value: CGFloat) -> Link {
        springCoefficient = { _ in value }
        return self
    }
    public func springCoefficient(closure: (Edge) -> CGFloat) -> Link {
        springCoefficient = closure
        return self
    }
    
    public init() { }
    
    public func apply(nodes: [Node], edges: [Edge], bounds: CGRect) {
        computeHookesLaw(edges)
    }
}

extension Link {
    private func computeHookesLaw(edges: [Edge]) {
        edges.forEach{
            let d = ($0.to.position == $0.from.position) ? $0.from.position.randomize(0.1) : $0.to.position - $0.from.position
            
            let displacement = d.magnitude - springLength($0) / $0.weight
            let coeff = springCoefficient($0) * displacement / d.magnitude
            let force = d * coeff * 0.5
            
            $0.from.force = $0.from.force + force
            $0.to.force = $0.to.force - force
        }
    }
}