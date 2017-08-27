//
//  ViewController.swift
//  RatioCalculator
//
//  Created by peerapat atawatana on 2/23/2560 BE.
//  Copyright © 2560 daydreamclover. All rights reserved.
//

import UIKit

protocol Vector2Type {
    var x:Int { get set }
    var y:Int { get set }
}

struct Vector2:Vector2Type {
    var x: Int
    var y: Int
    
    public init(x:Int, y:Int) {
        self.x = x
        self.y = y
    }
}

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: IBOutlet
    
    @IBOutlet weak var preXField:UITextField!
    @IBOutlet weak var preYField:UITextField!
    
    @IBOutlet weak var ratioXLabel:UILabel!
    @IBOutlet weak var ratioYLabel:UILabel!
    
    @IBOutlet weak var posXField:UITextField!
    @IBOutlet weak var posYField:UITextField!
    
    // MARK: IBAction
    
    @IBAction func didClickOnConfirm() {
        let x = Int(preXField.text ?? "1") ?? 1
        let y = Int(preYField.text ?? "1") ?? 1
        
        // Calculate Ratio
        let ratio = computeRatio(input: Vector2(x: x, y: y))
        ratioXLabel.text = String(ratio.x)
        ratioYLabel.text = String(ratio.y)
        
        // Calculate Matched Width/Height 
        if posXField.text != "" && posYField.text == "" {
            let requestWidth = Int(posXField.text!) ?? 1
            posYField.text = String(computeSuitRatioHeight(with: requestWidth, targetRatio: ratio))
        }
        else if posXField.text == "" && posYField.text != "" {
            let requestHeight = Int(posYField.text!) ?? 1
            posXField.text = String(computeSuitRatioWidth(with: requestHeight, targetRatio: ratio))
        }
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preXField.delegate = self
        preYField.delegate = self
        posXField.delegate = self
        posYField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Private
    
    private func computeRatio(input:Vector2Type)-> Vector2Type {
        let gcdValue = gcd(input.x, input.y)
        let ratioX = input.x / gcdValue
        let ratioY = input.y / gcdValue
        print("\(ratioX):\(ratioY)")
        return Vector2(x: ratioX, y: ratioY)
    }
    
    private func computeSuitRatioHeight(with width:Int, targetRatio:Vector2Type)-> Int {
        return (width / targetRatio.x) * targetRatio.y
    }
    
    private func computeSuitRatioWidth(with height:Int, targetRatio:Vector2Type)-> Int {
        return (height / targetRatio.y) * targetRatio.x
    }
    
    // MARK: UITextfield Delegate
    


}

