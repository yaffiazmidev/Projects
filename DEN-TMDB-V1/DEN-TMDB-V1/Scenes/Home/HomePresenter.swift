//
//  HomePresenter.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

protocol IHomePresenter {
}

class HomePresenter: IHomePresenter {
    
    weak var controller: IHomeController?
    
    init() {}
}
