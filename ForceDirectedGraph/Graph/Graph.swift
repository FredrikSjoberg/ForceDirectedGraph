//
//  Graph.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

public class Graph {
    
    private(set) public var centerOfGravity: CGFloat = -1e-4
    public func centerOfGravity(value: CGFloat) -> Graph {
        centerOfGravity = value
        return self
    }
    
    private(set) public var drag: CGFloat = -0.04
    public func drag(value: CGFloat) -> Graph {
        drag = value
        return self
    }
    
    private(set) public var timeStep: Int = 20
    public func timeStep(value: Int) -> Graph {
        timeStep = value
        return self
    }
    
    private(set) public var energyThreshold: CGFloat = 0.01
    public func energyThreshold(value: CGFloat) -> Graph {
        energyThreshold = value
        return self
    }
    
    private(set) public var maxVelocity: CGFloat = 1
    public func maxVelocity(value: CGFloat) -> Graph {
        maxVelocity = value
        return self
    }
    
    private(set) public var centerOn: CGPoint = CGPointZero
    public func centerOn(value: CGPoint) -> Graph {
        centerOn = value
        return self
    }
    
    public var bounds: CGRect {
        guard self.nodes.count > 0 else { return CGRectZero }
        let xSort = self.nodes.sort{ $0.position.x < $1.position.x }
        let ySort = self.nodes.sort{ $0.position.y < $1.position.y }
        let xMin = xSort.first!.position.x
        let xMax = xSort.last!.position.x
        let yMin = ySort.first!.position.y
        let yMax = ySort.last!.position.y
        return CGRect(x: xMin, y: yMin, width: xMax-xMin, height: yMax-yMin)
    }
    
    // MARK: Nodes
    private(set) public var nodes: [Node]
    public func add(node: Node) {
        nodes.append(node)
        needsUpdate = true
    }
    public func add(nodes: [Node]) {
        self.nodes.appendContentsOf(nodes)
        needsUpdate = true
    }
    public func remove(node: Node) {
        guard let index = nodes.indexOf(node) else { return }
        nodes.removeAtIndex(index)
        needsUpdate = true
    }
    public func remove(nodes: [Node]) {
        // TODO: Better to do this in one swoop (set.subtract?)
        nodes.forEach{ remove($0) }
    }
    
    // MARK: Edges
    public let edges: [Edge]
    
    // MARK: Forces
    private(set) public var forces: [String: Force] = [:]
    public func force(name: String, force: Force?) -> Graph {
        forces[name] = force
        return self
    }
    
    public func force(name: String, closure: () -> (Force)) -> Graph {
        let force = closure()
        forces[name] = force
        return self
    }
    
    public init(nodes: [Node], edges: [Edge]) {
        self.nodes = nodes
        self.edges = edges
    }
    
    public init(nodes: Int, edges: [Int: Int]) {
        let vertices = (0..<nodes).map{ _ in Node() }
        self.nodes = vertices
        self.edges = edges.map{ Edge(to: vertices[$0.0], from: vertices[$0.1]) }
    }
    
    
    private var needsUpdate: Bool = false
}

extension Graph {
}

extension Graph {
    public func update(closure: ([Node] -> ())) {
        if totalEnergy() > energyThreshold {
            step()
            closure(nodes)
        }
        else if needsUpdate {
            step()
            closure(nodes)
            needsUpdate = false
        }
    }
    
    private func totalEnergy() -> CGFloat {
        return nodes.reduce(0) { (sum, node) -> CGFloat in
            let v = node.velocity.magnitude
            return sum + 0.5 * node.mass * v * v
        }
    }
    
    public func fix(node: Node, position: CGPoint) -> Graph {
        // TODO: Check that 'nodes' contains 'node'
        node.fix(position)
        needsUpdate = true
        return self
    }
    
    public func unfix(node: Node) -> Graph {
        // TODO: Check that 'nodes' contains 'node'
        node.unfix()
        return self
    }
    
}

extension Graph {
    public func step() {
        forces.values.forEach{ $0.apply(nodes, edges: edges, bounds: bounds) }
        
        computeCenter(nodes)
        computeDrag(nodes)
        computeGravity(nodes)
        
        nodes.forEach{
            if !$0.fixed {
                let acceleration = $0.force / $0.mass
                $0.force = CGPointZero
                $0.velocity = $0.velocity + acceleration * CGFloat(timeStep)
                if $0.velocity.magnitude > maxVelocity {
                    $0.velocity = $0.velocity.normalized * maxVelocity
                }
                
                $0.position = $0.position + $0.velocity * CGFloat(timeStep)
            }
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
        nodes.forEach{
            if !$0.fixed { $0.position = $0.position - center }
        }
    }
}