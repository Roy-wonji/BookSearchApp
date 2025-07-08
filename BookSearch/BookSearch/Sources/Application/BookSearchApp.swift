//
//  BookSearchApp.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import SwiftUI

@main
struct BookSearchApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
