//
//  Graph.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

class Graph {
    
    private(set) var centerOfGravity: CGFloat = -1e-4
    func centerOfGravity(value: CGFloat) -> Graph {
        centerOfGravity = value
        return self
    }
    
    private(set) var drag: CGFloat = -0.02
    func drag(value: CGFloat) -> Graph {
        drag = value
        return self
    }
    
    private(set) var timeStep: Int = 20
    func timeStep(value: Int) -> Graph {
        timeStep = value
        return self
    }
    
    private(set) var maxVelocity: CGFloat = 1
    func maxVelocity(value: CGFloat) -> Graph {
        maxVelocity = value
        return self
    }
    
    private(set) var centerOn: CGPoint = CGPointZero
    func centerOn(value: CGPoint) -> Graph {
        centerOn = value
        return self
    }
    
    private var needsUpdate: Bool = false
    
    var bounds: CGRect {
        guard self.nodes.count > 0 else { return CGRectZero }
        let xSort = self.nodes.sort{ $0.position.x < $1.position.x }
        let ySort = self.nodes.sort{ $0.position.y < $1.position.y }
        let xMin = xSort.first!.position.x
        let xMax = xSort.last!.position.x
        let yMin = ySort.first!.position.y
        let yMax = ySort.last!.position.y
        return CGRect(x: xMin, y: yMin, width: xMax-xMin, height: yMax-yMin)
    }
    
    let nodes: [Node]
    let edges: [Edge]
    private(set) var forces: [String: Force] = [:]
    init(nodes: [Node], edges: [Edge]) {
        self.nodes = nodes
        self.edges = edges
    }
    
    
    func force(name: String, force: Force?) -> Graph {
        forces[name] = force
        return self
    }
    
    func force(name: String, closure: () -> (Force)) -> Graph {
        let force = closure()
        forces[name] = force
        return self
    }
}

extension Graph {
    func update(closure: ([Node] -> ())) {
        if totalEnergy() > 0.001 {
            step()
            closure(nodes)
        }
        else if needsUpdate {
            step()
            closure(nodes)
            needsUpdate = false
        }
    }
    
    func fix(node: Node, position: CGPoint) -> Graph {
        // TODO: Check that 'nodes' contains 'node'
        node.fix(position)
        needsUpdate = true
        return self
    }
    
    func unfix(node: Node) -> Graph {
        // TODO: Check that 'nodes' contains 'node'
        node.unfix()
        needsUpdate = true
        return self
    }
    
    private func totalEnergy() -> CGFloat {
        return nodes.reduce(0) { (sum, node) -> CGFloat in
            let v = node.velocity.magnitude
            return sum + 0.5 * node.mass * v * v
        }
    }
}

extension Graph {
    func step() {
        forces.values.forEach{ $0.apply(nodes, edges: edges, bounds: bounds) }
        
        computeCenter(nodes)
        computeDrag(nodes)
        computeGravity(nodes)
        
        nodes.forEach{
            let acceleration = $0.force / $0.mass
            $0.force = CGPointZero
            $0.velocity = $0.velocity + acceleration * CGFloat(timeStep)
            if $0.velocity.magnitude > maxVelocity {
                $0.velocity = $0.velocity.normalized * maxVelocity
            }
            
            $0.position = $0.position + $0.velocity * CGFloat(timeStep)
        }
    }
    
    private func computeDrag(nodes: [Node]) {
        nodes.forEach{ $0.force = $0.force + $0.velocity * drag }
    }
    
    private func computeGravity(nodes: [Node]) {
        nodes.forEach{ $0.force = $0.force + $0.position.normalized * centerOfGravity * $0.mass }
    }
    
    private func computeCenter(nodes: [Node]) {
        let center = nodes.reduce(CGPointZero){ $0 + $1.position } / CGFloat(nodes.count) - centerOn
        nodes.forEach{ $0.position = $0.position - center }
    }
}