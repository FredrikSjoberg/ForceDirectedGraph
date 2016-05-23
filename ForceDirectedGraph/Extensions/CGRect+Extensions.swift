//
//  CGRect+Extensions.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 19/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    var midpoint: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    var nw: CGRect {
        return CGRect(
            x: origin.x,
            y: origin.y+size.height/2,
            width: size.width/2,
            height: size.height/2)
    }
    
    var ne: CGRect {
        return CGRect(
            x: origin.x+size.width/2,
            y: origin.y+size.height/2,
            width: size.width/2,
            height: size.height/2)
    }
    
    var sw: CGRect {
        return CGRect(
            x: origin.x,
            y: origin.y,
            width: size.width/2,
            height: size.height/2)
    }
    
    var se: CGRect {
        return CGRect(
            x: origin.x+size.width/2,
            y: origin.y,
            width: size.width/2,
            height: size.height/2)
    }
    
    var subdivide: [CGRect] {
        return [nw, ne, sw, se]
    }
}