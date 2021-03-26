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

//var tempLength = 0
//var alreadyPassed: Set<Int> = []
//
//func shortestPathBetweenTwo(a: Int, b: Int, numOfAll: Int) -> Int {
//    alreadyPassed.insert(a)
//    return helper(current: a, end: b, numOfAll: numOfAll)
//}
//
//func helper(current: Int, end: Int, numOfAll: Int) -> Int {
//    if alreadyPassed.count == numOfAll {
//        return -1
//    }
//    if containsAll(array: paths[current], set: alreadyPassed) {
//        return -1
//    }
//    for i in paths[current] {
//        if alreadyPassed.contains(i) {
//            continue
//        }
//        tempLength += 1
//        alreadyPassed.insert(i)
//        if i == end {
//            return tempLength
//        } else {
//            if helper(current: i, end: end, numOfAll: numOfAll) == -1 {
//                return -1
//            } else {
//                return helper(current: i, end: end, numOfAll: numOfAll)
//            }
//        }
//    }
//    return -1
//}


func containsAll(array: [Int], set: Set<Int>) -> Bool {
    for i in array {
        if !set.contains(i) {
            return false
        }
    }
    return true
}
