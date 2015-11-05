//
//  QNode.swift
//  QuickSwiftStructures
//
//  Created by Lukasz Czerwinski on 11/5/15.
//  Copyright © 2015 Lukasz Czerwinski <czerwinskilukasz1@gmail.com>. All rights reserved.
//

import Foundation


class QuickNode<T> {
    
    var key: T
    var next: QuickNode? = nil
    
    init(key: T) {
        self.key = key
    }
}

