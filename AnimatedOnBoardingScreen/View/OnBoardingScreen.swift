//
//  OnBoardingScreen.swift
//  AnimatedOnBoardingScreen
//
//  Created by Seungchul Ha on 2022/12/17.
//

import SwiftUI
import Lottie

struct OnBoardingScreen: View {
    
    // MARK: OnBoarding Slides Model Data
    @State var onboardingItems: [OnboardingItem] = [
        .init(title: "Request Pickup", subTitle: "Tell us who you're sending it to, what you're sending and when it's best to pickup the package and we will pick it up at the most convenient time", lottieView: .init(name: "Pickup", bundle: .main)),
        .init(title: "Track Delivery", subTitle: "The best part starts when our courier is on the way to your location, as you will get real time notifications as to the exact location of the courier", lottieView: .init(name: "Transfer", bundle: .main)),
        .init(title: "Receive Package", subTitle: "The journey ends when your package get to it's location. Get notified immediately your package is received at its intended location", lottieView: .init(name: "Delivery", bundle: .main))
    ]
    
    // MARK: Current Slide Index
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            HStack(spacing: 0) {
                ForEach($onboardingItems) { $item in
                    
                    let isLastSlide = (currentIndex == onboardingItems.count - 1)
                    
                    VStack {
                        
                        // MARK: Top Nav Bar
                        HStack {
                            Button("Back") {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                    playAnimation()
                                }
                            }
                            .opacity(currentIndex > 0 ? 1 : 0)
                            
                            Spacer(minLength: 0)
                            
                            Button("Skip") {
                                currentIndex = onboardingItems.count - 1
                                playAnimation()
                            }
                            .opacity(isLastSlide ? 0 : 1)
                        }
                        .animation(.easeInOut, value: currentIndex)
                        .tint(Color("Green"))
                        .fontWeight(.bold)
                        
                        // MARK: Movable Slides
                        VStack(spacing: 15) {
                            
                            let offset = -CGFloat(currentIndex) * size.width
                            
                            // MARK: Resizable Lottie View
                            ResizableLottieView(onboardingItem: $item)
                                .frame(height: size.width)
                                .onAppear {
                                    // MARK: Resizable Lottie View
                                    if currentIndex == indexOf(item) {
                                        item.lottieView.play(toProgress: 0.7)
                                        
                                        // Why toProgress 0.7?
                                        // Because My Lottie Files will be reset at the end,
                                        // I am stopping the animation at 0.7 to make it appear
                                        // as if it is not looping. B
                                    }
                                }
                                .offset(x: offset)
                                .animation(.easeOut(duration: 0.5), value: currentIndex)
                            
                            // Each part will be moved with a tiny delay to make it appear as bthough it is pushing.
                            
                            Text(item.title)
                                .font(.title.bold())
                                .offset(x: offset)
                                .animation(.easeOut(duration: 0.5).delay(0.1), value: currentIndex)
                            
                            Text(item.subTitle)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 15)
                                .foregroundColor(.gray)
                                .offset(x: offset)
                                .animation(.easeOut(duration: 0.5).delay(0.2), value: currentIndex)
                        }
                        
                        Spacer(minLength: 0)
                        
                        // MARK: Next / Login Button
                        VStack(spacing: 15) {
                            Text(isLastSlide ? "Login" : "Next")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, isLastSlide ? 13 : 12)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Capsule()
                                        .fill(Color("Green"))
                                }
                                .padding(.horizontal, isLastSlide ? 30 : 100)
                                .onTapGesture {
                                    // MARK: Updating to Next Index
                                    if currentIndex < onboardingItems.count - 1 {
                                        
                                        // MARK: Pausing Previous Animation
                                        let currentProgress = onboardingItems[currentIndex].lottieView.currentProgress
                                        
                                        onboardingItems[currentIndex].lottieView.currentProgress = (currentProgress == 0 ? 0.7 : currentProgress)
                                        // Upper Line Code Explanation
                                        // If the animation is finished, currentProgress will be zero; if it is,
                                        // set the animation view to the last frame.
                                        
                                        currentIndex += 1
                                        
                                        // MARK: Playing Next Animation from Start
                                        playAnimation()
                                    }
                                }
                            
                            HStack {
                                Text("Terms of Service")
                                
                                Text("Privacy Policy")
                            }
                            .font(.caption2)
                            .underline(true, color: .primary)
                            .offset(y: 5)
                            
                        }
                        
                    }
                    .animation(.easeInOut, value: isLastSlide)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
                }
            }
            .frame(width: size.width * CGFloat(onboardingItems.count), alignment: .leading)
        }
    }
    
    func playAnimation() {
        onboardingItems[currentIndex].lottieView.currentProgress = 0
        onboardingItems[currentIndex].lottieView.play(toProgress: 0.7)
    }
    
    // MARK: Retrieving Index of the Item in the Array
    func indexOf(_ item: OnboardingItem) -> Int {
        if let index = onboardingItems.firstIndex(of: item) {
            return index
        }
        return 0
    }
    
}

struct OnBoardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Resizable Lottie View Without Background
struct ResizableLottieView: UIViewRepresentable {
    
    @Binding var onboardingItem: OnboardingItem
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .clear
        setupLottieView(view)
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func setupLottieView(_ to: UIView) {
        
        let lottieView = onboardingItem.lottieView
        lottieView.backgroundColor = .clear
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Applying Constraints
        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: to.heightAnchor),
        ]
        to.addSubview(lottieView)
        to.addConstraints(constraints)
        
    }
}
