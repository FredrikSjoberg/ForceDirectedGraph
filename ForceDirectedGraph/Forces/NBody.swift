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
    private(set) public var repulsion: CGFloat = -30
    public func repuslion(value: CGFloat) -> NBody {
        repulsion = value
        return self
    }
    
    private(set) public var minDistance: (Node) -> CGFloat = { _ in 1 }
    public func minDistance(value: CGFloat) -> NBody {
        // TODO: enforce no negative values
        minDistance = { _ in value }
        return self
    }
    public func minDistance(closure: (Node) -> CGFloat) -> NBody {
        minDistance = closure
        return self
    }
    
    private(set) public var maxDistance: ((Node) -> CGFloat)? = nil
    public func maxDistance(value: CGFloat) -> NBody {
        // TODO: enforce no negative values
        maxDistance = { _ in value }
        return self
    }
    public func maxDistance(closure: ((Node) -> CGFloat)?) -> NBody {
        maxDistance = closure
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
//        func updateForce(node: Node, direction)
        
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
                    
                    if distance > minDistance(node) {
                        if let max = maxDistance {
                            if distance < max(node) {
                                node.force = node.force + direction * repulsion / (distance * distance * 0.5)
                            }
                        }
                        else {
                            node.force = node.force + direction * repulsion / (distance * distance * 0.5)
                        }
                    }
                }
            }
        }
        else {
            // Far away quad
            let dq = quad.center - node.position
            let distance = dq.magnitude
            let direction = dq.normalized
            if let max = maxDistance {
                if distance < max(node) {
                    node.force = node.force + direction * repulsion * CGFloat(quad.count) / (distance * distance * 0.5)
                }
            }
            else {
                node.force = node.force + direction * repulsion * CGFloat(quad.count) / (distance * distance * 0.5)
            }
        }
    }
}