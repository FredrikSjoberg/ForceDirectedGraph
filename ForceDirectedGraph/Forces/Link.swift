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
    
    private(set) public var springLength: CGFloat = 50
    public func springLength(value: CGFloat) -> Link {
        springLength = value
        return self
    }
    
    private(set) public var springCoefficient: CGFloat = 0.0002
    public func springCoefficient(value: CGFloat) -> Link {
        springCoefficient = value
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
            
            let displacement = d.magnitude - springLength / $0.weight
            let coeff = springCoefficient * displacement / d.magnitude
            let force = d * coeff * 0.5
            
            $0.from.force = $0.from.force + force
            $0.to.force = $0.to.force - force
        }
    }
}