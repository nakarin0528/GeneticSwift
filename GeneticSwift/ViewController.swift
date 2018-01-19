//
//  ViewController.swift
//  GeneticSwift
//
//  Created by Iko Nakari on 2018/01/12.
//  Copyright © 2018年 Iko Nakari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let ga = GA()
    var gen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ga.initialize()
        for gen in 1...ga.MAX_GEN {
            ga.generation(gen: gen)
        }
        print("finish")
        ga.printChromFitness()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

