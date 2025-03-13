//
//  Stockpile.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 9/20/23.
//

import Foundation
class Stockpile : ObservableObject {
    @Published var stockpileData : StockpileModel
    var buildingMan = BuildingManager.shared
    static let shared = Stockpile()
    var key = "stocks"
    private init() {
        self.stockpileData = load(key: key) ?? StockpileModel()
    }
    func selfSave(){
        save(items: stockpileData, key: key)
    }
    func reset(){
        stockpileData.reset()
    }
    func hardModeReset(){
        stockpileData.hardModeReset()
    }
    func runDaily(){
        stockpileData.calcConsumption()
        stockpileData.updateGraveYard()
        SurvivorDirector.shared.printSurvivorsAndLocations()
        selfSave()
    }
    func update(){
        for survivor in stockpileData.rosterOfSurvivors {
            if survivor.location == .inMission(false) {
                send(survivor, to: .inCamp)
            }
        }
    }

    //MARK: Helpers
    
    func runOutOfPeople()->Bool{
        return stockpileData.runOutOfPeople()
    }
    func isStarving()->Bool{
        return stockpileData.starving
    }
    
    func getNumOfPeople()->Int{
        return stockpileData.rosterOfSurvivors.count
    }
    func getNumOfFood()->Int{
        return stockpileData.foodStored
    }
    func getNumOfMat()->Int{
        return stockpileData.buildingResources
    }
    func getSurvivorSent()->Int{
        return stockpileData.survivorSent
    }
    func getRosterOfSurvivors()->[Soul] {
        return stockpileData.rosterOfSurvivors
    }
    func swapAlike(_ new : Soul){
        setSurvivorAtIndex(index: getSurvivorIndex(id: new.id), survivor: new)
    }
    func swapAlikeIn(_ new : Soul, list : [Soul]){
        setSurvivorAtIndex(index: getSurvivorIndex(id: new.id), survivor: new)
    }
    
    func getAllLivingSurvivorsInCamp()->[Soul] {
        return stockpileData.getAllLivingSurvivorsInCamp()
    }
    func getAllLivingSurvivorsInBuildings(outside : any Buildable)->[Soul] {
        return stockpileData.getAllLivingSurvivorsInBuildings(outside: outside)
    }
    func setSurvivorRoster(newList : [Soul]){
        stockpileData.setSurvivors(newList)
    }
    func getNonBuilders()->[Soul] {
        var list = [Soul]()
        for survivor in stockpileData.rosterOfSurvivors {
            if survivor.location == .inCamp {
                list.append(survivor)
            }
        }
        return list
    }
    func addSurvivors(survivors : [Soul]){
        stockpileData.addSurvivors(survivors: survivors)
    }
    func addSurvivor(survivor : Soul){
        stockpileData.addSurvivors(survivors: [survivor])
    }
    func addResource(_ value: Int, for type: ResourceType) {
        stockpileData.addResource(value, for: type)
    }
    func swapPlacesOfSurvivors(selectedSurvivorInSpot: Soul, insideBuild: Soul){
        stockpileData.swapPlacesOfSurvivors(selectedSurvivorInSpot: selectedSurvivorInSpot, insideBuild: insideBuild)
    }
    func lastSurvivor()->Bool{
        if stockpileData.getSurvivors(who: [.alive]).count == 1 {
            return true
        }
        return false
    }
    func getAllSurvivorsAliveEverywhere()->[Soul]{
        return stockpileData.getSurvivors(who: [.alive])
    }
    func getAllSurvivorsInVan()->[Soul]{
        return stockpileData.getAllLivingSurvivorsInVan()
    }
    func getAllRecentDead()->[Soul]{
        return stockpileData.getSurvivors(who: [.dead])
    }
  
    func getWorkers(from id: BuildingID) -> [Soul] {
        return stockpileData.getWorkers(in: id)
    }
    func unloadWorkers(in id: BuildingID){
        for var survivor in stockpileData.getWorkers(in: id){
            survivor.location = .inCamp
            setSurvivorAtIndex(index: getSurvivorIndex(id: survivor.id), survivor: survivor)
        }
    }
    func setSurvivorAtIndex(index : Int, survivor : Soul){
        stockpileData.setSurvivorAtIndex(index: index, suvivor: survivor)
    }
    func send(_ survivor : Soul, to : Place){
        var alteredSurvivor = survivor
        alteredSurvivor.location = to
        setSurvivorAtIndex(index: getSurvivorIndex(id: survivor.id), survivor: alteredSurvivor)
    }
    
    func getSurvivorIndex(id : UUID)->Int{
        return stockpileData.getSurvivorIndex(id: id)
    }
    func transportSurvivorsOnVan() -> [Soul] {
        return VanLoaderManager.shared.transportSurvivorsOnVan()
    }
}
struct StockpileModel : Codable, Identifiable {
    var id = UUID()
    var foodStored : Int = 10
    var buildingResources : Int = 10

    var graveyard: [Soul] = []
    var rosterOfSurvivors : [Soul] = []
    mutating func addSurvivors(survivors : [Soul]){
        rosterOfSurvivors.append(contentsOf: survivors)
    }
    mutating func addResource(_ value: Int, for type: ResourceType) {
        switch type {
        case .food:
            foodStored += value
        case .material:
            buildingResources += value
        case .people:
                SurvivorGenerator.shared.addSurvivors(value)
        }
    }
 
    mutating func updateGraveYard(){
        for survivor in rosterOfSurvivors {
            if survivor.livingStatus == .dead {
                graveyard.append(survivor)
                rosterOfSurvivors.remove(at: getSurvivorIndex(id: survivor.id))
            }
        }
    }
    
    var survivorSent : Int {
        var count = 0
        for survivor in rosterOfSurvivors {
            if survivor.location == .inVan {
                count+=1
            }
        }
        return count
    }

    var starving : Bool {
        return foodStored==0 ? true : false
    }
    func getSurvivorIndex(id : UUID)->Int{
        var index = 0
        for survivor in rosterOfSurvivors {
            if survivor.id == id {
                return index
            }
            index += 1
        }
        print("Could not find the survivor that belonged to \(id)")
        return 0
    }
    mutating func setSurvivorAtIndex(index : Int, suvivor : Soul){
        print("StockpileModel: Setting the index of survivor \(suvivor.name) to index \(index), the number of spaces in the rosterOfSurvivors is \(rosterOfSurvivors.count)")
        rosterOfSurvivors[index] = suvivor
    }
    mutating func reset(){
        foodStored = 10
        buildingResources = 10
        rosterOfSurvivors = SurvivorGenerator.shared.generateSurvivors(3)
    }
    mutating func hardModeReset(){
        foodStored = 0
        buildingResources = 0
        rosterOfSurvivors = SurvivorGenerator.shared.generateSurvivors(1)
    }
    func getSurvivors(where locations: [Place]) -> [Soul] {
        return Stockpile.shared.getRosterOfSurvivors().filter { locations.contains($0.location) }
    }
    func getSurvivors(who livingStatus: [LifeStatus]) -> [Soul] {
        return Stockpile.shared.getRosterOfSurvivors().filter { livingStatus.contains($0.livingStatus) }
    }

    func getAllLivingSurvivorsInCamp() -> [Soul] {
        return getSurvivors(where: [.inVan, .inCamp])
    }

  
    func getAllLivingSurvivorsInVan() -> [Soul] {
        return getSurvivors(where: [.inVan])
    }
    mutating func setSurvivors(_ newList : [Soul]){
        rosterOfSurvivors = newList
    }
    mutating func swapPlacesOfSurvivors(selectedSurvivorInSpot: Soul, insideBuild: Soul){
        if let index1 = rosterOfSurvivors.firstIndex(where: { $0.id == selectedSurvivorInSpot.id }),
           let index2 = rosterOfSurvivors.firstIndex(where: { $0.id == insideBuild.id }) {
            //First it locates if the two requested survivors exist, by searching for the
            
            
            let temp = rosterOfSurvivors[index1]
            let goingStatus = rosterOfSurvivors[index1].location
            let goingStatusSec = rosterOfSurvivors[index2].location
            
            rosterOfSurvivors[index1] = rosterOfSurvivors[index2]
            rosterOfSurvivors[index2] = temp
            
            rosterOfSurvivors[index1].location = goingStatus
            rosterOfSurvivors[index2].location = goingStatusSec
        }
    }
    
    mutating func calcConsumption(){
        if foodStored-rosterOfSurvivors.count > 0{
            foodStored -= rosterOfSurvivors.count
        }
        else {
            foodStored = 0
        }
    }
    func runOutOfPeople()->Bool{
        if rosterOfSurvivors.count <= 0 {
            return true
        }
        return false
    }
    func getAllLivingSurvivorsInBuildings(outside : any Buildable)->[Soul]{
        var survivorsInBuild : [Soul] = []
        for survivor in rosterOfSurvivors {
            if survivor.location != .inBuilding(outside.buildID) && survivor.location != .inVan {
                survivorsInBuild.append(survivor)
            }
        }
        return survivorsInBuild
    }
    init() {
        self.foodStored = 10
        self.buildingResources = 10
        self.rosterOfSurvivors = SurvivorGenerator.shared.generateSurvivors(3)
    }
    func getWorkers(in id: BuildingID) -> [Soul] {
        return rosterOfSurvivors.filter { $0.location == .inBuilding(id) }
    }

}

