//
//  Edge.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

public class Edge {
    public let weight: CGFloat
    public unowned let to: Node
    public unowned let from: Node
    
    public init(to: Node, from: Node, weight: CGFloat = 1) {
        self.to = to
        self.from = from
        self.weight = weight
        to.links.append(self)
        from.links.append(self)
    }
}