//
//  DetailController.swift
//  DENMov
//
//  Created by DENAZMI on 11/07/24.
//

import UIKit

class DetailController: UIViewController {
    
    private let id: String
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
