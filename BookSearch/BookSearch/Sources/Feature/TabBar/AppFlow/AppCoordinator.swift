//
//  AppCoordinator.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
  @Published var selectedTab: AppTab = .search
}
