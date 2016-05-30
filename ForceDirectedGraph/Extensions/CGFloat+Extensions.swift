//
//  CGFloat+Extensions.swift
//  ForceDirectedGraph
//
//  Created by Fredrik Sjöberg on 30/05/16.
//  Copyright © 2016 FredrikSjoberg. All rights reserved.
//

import Foundation

extension CGFloat {
    public func clamp(min: CGFloat, _ max: CGFloat) -> CGFloat {
        return Swift.max(min, Swift.min(max, self))
    }
}