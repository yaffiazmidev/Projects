//
//  HomeInteractor.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

protocol IHomeInteractor {
}

class HomeInteractor: IHomeInteractor {
    
    private let presenter: IHomePresenter
    
    init(presenter: IHomePresenter) {
        self.presenter = presenter
    }
}
