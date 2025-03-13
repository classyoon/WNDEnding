//
//  Tile.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 12/19/22.
//

import SwiftUI

//Current
/*
 You distinguish tiles like so example :  board.terrainBoard[row][col].name=="z"
 */
struct TileData {
    var name = "g"
    
    var loot = Int.random(in: 0...1)
    var rawMaterials = 0
    
    var movePenalty = 0
    var damageProtection = 0
    var providesConcealment = false

    mutating func setTileBonuses(){
        let houseLoot = Int.random(in: 3...4)
        let houseMaterials = Int.random(in: 0...2)
    
        let forestMovePenalty = 1
        let forestMaterials = 2
        let forestLoot = Int.random(in: 0...1)
    
        let waterMovePenalty = 1
        let waterLoot = Int.random(in: 4...6)
        
        switch name {
        case "h"://Building
            loot += houseLoot
            rawMaterials += houseMaterials
            movePenalty = 0
        case "t" ://Forest
            rawMaterials+=forestMaterials
            loot += forestLoot
            movePenalty+=forestMovePenalty
            providesConcealment = true
        case "w"://Water
            movePenalty += waterMovePenalty
            loot += waterLoot
        case "p"://Player concealed starting point
            providesConcealment = true
        case "b"://Battlements
            damageProtection = 2
        case "z"://Hidden zombie spawn point
            movePenalty = 1 //Ideally keeps zombies from walking back on and blocking the point.
        default ://Default
            _ = 0
        }
    }
}
//Proposed
protocol Tilable {
    var food : Int {get set}
    var rawMaterials : Int {get set}
    var movePenalty : Int {get set}
    var damageProtection : Int {get set}
    var providesConcealment : Bool {get set}
}

struct Grass : Tilable {
    
    var food = Int.random(in: 0...1)
    
    var rawMaterials: Int = 0
    
    var movePenalty: Int = 0
    
    var damageProtection: Int = 0
    
    var providesConcealment: Bool = false
    
}

struct Water : Tilable {
    
    var food = Int.random(in: 4...6)
    
    var rawMaterials: Int = 0
    
    var movePenalty: Int = 1
    
    var damageProtection: Int = 0
    
    var providesConcealment: Bool = false
    
}



struct TileView: View {
    var image: String
    var difference = 1.0
    var tileLocation: Coord
    var image2: String = ""
    var optionalColor = Color.clear
    @ViewBuilder
    var body: some View {
        ZStack{
            Rectangle()
                .fill(optionalColor)
                .border(Color.white, width: difference)
            Image(image)
                .resizable()
                .padding(difference)
            image2 != "" ? Image(image2).resizable() : nil
        }
    }
}
struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            VStack{
                ForEach(0..<3, id: \.self) { row in
                    HStack{
                        ForEach(0..<3, id: \.self) { col in
                            TileView(image: "building", tileLocation: Coord()).frame(width: 100.0, height: 100.0).padding(0)
                        }
                    }
                }
            }
        }
    }
}
