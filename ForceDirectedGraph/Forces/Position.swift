//
//  Position.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 29/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation

public class Position: Force {
    public init() { }
    
    private(set) public var strength: (Node) -> CGFloat = { _ in 0.1 }
    public func strength(closure: (Node) -> CGFloat) -> Position {
        strength = closure
        return self
    }
    
    private(set) public var location: (Node) -> CGPoint = { _ in CGPoint.zero }
    public func location(closure: ((Node) -> CGPoint)) -> Position {
        location = closure
        return self
    }
    
    private(set) public var alpha: CGFloat = 1
    public func alpha(value: CGFloat) -> Position {
        alpha = value
        return self
    }
    
    public func apply(nodes: [Node], edges: [Edge], bounds: CGRect) {
        if alpha > 0.001 {
            nodes.forEach{
                let v = location($0) - $0.position
                $0.velocity = $0.velocity + v * strength($0) * alpha
            }
            alpha += (0 - alpha) * (1 - pow(0.001, 1/300))
        }
    }
}