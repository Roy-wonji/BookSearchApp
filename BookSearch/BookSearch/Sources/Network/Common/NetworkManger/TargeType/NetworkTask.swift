//
//  NetworkTask.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

enum NetworkTask {
  case requestPlain
  case requestParameters(
    parameters: [String: Any],
    encoding: CustomParameterEncoding
  )
  case requestCompositeParameters(
    bodyParameters: [String: Any],
    bodyEncoding: CustomParameterEncoding,
    urlParameters: [String: Any]
  )
}
