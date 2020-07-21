//
//  DataResponseError.swift
//  Movie
//
//  Created by Madi Kabdrash on 7/21/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation
enum DataResponseError: Error {
  case network
  case decoding
  
  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data "
    case .decoding:
      return "An error occurred while decoding data"
    }
  }
}
