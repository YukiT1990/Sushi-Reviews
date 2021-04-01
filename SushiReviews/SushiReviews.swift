//
//  SushiReviews.swift
//  SushiReviews
//
//  Created by Yuki Tsukada on 2021/03/26.
//

import Foundation

var paths: [[Int]] = [[]]
var nodeVisited: Set<Int> = []
var numberOfTimesNodeVisited: [Int] = []
var tempPathLength = 0
var pathLength = 100_000
var previousStart: Int = -1

func sushi() {
    let firstLine = readLine()!.split(separator: " ").map { Int($0) }
    let numOfN = firstLine[0]!
    let numOfM = firstLine[1]!
    let indexesOfM: [Int] = readLine()!.split(separator: " ").map { Int($0)! }
    
    paths = [[Int]](repeating: [Int](repeating: 0, count: 0), count: numOfN)
    numberOfTimesNodeVisited = [Int](repeating: 0, count: numOfN)
    for i in 0..<numOfN {
        numberOfTimesNodeVisited[i] = 0
    }
    
    for _ in 1..<numOfN {
        let pathInput = readLine()!.split(separator: " ").map { Int($0) }
        paths[pathInput[0]!].append(pathInput[1]!)
        paths[pathInput[1]!].append(pathInput[0]!)
    }
    print(paths)

    for m in indexesOfM {
        print("m \(m)")
        findPath(start: m, originalStart: m, mustVisit: indexesOfM)
        nodeVisited.removeAll()
        tempPathLength = 0
        for i in 0..<numOfN {
            numberOfTimesNodeVisited[i] = 0
        }
    }
    print("output \(pathLength)")
}

func findPath(start: Int, originalStart: Int, mustVisit: [Int]) {
    print("start \(start)")
    print(nodeVisited)
    print("tempPathLength \(tempPathLength)")
    numberOfTimesNodeVisited[start] += 1
    if !nodeVisited.contains(start) {
        nodeVisited.insert(start)
    }

    print(containsAll(array: mustVisit, set: nodeVisited))
    if containsAll(array: mustVisit, set: nodeVisited) {
        print("complete \(nodeVisited)")
        if tempPathLength < pathLength {
            pathLength = tempPathLength
            return
        }
    }
    for i in paths[start] {
        if previousStart == i && paths[i].count != 1 {
            continue
        }
        if i == originalStart {
            return
        }
        previousStart = start
        if numberOfTimesNodeVisited[i] < paths[i].count {
            tempPathLength += 1

            findPath(start: i, originalStart: originalStart, mustVisit: mustVisit)
            print("tempPathLength \(tempPathLength)")
            nodeVisited.remove(i)
            tempPathLength -= 1

        }
    }

}

func containsAll(array: [Int], set: Set<Int>) -> Bool {
    for i in array {
        if !set.contains(i) {
            return false
        }
    }
    return true
}

func sushiReviews() {
    struct Restaurant {
        let number: Int
        let adjacent: [Int]
        let previousRestaurant: Int
        let traveledRestaurants: Set<Int>
        let travelTime: Int
    }
    
    let firstLine = readLine()!.split(separator: " ").map { Int($0) }
    let numOfN = firstLine[0]!
    let numOfM = firstLine[1]!
    let indexesOfM: [Int] = readLine()!.split(separator: " ").map { Int($0)! }
    
    var smallestTravelTime = 2 * numOfN
    
    var paths = [[Int]](repeating: [Int](repeating: 0, count: 0), count: numOfN)
    
    for _ in 1..<numOfN {
        let pathInput = readLine()!.split(separator: " ").map { Int($0) }
        paths[pathInput[0]!].append(pathInput[1]!)
        paths[pathInput[1]!].append(pathInput[0]!)
    }
    
    func findSmallestTravelTime(startRestaurant: Restaurant) {
        let q = Queue<Restaurant>()
        q.enqueue(item: startRestaurant)
        var restaurantsToVisitDict: [Int: Bool] = [:]
        for i in indexesOfM {
            restaurantsToVisitDict[i] = false
        }
        
        while !q.isEmpty() {
            
            let sq = q.dequeue()!
            let number = sq.number
            let adjacentRestaurants: [Int] = sq.adjacent
            let previousReataurant: Int = sq.previousRestaurant
            var traveledRestaurants: Set<Int> = sq.traveledRestaurants
            let travelTime = sq.travelTime
            traveledRestaurants.insert(number)
            
            if travelTime > smallestTravelTime {
                break
            }
            if indexesOfM.contains(number) {
                restaurantsToVisitDict[number] = true
                if containsAll(array: indexesOfM, set: traveledRestaurants) {
                    print("travelTime \(travelTime)")
                    print(traveledRestaurants)
                    if travelTime < smallestTravelTime {
                        smallestTravelTime = travelTime
                    }
                    break
                }
            }
            for i in 0..<adjacentRestaurants.count {
                let adjacentRestaurantNumber = adjacentRestaurants[i]
                if adjacentRestaurantNumber == previousReataurant && adjacentRestaurants.count > 1 {
                    continue
                }
                q.enqueue(item: Restaurant(number: adjacentRestaurantNumber, adjacent: paths[adjacentRestaurantNumber], previousRestaurant: number, traveledRestaurants: traveledRestaurants, travelTime: travelTime + 1))
            }
        }
    }
    for restaurant in indexesOfM {
        print("start \(restaurant)")
        let emptySet: Set<Int> = []
        findSmallestTravelTime(startRestaurant: Restaurant(number: restaurant, adjacent: paths[restaurant], previousRestaurant: -1, traveledRestaurants: emptySet, travelTime: 0))
    }
    print("output")
    print(smallestTravelTime)
}
