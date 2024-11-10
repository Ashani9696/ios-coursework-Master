//
//  OnboardingView.swift
//  MyVault
//
//  Created by Mudara on 2023-09-23.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var onBoardingVM = OnboardingViewModel()
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ZStack {
                    ForEach(0..<onBoardingVM.items.count, id: \.self) { index in
                        VStack(alignment: .center, content: {
                            Image(onBoardingVM.items[index].image)
                                .frame(width: 300, height: 350)
                                .padding(20)
                                .background(Color(onBoardingVM.items[index].color))
                                .cornerRadius(25)
                                .scaleEffect(currentIndex == index ? 1.0 : 0.8)
                                .offset(x: CGFloat(index - currentIndex) * 320 + dragOffset, y: 0)
                            Text(onBoardingVM.items[index].title)
                                .frame(width: 300)
                                .font(.system(size: 34, weight: .bold))
                                .multilineTextAlignment(.center)
                                .scaleEffect(currentIndex == index ? 1.0 : 0.8)
                                .offset(x: CGFloat(index - currentIndex) * 320 + dragOffset, y: 0)
                                .padding([.vertical], 5)
                            Text(onBoardingVM.items[index].description)
                                .frame(width: 300)
                                .font(.system(size: 18, weight: .light))
                                .multilineTextAlignment(.center)
                                .scaleEffect(currentIndex == index ? 1.0 : 0.8)
                                .offset(x: CGFloat(index - currentIndex) * 320 + dragOffset, y: 0)
                        })
                    }
                }
                .gesture(DragGesture()
                    .onEnded({ value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation{
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation{
                                currentIndex = min(onBoardingVM.items.count - 1, currentIndex + 1)
                            }
                        }
                    }))
                HStack(alignment: .center, spacing: 5) {
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(currentIndex == 0 ? Color("ThemeVault") : .gray)
                        .scaleEffect(currentIndex == 0 ? 1.2 : 0.8)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(currentIndex == 1 ? Color("ThemeVault") : .gray)
                        .scaleEffect(currentIndex == 1 ? 1.2 : 0.8)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(currentIndex == 2 ? Color("ThemeVault") : .gray)
                        .scaleEffect(currentIndex == 2 ? 1.2 : 0.8)
                }
                .padding(.vertical, 15)
                Spacer()
                HStack(alignment: .center, content: {
                    Button(action: {
                        withAnimation{
                            currentIndex = max(0, currentIndex - 1)
                        }
                    }, label: {
                        if currentIndex != 0 {
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                    })
                    Spacer()
                    if currentIndex >= 2 {
                        NavigationLink("Get Started!", destination: AuthenticationView().navigationBarBackButtonHidden(true)).task {
                                UserDefaultsManager.shared.setBool(true, forKey: UserDefaultsManager.IS_DONE_ONBOARD)
                        }
                    } else {
                        Button(action: {
                            withAnimation{
                                currentIndex = min(onBoardingVM.items.count - 1, currentIndex + 1)
                            }
                        }, label: {
                            Image(systemName: "arrow.right")
                                .font(.title)
                        })
                    }
                })
                .frame(width: 300)
                .padding(.vertical, 15)
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
