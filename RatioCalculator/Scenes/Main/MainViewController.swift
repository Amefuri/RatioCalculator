//
//  MainViewController.swift
//  RatioCalculator
//
//  Created by peerapat atawatana on 2/24/2560 BE.
//  Copyright © 2560 daydreamclover. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: BaseViewController {
    
    // MARK: Property
    
    private var viewModel:MainViewModelType!
    
    // MARK: IBOutlet
    
    @IBOutlet weak var preXField:UITextField!
    @IBOutlet weak var preYField:UITextField!
    
    @IBOutlet weak var ratioXLabel:UILabel!
    @IBOutlet weak var ratioYLabel:UILabel!
    
    @IBOutlet weak var posXField:UITextField!
    @IBOutlet weak var posYField:UITextField!
    
    // MARK: Initializing
    
    /*init(viewModel: MainViewModelType) {
        super.init()
        self.configure(viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(MainViewModel())
    }
    
    // MARK: Configuring
    
    private func configure(_ viewModel: MainViewModelType) {
        
        preXField.rx.text.orEmpty.asObservable()
            .map({ Int($0) ?? 1 })
            .subscribe(onNext: { viewModel.inputs.x.value = $0 })
            .disposed(by: disposeBag)
        
        preYField.rx.text.orEmpty.asObservable()
            .map({ Int($0) ?? 1 })
            .subscribe(onNext: { viewModel.inputs.y.value = $0 })
            .disposed(by: disposeBag)
        
        posXField.rx.text.orEmpty.asObservable()
            .map({ Int($0) ?? 1 })
            .bindTo(viewModel.inputs.matchedRatioX)
            .disposed(by: disposeBag)
        
        posYField.rx.text.orEmpty.asObservable()
            .map({ Int($0) ?? 1 })
            .bindTo(viewModel.inputs.matchedRatioY)
            .disposed(by: disposeBag)
        
        // Binding
        
        viewModel.outputs.ratioX?.asDriver().map({String($0)}).drive(ratioXLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.ratioY?.asDriver().map({String($0)}).drive(ratioYLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.outputs.matchedRatioX.asDriver().map({String($0)}).drive(posXField.rx.text).disposed(by: disposeBag)
        viewModel.outputs.matchedRatioY.asDriver().map({String($0)}).drive(posYField.rx.text).disposed(by: disposeBag)
    }
}
