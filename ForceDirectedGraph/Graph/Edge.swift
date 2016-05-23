//
//  Edge.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

class Edge {
    let weight: CGFloat
    unowned let to: Node
    unowned let from: Node
    
    init(to: Node, from: Node, weight: CGFloat = 1) {
        self.to = to
        self.from = from
        self.weight = weight
        to.links.append(self)
        from.links.append(self)
    }
}