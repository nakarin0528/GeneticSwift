//
//  GA.swift
//  GeneticSwift
//
//  Created by Iko Nakari on 2018/01/12.
//  Copyright © 2018年 Iko Nakari. All rights reserved.
//

import Foundation

final class GA {
    let MAX_GEN = 30
    let POP_SIZE = 20
    let LEN_CHROM = 30
    let GEN_GAP = 0.4
    let P_MUTAION = 0.3
    let RANDOM_MAX = 32767
    let BEFORE = 0
    let AFTER = 1
    
    var chrom: [[Int]] = [[]]
    var fitness: [Int] = []
    var max = 0
    var min = 0
    var sumfitness = 0
    var n_min = 0
    
    //make random number
    var next: CLong = 1
    
    private func rand() -> Int {
        self.next = self.next * 1103515245 + 12345
        return Int(UInt(next/65536)%32768)
    }
    
    private func srand(_ seed: Int) {
        self.next = seed
    }
    
    
    //print data
    private func printEachChromFitness(_ i: Int) {
        print("[\(i)] ", terminator: "")
        for j in 0..<LEN_CHROM {
            print("\(chrom[i][j])", terminator: "")
        }
        print(": \(fitness[i])")
    }
    
    private func printChromFitness() {
        for i in 0..<POP_SIZE {
            self.printEachChromFitness(i)
        }
    }
    
    private func printStatistics(_ gen: Int) {
        print("[gen=%2d] max=%d sumfitness=%d ave=%f",
              gen, self.max, self.min, self.sumfitness, Double(self.sumfitness)/Double(POP_SIZE))
    }

    private func printCrossover(isBefore: Bool, parent1: Int, parent2: Int, child1: Int, child2: Int, n_cross: Int) {
        if isBefore {
            print("parent1   |"); self.printEachChromFitness(parent1)
            print("parent2   |"); self.printEachChromFitness(parent2)
            print("delete1   |"); self.printEachChromFitness(child1)
            print("delete2   |"); self.printEachChromFitness(child2)
            print("n_cross=%d\n", n_cross)
        } else {
            print("child1   |"); self.printEachChromFitness(child1)
            print("child2   |"); self.printEachChromFitness(child2)
            print("----------------------------")
        }
    }
    
    private func printMutation(isBefore: Bool, child: Int, n_mutate: Int) {
        if isBefore {
            print("child(OLD)|"); self.printEachChromFitness(child)
            print("n_mutate=%d\n", n_mutate)
        } else {
            print("child(NEW)|"); self.printEachChromFitness(child)
            print("----------------------------")
        }
    }
    
    
    // mutation
    private func mutation(child: Int) {
        var n_mutate = 0
        var rand = 0.0
        
        rand = Double(self.rand()) / Double(RANDOM_MAX+1)   // 0..<1
        
        if rand < P_MUTAION {
            // position
            n_mutate = self.rand() % LEN_CHROM
            // mutate
            self.printMutation(isBefore: true, child: child, n_mutate: n_mutate)
            switch self.chrom[child][n_mutate] {
            case 0:
                self.chrom[child][n_mutate] = 1
                break
            case 1:
                self.chrom[child][n_mutate] = 0
                break
            default:
                break
            }
            self.fitness[child] = self.objFunc(child)
            self.printMutation(isBefore: false, child: child, n_mutate: n_mutate)
        }
    }
    
    
    // total fitness
    private func statistics() {
        self.max = 0
        self.min = POP_SIZE
        self.sumfitness = 0
        
        for i in 0..<POP_SIZE {
            if self.fitness[i] > self.max {
                self.max = self.fitness[i]
            }
            if self.fitness[i] < self.min {
                self.min = self.fitness[i]
                self.n_min = i
            }
            self.sumfitness += self.fitness[i]
        }
    }
    
    
    // crossover
    private func crossover(parent1: Int, parent2: Int, child1: inout Int, child2: inout Int) {  // child1,2はポインタ
        var min2 = 0
        var n_cross = 0
    
        // min
        child1 = self.n_min
        // second min
        min2 = POP_SIZE
        for i in 0..<POP_SIZE {
            if i != child1 {
                if self.min <= self.fitness[i] && self.fitness[i] < min2 {
                    min2 = self.fitness[i]
                    child2 = i
                }
            }
        }
        
        // position
        n_cross = self.rand() % (LEN_CHROM-1) + 1   // n_cross = 1,...,5
        // crossover
        self.printCrossover(isBefore: true, parent1: parent1, parent2: parent2, child1: child1, child2: child2, n_cross: n_cross)
        for i in 0..<n_cross {
            self.chrom[child1][i] = self.chrom[parent1][i]
            self.chrom[child2][i] = self.chrom[parent2][i]
        }
        for i in n_cross..<LEN_CHROM {
            self.chrom[child1][i] = self.chrom[parent2][i]
            self.chrom[child2][i] = self.chrom[parent1][i]
        }
        self.fitness[child1] = self.objFunc(child1)
        self.fitness[child2] = self.objFunc(child2)
        self.printCrossover(isBefore: false, parent1: parent1, parent2: parent2, child1: child1, child2: child2, n_cross: n_cross)
    }
    
    
    // object Function
    private func objFunc(_ i: Int) -> Int {
        var count = 0
        
        for j in 0..<LEN_CHROM {
            if chrom[i][j] == 1 {
                count += 1
            }
        }
        
        return count
    }
    
    
    // Processing of each generation
    public func generation(gen: Int) {
        
    }
}




































