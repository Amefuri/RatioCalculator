//
//  MainViewModel.swift
//  RatioCalculator
//
//  Created by peerapat atawatana on 2/24/2560 BE.
//  Copyright © 2560 daydreamclover. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol MainViewModelInputs {
    var x:Variable<Int> { get }
    var y:Variable<Int> { get }
    var matchedRatioX:Variable<Int> { get }
    var matchedRatioY:Variable<Int> { get }
}

public protocol MainViewModelOutputs {
    var ratioX: Variable<Int>? { get }
    var ratioY: Variable<Int>? { get }
    var matchedRatioX:Variable<Int> { get }
    var matchedRatioY:Variable<Int> { get }
}

public protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

public final class MainViewModel: MainViewModelType, MainViewModelInputs, MainViewModelOutputs {
    
    // MARK: Variable
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    public init() {
        
        let ratioObservable =
          Observable
            .combineLatest(inputs.x.asObservable(), inputs.y.asObservable()) { (x, y) -> Vector2Type in return Vector2(x: x, y: y) }
            .map { [unowned self](inputXY) -> Vector2Type in self.computeRatio(input: inputXY) }
      
        ratioObservable
          .map({$0.x})
          .bindTo(ratioX!)
          .disposed(by: disposeBag)
      
        ratioObservable
          .map({$0.y})
          .bindTo(ratioY!)
          .disposed(by: disposeBag)
        
        matchedRatioX
          .asObservable()
          .map({  ($0/(self.ratioX?.value)!)*(self.ratioY?.value)!   })
          .bindTo(matchedRatioY)
          .disposed(by: disposeBag)
    }
  
    // MARK: Input
    
    public var y: Variable<Int>             = Variable(1)
    public var x: Variable<Int>             = Variable(1)
    
    // MARK: Output
    
    public var ratioX: Variable<Int>? = Variable(1)
    public var ratioY: Variable<Int>? = Variable(1)
    
    // MARK: Input&Output
    
    public var matchedRatioX:Variable<Int> = Variable(1)
    public var matchedRatioY:Variable<Int> = Variable(1)

    // MARK: Property
    
    public var outputs: MainViewModelOutputs { return self }
    public var inputs: MainViewModelInputs { return self }
    
    // MARK: Private
    
    private func computeRatio(input:Vector2Type)-> Vector2Type {
        let gcdValue = gcd(input.x, input.y)
        let ratioX = input.x / gcdValue
        let ratioY = input.y / gcdValue
        return Vector2(x: ratioX, y: ratioY)
    }
    
    private func computeSuitRatioHeight(with width:Int, targetRatio:Vector2Type)-> Int {
        return (width / targetRatio.x) * targetRatio.y
    }
    
    private func computeSuitRatioWidth(with height:Int, targetRatio:Vector2Type)-> Int {
        return (height / targetRatio.y) * targetRatio.x
    }
}
