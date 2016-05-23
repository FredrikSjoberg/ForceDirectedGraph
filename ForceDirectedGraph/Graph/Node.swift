//
//  Node.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

class Node: Equatable {
    let index: Int
    var mass: CGFloat
    private var fixedPoint: CGPoint?
    var fixed: Bool {
        return fixedPoint != nil
    }
    
    var links: [Edge] = [] {
        didSet {
            mass = mass * CGFloat(1 + links.count / 3)
        }
    }
    
    init(index: Int, mass: CGFloat = 1) {
        self.index = index
        self.mass = mass
    }
    
    var position: CGPoint = CGPoint(x: CGFloat(drand48()), y: CGFloat(drand48()))
    var velocity: CGPoint = CGPointZero
    var force: CGPoint = CGPointZero
    
    func fix() {
        fixedPoint = position
    }
    
    func fix(point: CGPoint) {
        fixedPoint = point
        position = point
    }
    
    func unfix() {
        guard fixed else { return }
        position = fixedPoint!
        fixedPoint = nil
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        return "Index:\(index), pos: \(position), velocity:\(velocity), force: \(force)"
    }
}

func == (lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs
}