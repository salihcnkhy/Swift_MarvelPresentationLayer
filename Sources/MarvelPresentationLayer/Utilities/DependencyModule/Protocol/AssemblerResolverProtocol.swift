//
//  AssemblerResolverProtocol.swift
//  MarvelApp
//
//  Created by Salihcan Kahya on 16.03.2022.
//

import Swinject

public protocol AssemblerResolverProtocol { }

public extension AssemblerResolverProtocol {
    func returnResolver() -> Resolver {
        return Assembler.sharedAssembler.resolver
    }
}
