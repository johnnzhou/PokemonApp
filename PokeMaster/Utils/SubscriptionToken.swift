//
//  SubscriptionToken.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/24/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation
import Combine

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() {
        cancellable = nil
    }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
