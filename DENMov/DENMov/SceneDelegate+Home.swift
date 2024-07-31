//
//  SceneDelegate+Home.swift
//  DENMov
//
//  Created by DENAZMI on 11/07/24.
//

import Foundation

var showDetail: ((String) -> Void)?

extension SceneDelegate {
    
    func configureHomeFeature() {
        DENMov.showDetail = showDetailController(with:)
    }
    
    private func showDetailController(with id: String) {
        let vc = DetailController(id: id)
        pushOnce(vc)
    }
}
