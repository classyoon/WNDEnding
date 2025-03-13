//
//  Coord.swift
//  BoardGame
//
//  Created by Tim Yoon on 11/27/22.
//

import Foundation
import SwiftUI

struct Coord: Equatable, Hashable {
    var row: Int = 0
    var col: Int = 0
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    init(row: Int) {
        self.row = row
        self.col = 0
    }
    init(col: Int) {
        self.row = 0
        self.col = col
    }
    init() {
        self.row = 0
        self.col = 0
    }
}


typealias Vector = Coord

func +(lhs: Coord, rhs: Coord) -> Coord {
    let r = lhs.row + rhs.row
    let c = lhs.col + rhs.col
    return Coord(row: r, col: c)
}
