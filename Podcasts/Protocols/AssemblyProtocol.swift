//
//  AssemblyProtocol.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 01.08.2020.
//  Copyright © 2020 Eugene Karambirov. All rights reserved.
//

import Foundation
import UIKit

protocol AssemblyProtocol {
    associatedtype Dependencies
    associatedtype Parameters

    func makeModule(dependencies: Dependencies, parameters: Parameters) -> UIViewController
}
