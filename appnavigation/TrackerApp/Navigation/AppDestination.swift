//
//  AppDestination.swift
//  appnavigation
//
//  Created by MACM72 on 16/03/26.
//


import UIKit

import UIKit

enum AppDestination: String {
    case dashboard = "navigateToDashboard"
    case profile = "navigateToProfile"
    case settings = "navigateToSettings"
    case dynamicHeight = "navigateToDynamicHeight"

    var storyboardID: String {
        switch self {
        case .dashboard: return "DashboardVC"
        case .profile: return "ProfileVC"
        case .settings: return "SettingsVC"
        case .dynamicHeight: return "DynamicHeightVCID"
        }
    }
}
