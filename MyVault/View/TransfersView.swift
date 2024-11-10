//
//  TransfersView.swift
//  MyVault
//
//  Created by Mudara on 2023-09-25.
//

import SwiftUI
import PopupView

struct TransfersView: View {
    @EnvironmentObject var transferVM: TransfersViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                Button(action: {
                    transferVM.showFilterType.toggle()
                }, label: {
                    HStack{
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                        Text(transferVM.filterType == 0 ? "All" : transferVM.filterType == 1 ? "Income" : "Expense")
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.gray, lineWidth: 1)
                    )
                })
                Spacer()
                Button(action: {
                    withAnimation{
                        transferVM.showFilterTime.toggle()
                    }
                }, label: {
                        Image("ic_options")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35)
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray, lineWidth: 1)
                            )
                })
            }
            HStack{
                Text("See your financial report")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(15)
            .background(.yellow.opacity(0.3))
            .cornerRadius(10)
            Text(transferVM.filterTypes[transferVM.filterTime])
                .font(.system(size: 18, weight: .bold))
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    if (transferVM.isLoading) {
                        HStack{
                            Spacer()
                            ProgressView()
                                .padding(.all)
                            Spacer()
                        }
                    } else {
                        if (transferVM.transferListResponse.transactionList.isEmpty){
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
                            ForEach(0..<transferVM.transferListResponse.transactionList.count, id: \.self){ index in
                                NavigationLink(destination: TransferDetailsView(item: transferVM.transferListResponse.transactionList[index]), label: {
                                    HStack{
                                        if (transferVM.transferListResponse.transactionList[index].transactionType == 1) {
                                            Image(CommonUtils.getIncomeIcon(input: transferVM.transferListResponse.transactionList[index].transactionCategory))
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35)
                                                .padding(10)
                                                .background(.yellow.opacity(0.3))
                                                .cornerRadius(10)
                                        } else {
                                            Image(CommonUtils.getExpenseIcon(input: transferVM.transferListResponse.transactionList[index].transactionCategory))
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35)
                                                .padding(10)
                                                .background(.yellow.opacity(0.3))
                                                .cornerRadius(10)
                                        }
                                        VStack(spacing: 8){
                                            HStack{
                                                if (transferVM.transferListResponse.transactionList[index].transactionType == 1) {
                                                    Text(CommonUtils.getIncomeTransferCategory(input: transferVM.transferListResponse.transactionList[index].transactionCategory))
                                                        .font(.system(size: 18, weight: .semibold))
                                                } else {
                                                    Text(CommonUtils.getExpenseTransferCategory(input: transferVM.transferListResponse.transactionList[index].transactionCategory))
                                                        .font(.system(size: 18, weight: .semibold))
                                                }
                                                Spacer()
                                                Text(String(format: "%@ $%.2f", transferVM.transferListResponse.transactionList[index].transactionType == 1 ? "+" : "-", transferVM.transferListResponse.transactionList[index].transactionAmount))
                                                    .foregroundColor(transferVM.transferListResponse.transactionList[index].transactionType == 1 ? .green : .red)
                                                    .font(.system(size: 18, weight: .semibold))
                                            }
                                            HStack{
                                                Text("\(transferVM.transferListResponse.transactionList[index].transactionRemark)")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                Spacer()
                                                Text(CommonUtils.formatTimestamp(TimeInterval(transferVM.transferListResponse.transactionList[index].transactionDate)))
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
        .padding(.horizontal, 25)
        .onAppear{
            self.transferVM.getUserTransactions()
        }
    }
}

struct TransfersView_Previews: PreviewProvider {
    static var previews: some View {
        TransfersView()
    }
}

struct TransitionFilterView: View {
    @EnvironmentObject var transferVM: TransfersViewModel
    @State var selectedIndex = 0
    
    init(filter: Binding<Int>) {
        _selectedIndex = State(initialValue: filter.wrappedValue)
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Filter Transaction")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: {
                    withAnimation{
                        selectedIndex = 0
                    }
                }, label: {
                    Text("Reset")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(
                            Capsule()
                                .fill(Color("SecondaryColor")).opacity(0.5)
                        )
                })
            }
            Text("Filter By")
                .font(.system(size: 18, weight: .semibold))
            HStack{
                ForEach(0..<transferVM.filterTypes.count, id: \.self){ index in
                    if selectedIndex == index {
                        Text(transferVM.filterTypes[index])
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(Color("SecondaryColor")).opacity(0.5)
                            )
                            .onTapGesture(){
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
                    } else {
                        Text(transferVM.filterTypes[index])
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(.gray, lineWidth: 1)
                            )
                            .onTapGesture(){
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
                    }
               }
            }
            Button(action: {
                transferVM.filterTime = selectedIndex
                transferVM.showFilterTime.toggle()
                self.transferVM.getUserTransactions()
            }, label: {
                Spacer()
                Text("Apply")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.white)
                Spacer()
            })
            .padding(.all)
            .background(Color("ThemeVault"))
            .cornerRadius(10)
            .padding(.top)
        }
        .padding([.horizontal, .bottom], 25)
        .padding(.top, 10)
    }
}

struct TransitionTypesView: View {
    @EnvironmentObject var transferVM: TransfersViewModel
    
    var body: some View {
        VStack{
            Button(action: {
                transferVM.filterType = 0
                transferVM.showFilterType.toggle()
                transferVM.getUserTransactions()
            }, label: {
                Spacer()
                Text("All")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.white)
                Spacer()
            })
            .padding(.all)
            .background(.gray)
            .cornerRadius(10)
            Button(action: {
                transferVM.filterType = 1
                transferVM.showFilterType.toggle()
                transferVM.getUserTransactions()
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
                transferVM.filterType = 2
                transferVM.showFilterType.toggle()
                transferVM.getUserTransactions()
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
    }
}
