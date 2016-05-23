//
//  Force.swift
//  GraphSK
//
//  Created by Fredrik Sjöberg on 23/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation
import CoreGraphics


public protocol Force {
    func apply(nodes: [Node], edges: [Edge], bounds: CGRect)
}