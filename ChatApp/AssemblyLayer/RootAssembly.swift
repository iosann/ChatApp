//
//  RootAssembly.swift
//  ChatApp
//
//  Created by Anna Belousova on 09.05.2022.
//

import Foundation

class RootAssembly {
    static let coreAssembly: ICoreAssembly = CoreAssembly()
    static let serviceAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: coreAssembly)
    static let presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: serviceAssembly)
}
