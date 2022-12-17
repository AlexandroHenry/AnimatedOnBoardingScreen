//
//  OnBoardingItem.swift
//  AnimatedOnBoardingScreen
//
//  Created by Seungchul Ha on 2022/12/17.
//

import Foundation
import SwiftUI
import Lottie

// MARK: OnBoarding Item Model
struct OnboardingItem: Identifiable, Equatable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var lottieView: LottieAnimationView = .init() // For Play/Pause Lottie Animation
}


