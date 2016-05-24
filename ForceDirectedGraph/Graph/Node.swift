//
//  Node.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

public class Node: Equatable {
    public var mass: CGFloat
    private var fixedPoint: CGPoint?
    public var fixed: Bool {
        return fixedPoint != nil
    }
    
    internal(set) public var links: [Edge] = [] {
        didSet {
            mass = mass * CGFloat(1 + links.count / 3)
        }
    }
    
    public init(mass: CGFloat = 1) {
        self.mass = mass
    }
    
    public var position: CGPoint = CGPoint(x: CGFloat(drand48()), y: CGFloat(drand48()))
    public var velocity: CGPoint = CGPointZero
    public var force: CGPoint = CGPointZero
    
    public func fix() {
        fixedPoint = position
    }
    
    public func fix(point: CGPoint) {
        fixedPoint = point
        position = point
    }
    
    public func unfix() {
        guard fixed else { return }
        position = fixedPoint!
        fixedPoint = nil
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        return "Index:\(index), pos: \(position), velocity:\(velocity), force: \(force)"
    }
}

public func == (lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs
}