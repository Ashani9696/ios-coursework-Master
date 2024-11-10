//
//  AuthenticationView.swift
//  MyVault
//
//  Created by Mudara on 2023-09-24.
//

import SwiftUI
import CustomTextField
import PopupView

struct AuthenticationView: View {
    @ObservedObject var authVM = AuthenticationViewModel()
    private let isPinSet = UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.IS_PIN_SETTED)
    
    var body: some View {
        NavigationStack{
            if authVM.isToggledLog {
                VStack(spacing: 25, content: {
                    EGTextField(text: $authVM.logEmail)
                        .setPlaceHolderText("Username")
                        .setTextFieldHeight(55)
                    EGTextField(text: $authVM.logPassword)
                        .setPlaceHolderText("Password")
                        .setSecureText(true)
                        .setTextFieldHeight(55)
                    if !authVM.isLoading {
                        Button(action: {
                            authVM.loginUser()
                        }, label: {
                            Spacer()
                            Text("Login")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.white)
                            Spacer()
                        })
                        .padding(.all)
                        .background(Color("ThemeVault"))
                        .cornerRadius(10)
                    } else {
                        ProgressView()
                            .padding(.all)
                    }
                    HStack(spacing: 5){
                        Spacer()
                        Text("Don’t have an account yet?")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color.black)
                        Button(action: {
                            withAnimation{
                                authVM.isToggledLog.toggle()
                            }
                        }, label: {
                            Text("Sign Up")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color("ThemeVault"))
                                .underline()
                        })
                        Spacer()
                    }
                    Spacer()
                })
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .navigationBarTitle("Login", displayMode: .large)
                .popup(isPresented: $authVM.isError) {
                    HStack {
                        Spacer()
                        Image("ic_warn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 5)
                        Text("Please check with your credentials!")
                            .font(.system(size: 18, weight: .regular))
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(Color("WarnYellow"))
                    .cornerRadius(15)
                    .padding(.horizontal, 25)
                } customize: {
                    $0
                        .type(.floater())
                        .position(.bottom)
                        .animation(.spring())
                        .closeOnTapOutside(true)
                        .backgroundColor(.black.opacity(0.5))
                        .autohideIn(2)
                }
            } else {
                VStack(spacing: 25, content: {
                    EGTextField(text: $authVM.regUsername)
                        .setPlaceHolderText("Username")
                        .setTextFieldHeight(55)
                    EGTextField(text: $authVM.regEmail)
                        .setPlaceHolderText("Email")
                        .setTextFieldHeight(55)
                    EGTextField(text: $authVM.regPassword)
                        .setPlaceHolderText("Password")
                        .setSecureText(true)
                        .setTextFieldHeight(55)
                    Text("By signing up, you agree to our [Terms & Conditions](https://apple.com) and [Privacy Policy.](https://apple.com)")
                        .frame(maxWidth: .infinity)
                    if !authVM.isLoading {
                        Button(action: {
                            authVM.createUser()
                        }, label: {
                            Spacer()
                            Text("Sign Up")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.white)
                            Spacer()
                        })
                        .padding(.all)
                        .background(Color("ThemeVault"))
                        .cornerRadius(10)
                    } else {
                        ProgressView()
                            .padding(.all)
                    }
                    HStack(spacing: 5){
                        Spacer()
                        Text("Already have an account?")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color.black)
                        Button(action: {
                            withAnimation{
                                authVM.isToggledLog.toggle()
                            }
                        }, label: {
                            Text("Login")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color("ThemeVault"))
                                .underline()
                        })
                        Spacer()
                    }
                    Spacer()
                })
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .navigationBarTitle("Sign Up", displayMode: .large)
                .popup(isPresented: $authVM.isSuccess) {
                    HStack {
                        Spacer()
                        Image("ic_success")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 5)
                        Text("You are set!")
                            .font(.system(size: 18, weight: .regular))
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(Color("#33BBC5"))
                    .cornerRadius(15)
                    .padding(.horizontal, 25)
                } customize: {
                    $0
                        .type(.floater())
                        .position(.bottom)
                        .animation(.spring())
                        .closeOnTapOutside(true)
                        .backgroundColor(.black.opacity(0.5))
                        .autohideIn(2)
                        .dismissCallback {
                            withAnimation{
                                authVM.isToggledLog.toggle()
                            }
                        }
                }
                .popup(isPresented: $authVM.isError) {
                    HStack {
                        Spacer()
                        Image("ic_warn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 5)
                        Text("Please check with your credentials!")
                            .font(.system(size: 18, weight: .regular))
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(Color("WarnYellow"))
                    .cornerRadius(15)
                    .padding(.horizontal, 25)
                } customize: {
                    $0
                        .type(.floater())
                        .position(.bottom)
                        .animation(.spring())
                        .closeOnTapOutside(true)
                        .backgroundColor(.black.opacity(0.5))
                        .autohideIn(2)
                }
            }
            NavigationLink(destination: isPinSet ? AnyView(MainTabView()) : AnyView(LockScreenView(isSetPassword: true)), isActive: $authVM.jumpToMain) {}
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authVM: AuthenticationViewModel())
    }
}
