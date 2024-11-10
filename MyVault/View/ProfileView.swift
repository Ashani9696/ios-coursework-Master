//
//  ProfileView.swift
//  MyVault
//
//  Created by Mudara on 2023-09-25.
//

import SwiftUI
import PopupView

struct ProfileView: View {
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                ZStack(alignment: .center) {
                    Image("ic_profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color("SecondaryColor"), lineWidth: 2)
                        )
                }
                VStack(alignment: .leading){
                    Text("Username")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Saman Khan")
                        .font(.title)
                        .bold()
                }
                .padding(.leading, 10)
                Spacer()
                Image("ic_pen")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
            }
            VStack(spacing: 2){
                HStack(alignment: .center){
                    ZStack {
                        Rectangle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("ShadeYellow"))
                            .cornerRadius(15)
                        Image("ic_wallets")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    Text("Currency")
                        .font(.system(size: 20))
                        .padding(.leading, 10)
                    Spacer()
                    HStack(alignment: .center, spacing: 0){
                        Text(profileVM.currencyType)
                            .foregroundColor(.gray)
                        Image("ic_arrow_right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                    }
                }
                .padding(.all, 15)
                .background(.white)
                .cornerRadius(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)
                .onTapGesture {
                    self.profileVM.showCurrencyList.toggle()
                }
                HStack(alignment: .center){
                    ZStack {
                        Rectangle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("ShadeYellow"))
                            .cornerRadius(15)
                        Image("ic_reports")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    Text("Reports")
                        .font(.system(size: 20))
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.all, 15)
                .background(.white)
                HStack(alignment: .center){
                    ZStack {
                        Rectangle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("ShadeYellow"))
                            .cornerRadius(15)
                        Image("ic_settings")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    Text("Abouts")
                        .font(.system(size: 20))
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.all, 15)
                .background(.white)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://www.apple.com")!)
                }
                Button(action: {
                    self.profileVM.showLogout.toggle()
                }, label: {
                    HStack(alignment: .center){
                        ZStack {
                            Rectangle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("ShadeRed"))
                                .cornerRadius(15)
                            Image("ic_logout")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                        Text("Exit")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    .padding(.all, 15)
                    .background(.white)
                    .cornerRadius(topLeft: 0, topRight: 0, bottomLeft: 20, bottomRight: 20)
                })
            }
            .padding(.top, 20)
            Spacer()
        }
        .padding(.all, 25)
        .background(Color("ThemeGray"))
        .fullScreenCover(isPresented: self.$profileVM.showCurrencyList, content: {
            CurrencyListView(currencyType: $profileVM.currencyType)
        })
        NavigationLink(destination: AuthenticationView().navigationBarBackButtonHidden()
                       , isActive: $profileVM.isLoggedOut) {}
    }
}

struct CurrencyListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var currencyType: String
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text("Currency List")
                        .font(.title)
                        .bold()
                }
                Spacer()
            }
            Divider()
            Group{
                HStack{
                    Text("United States (USD)")
                    Spacer()
                    if (self.currencyType == "USD") {
                        Image("ic_set")
                            .resizable()
                            .scaledToFit()
                            .frame(width:20)
                            .padding(.trailing)
                    }
                }
                .padding(.vertical, 12)
                Divider()
            }
            .onTapGesture {
                self.currencyType = "USD"
                self.presentationMode.wrappedValue.dismiss()
            }
            Group{
                HStack{
                    Text("Sri Lanka (LKR)")
                    Spacer()
                    if (self.currencyType == "LKR") {
                        Image("ic_set")
                            .resizable()
                            .scaledToFit()
                            .frame(width:20)
                            .padding(.trailing)
                    }
                }
                .padding(.vertical, 12)
                Divider()
            }
            .onTapGesture {
                self.currencyType = "LKR"
                self.presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
        .padding(.horizontal, 25)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct LogoutPopup: View {
    @EnvironmentObject var profileVM: ProfileViewModel
    var body: some View {
        VStack(alignment: .center) {
            Text("Logout?")
                .font(.title3)
                .bold()
                .foregroundColor(Color("ThemeVault"))
                .padding(.vertical, 10)
            Text("Are you sure do you wanna logout?")
                .foregroundColor(.gray)
            HStack {
                Button(action: {
                    self.profileVM.showLogout = false
                }, label: {
                    Spacer()
                    Text("No")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("ThemeVault"))
                    Spacer()
                })
                .padding(.vertical, 15)
                .background(Color("WarnYellow"))
                .cornerRadius(15)
                .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 40)
                Button(action: {
                    self.profileVM.userLogout()
                }, label: {
                    Spacer()
                    Text("Yes")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("WarnYellow"))
                    Spacer()
                })
                .padding(.vertical, 15)
                .background(Color("ThemeVault"))
                .cornerRadius(15)
                .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 40)
            }
            .padding(.top, 10)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
        .background(.white)
    }
}

