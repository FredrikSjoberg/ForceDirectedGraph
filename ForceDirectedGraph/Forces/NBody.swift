//
//  NBody.swift
//  GraphSK
//
//  Created by Fredrik Sjöberg on 23/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

public class NBody: Force {
    private(set) public var repulsion: CGFloat = -1.2
    public func repuslion(value: CGFloat) -> NBody {
        repulsion = value
        return self
    }
    
    /// Range of [0,1]
    private(set) public var theta: CGFloat = 0.8
    public func theta(value: CGFloat) -> NBody {
        // TODO: Enforce range
        theta = value
        return self
    }
    
    public init() { }
    
    public func apply(nodes: [Node], edges: [Edge], bounds: CGRect) {
        computeBarnesHut(nodes, bounds: bounds)
    }
}

extension NBody {
    private func computeBarnesHut(nodes: [Node], bounds: CGRect) {
        let bodies = nodes.map{ Body(position: $0.position, data: $0) }
        let quadtree = QuadTree(bounds: bounds, bodies: bodies)
        
        nodes.forEach{ applyBarnesHut($0, quad: quadtree.root) }
    }
    
    private func applyBarnesHut(node: Node, quad: Quad<Node>) {
        let s = (quad.bounds.width + quad.bounds.height)/2
        let d = (quad.center - node.position).magnitude
        
        if s/d > theta {
            // Nearby Quad
            if let children = quad.children {
                children.forEach{ applyBarnesHut(node, quad: $0) }
            }
            else if let body = quad.body {
                if body.data != node {
                    let db = body.position - node.position
                    let distance = db.magnitude
                    let direction = db.normalized
                    
                    node.force = node.force + direction * repulsion / (distance * distance * 0.5)
                }
            }
        }
        else {
            // Far away quad
            let dq = quad.center - node.position
            let distance = dq.magnitude
            let direction = dq.normalized
            node.force = node.force + direction * repulsion * CGFloat(quad.count) / (distance * distance * 0.5)
        }
    }
}