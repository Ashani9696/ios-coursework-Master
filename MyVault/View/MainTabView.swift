//
//  MainTabView.swift
//  MyVault
//
//  Created by Mudara on 2023-09-25.
//

import SwiftUI
import PopupView

struct MainTabView: View {
    @ObservedObject var homeVM = HomeViewModel()
    @ObservedObject var transferVM = TransfersViewModel()
    @ObservedObject var profileVM = ProfileViewModel()
    @State var selectedTab = "ic_home"
    @State var selectedImage = ""
    
    init() {
        
    }
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom, content: {
                switch selectedTab {
                case "ic_user":
                    ProfileView()
                        .environmentObject(profileVM)
                        .ignoresSafeArea(.container, edges: .bottom)
                        .statusBar(hidden: false)
                case "ic_wallet":
                    TransfersView()
                        .environmentObject(transferVM)
                        .ignoresSafeArea(.container, edges: .bottom)
                        .statusBar(hidden: false)
                default:
                    HomeView()
                        .environmentObject(homeVM)
                        .ignoresSafeArea(.container, edges: .bottom)
                        .statusBar(hidden: true)
                }
                CustomTabBar(selectedTab: $selectedTab, selectedImage: $selectedImage)
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: 2, y: 2)
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: -2, y: -2)
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : 0)
            })
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .popup(isPresented: self.$transferVM.showFilterTime) {
                TransitionFilterView(filter: $transferVM.filterTime)
                    .environmentObject(transferVM)
                .frame(minHeight: 150)
                .background(.white)
            } customize: {
                $0
                    .type(.default)
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
            .popup(isPresented: self.$homeVM.showReportSelect) {
                VStack{
                    Button(action: {
                        homeVM.reportType = false
                        homeVM.showReportSelect.toggle()
                        homeVM.jumpToReport.toggle()
                    }, label: {
                        Spacer()
                        Text("Income")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.white)
                        Spacer()
                    })
                    .padding(.all)
                    .background(.green)
                    .cornerRadius(10)
                    Button(action: {
                        homeVM.reportType = true
                        homeVM.showReportSelect.toggle()
                        homeVM.jumpToReport.toggle()
                    }, label: {
                        Spacer()
                        Text("Expense")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.white)
                        Spacer()
                    })
                    .padding(.all)
                    .background(.red)
                    .cornerRadius(10)
                }
                .padding(.top, 15)
                .padding([.horizontal, .bottom], 25)
                .background(.white)
            } customize: {
                $0
                    .type(.default)
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
            .popup(isPresented: self.$transferVM.showFilterType) {
                TransitionTypesView()
                    .environmentObject(transferVM)
            } customize: {
                $0
                    .type(.default)
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
            .popup(isPresented: self.$profileVM.showLogout) {
                LogoutPopup()
                    .environmentObject(profileVM)
            } customize: {
                $0
                    .type(.default)
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
            .popup(isPresented: self.$homeVM.showWalletFilter) {
                WalletFilterView()
                    .environmentObject(homeVM)
            } customize: {
                $0
                    .type(.default)
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: String
    @Binding var selectedImage: String
    @State var tabPoints: [CGFloat] = []
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            TabBarButton(image: "ic_home", selectedTab: $selectedTab, selectedImage: $selectedImage, tabPoints: $tabPoints)
            TabBarButton(image: "ic_wallet", selectedTab: $selectedTab, selectedImage: $selectedImage, tabPoints: $tabPoints)
            TabBarButton(image: "ic_user", selectedTab: $selectedTab, selectedImage: $selectedImage, tabPoints: $tabPoints)
        }
        .padding()
        .background(Color("ShadeRed"))
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    func getCurvepoints()->CGFloat {
        if tabPoints.isEmpty {
            return 10
        } else {
            switch selectedTab {
            case "ic_home":
                return tabPoints[0]
            case "ic_wallet":
                return tabPoints[1]
            case "ic_user":
                return tabPoints[2]
            default:
                return tabPoints[0]
            }
        }
    }
}

struct TabBarButton: View {
    var image : String
    @Binding var selectedTab: String
    @Binding var selectedImage: String
    @Binding var tabPoints: [CGFloat]
    
    var body: some View {
        GeometryReader { reader -> AnyView in
            let midX =  reader.frame(in: .global).midX
            
            DispatchQueue.main.async {
                if tabPoints.count <= 4 {
                    tabPoints.append(midX)
                }
            }
            return AnyView (
                Button(action: {
                    self.selectedImage = self.image
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5)){
                        selectedTab = image
                    }
                }, label: {
                    Image("\(image)\(selectedTab == image ? "" : "_filled")")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.6)
                        .frame(height: selectedTab == image ? 45 : 30)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
        }
        .frame(height: 45)
    }
}
