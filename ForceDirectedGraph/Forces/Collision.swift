//
//  Collision.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 29/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation

public class Collision: Force {
    public init() { }
    
    private(set) public var radius: (Node) -> CGFloat = { $0.radius }
    public func radius(closure: ((Node) -> CGFloat)) -> Collision {
        radius = closure
        return self
    }
    
    private(set) public var strength: (Node) -> CGFloat = { _ in 0.4 }
    public func strength(closure: ((Node) -> CGFloat)) -> Collision {
        strength = closure
        return self
    }
    
    
    public func apply(nodes: [Node], edges: [Edge], bounds: CGRect) {
        nodes.forEach{ orig in
            nodes.forEach{ targ in
                if orig != targ {
                    let r = radius(orig) + radius(targ)
                    let db = (orig.position + orig.velocity - targ.position - targ.velocity)
                    let distance = db.magnitude
                    let direction = db.normalized
                    if distance < r {
                        let l = (r - distance)/(distance)// * distance)
                        let k = (targ.radius * targ.radius) / (orig.radius + targ.radius)
                        orig.velocity = orig.velocity + direction * l * k * strength(orig)
                        
                    }
                }
            }
        }
    }
}