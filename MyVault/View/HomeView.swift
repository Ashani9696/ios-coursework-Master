//
//  HomeView.swift
//  MyVault
//
//  Created by Mudara on 2023-09-25.
//

import SwiftUI
import MarqueeText

struct HomeView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        VStack(spacing: 0){
            VStack{
                HStack{
                    ZStack(alignment: .center) {
                        Image("ic_profile")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color("SecondaryColor"), lineWidth: 2)
                            )
                    }
                    Spacer(minLength: 0)
                    Button(action: {
                        withAnimation{
                            homeVM.showWalletFilter.toggle()
                        }
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                            Text(homeVM.filterTypes[homeVM.filterWallet])
                                .foregroundColor(.black)
                        }
                    })
                    Spacer(minLength: 0)
                    Button(action: {
                        withAnimation{
                            homeVM.showReportSelect.toggle()
                        }
                    }, label: {
                        Image("ic_add")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                    })
                }
                VStack{
                    Text("Account Balance")
                        .foregroundColor(.gray)
                    Text("$ \(String(format: "%.2f", homeVM.walletResponse.incomeAmount - homeVM.walletResponse.expenseAmount))")
                        .font(.system(size: 48, weight: .semibold))
                }
                HStack(spacing: 5){
                    HStack(alignment: .center){
                        Image("ic_income")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 5)
                        VStack(spacing: 5){
                            Text("Income")
                                .foregroundColor(.white)
                                .foregroundColor(.gray)
                            MarqueeText(
                                text: "$ \(String(format: "%.2f", homeVM.walletResponse.incomeAmount))",
                                font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                                leftFade: 16,
                                rightFade: 16,
                                startDelay: 3)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                    .background(.green)
                    .cornerRadius(10)
                    HStack(alignment: .center){
                        Image("ic_expense")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 5)
                        VStack(spacing: 5){
                            Text("Expense")
                                .foregroundColor(.white)
                                .foregroundColor(.gray)
                            MarqueeText(
                                text: "$ \(String(format: "%.2f", homeVM.walletResponse.expenseAmount))",
                                font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                                leftFade: 16,
                                rightFade: 16,
                                startDelay: 3)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                    .background(.red)
                    .cornerRadius(10)
                }
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 25)
            VStack(alignment: .leading){
                HStack{
                    ForEach(0..<homeVM.filterTypes.count, id: \.self){ index in
                        HStack{
                            Text(homeVM.filterTypes[index])
                                .foregroundColor(Color("SecondaryColor"))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(
                                    Capsule()
                                        .fill(homeVM.filterTime == index ? Color("SecondaryColor").opacity(0.5) : .clear).opacity(0.2)
                                )
                                .onTapGesture(){
                                    withAnimation {
                                        homeVM.filterTime = index
                                        homeVM.getUserTransactions()
                                    }
                                }
                            if (homeVM.filterTypes.count - 1 != index) {
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
                .background(
                    Capsule()
                        .fill(Color("SecondaryColor").opacity(0.3)).opacity(0.2)
                )
                Text("Recent Transactions")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top)
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack{
                        if (homeVM.isLoading) {
                            HStack{
                                Spacer()
                                ProgressView()
                                    .padding(.all)
                                Spacer()
                            }
                        } else {
                            if (homeVM.transferListResponse.transactionList.isEmpty){
                                VStack {
                                    Spacer()
                                    HStack(spacing: 10){
                                        Spacer()
                                        Image("ic_empty")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 35)
                                        Text("No Transactions Yet.")
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            } else {
                                ForEach(0..<homeVM.transferListResponse.transactionList.count, id: \.self){ index in
                                    NavigationLink(destination: TransferDetailsView(item: homeVM.transferListResponse.transactionList[index]), label: {
                                        HStack{
                                            if (homeVM.transferListResponse.transactionList[index].transactionType == 1) {
                                                Image(CommonUtils.getIncomeIcon(input: homeVM.transferListResponse.transactionList[index].transactionCategory))
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 35)
                                                    .padding(10)
                                                    .background(.yellow.opacity(0.3))
                                                    .cornerRadius(10)
                                            } else {
                                                Image(CommonUtils.getExpenseIcon(input: homeVM.transferListResponse.transactionList[index].transactionCategory))
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 35)
                                                    .padding(10)
                                                    .background(.yellow.opacity(0.3))
                                                    .cornerRadius(10)
                                            }
                                            VStack(spacing: 8){
                                                HStack{
                                                    if (homeVM.transferListResponse.transactionList[index].transactionType == 1) {
                                                        Text(CommonUtils.getIncomeTransferCategory(input: homeVM.transferListResponse.transactionList[index].transactionCategory))
                                                            .font(.system(size: 18, weight: .semibold))
                                                    } else {
                                                        Text(CommonUtils.getExpenseTransferCategory(input: homeVM.transferListResponse.transactionList[index].transactionCategory))
                                                            .font(.system(size: 18, weight: .semibold))
                                                    }
                                                    Spacer()
                                                    Text(String(format: "%@ $%.2f", homeVM.transferListResponse.transactionList[index].transactionType == 1 ? "+" : "-", homeVM.transferListResponse.transactionList[index].transactionAmount))
                                                        .foregroundColor(homeVM.transferListResponse.transactionList[index].transactionType == 1 ? .green : .red)
                                                        .font(.system(size: 18, weight: .semibold))
                                                }
                                                HStack{
                                                    Text("\(homeVM.transferListResponse.transactionList[index].transactionRemark)")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.gray)
                                                        .lineLimit(1)
                                                        .truncationMode(.tail)
                                                    Spacer()
                                                    Text(CommonUtils.formatTimestamp(TimeInterval(homeVM.transferListResponse.transactionList[index].transactionDate)))
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 11))
                                                }
                                            }
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 15)
                                        .background(.gray.opacity(0.1))
                                        .cornerRadius(10)
                                    })
                                }
                            }
                        }
                    }
                })
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 25)
            .background(.white)
            .cornerRadius(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color(.yellow).opacity(0.2))
        .onAppear{
            homeVM.getUserBalance()
            homeVM.getUserTransactions()
        }
        NavigationLink(destination: ReportTransferView(reportType: $homeVM.reportType)
            .navigationBarTitle("", displayMode: .inline), isActive: $homeVM.jumpToReport) {}
    }
}

struct WalletFilterView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        VStack{
            Text("Filter By")
                .font(.system(size: 18, weight: .bold))
                .padding(.top)
            HStack{
                ForEach(0..<homeVM.filterTypes.count, id: \.self){ index in
                    HStack{
                        Text(homeVM.filterTypes[index])
                            .foregroundColor(Color("SecondaryColor"))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(homeVM.filterWallet == index ? Color("SecondaryColor").opacity(0.5) : .clear).opacity(0.2)
                            )
                            .onTapGesture(){
                                withAnimation {
                                    homeVM.filterWallet = index
                                    homeVM.getUserBalance()
                                }
                            }
                        if (homeVM.filterTypes.count - 1 != index) {
                            Spacer(minLength: 0)
                        }
                    }
                }
            }
            .background(
                Capsule()
                    .fill(Color("SecondaryColor").opacity(0.3)).opacity(0.2)
            )
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 35)
        .background(.white)
    }
}
