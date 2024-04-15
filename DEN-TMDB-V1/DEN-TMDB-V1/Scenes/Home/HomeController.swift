//
//  HomeController.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 13/04/24.
//

import UIKit

protocol IHomeController: AnyObject {
}

class HomeController: UIViewController {
    
    private let interactor: IHomeInteractor

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    init(interactor: IHomeInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeController: IHomeController {
}



