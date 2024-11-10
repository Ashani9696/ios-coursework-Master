//
//  TransferDetailsView.swift
//  MyVault
//
//  Created by CodeLabs on 2023-09-30.
//

import SwiftUI
import Kingfisher
import PopupView

struct TransferDetailsView: View {
    @ObservedObject var transferVM = TransDetailsViewModel()
    @State var item: TransactionItem
    
    var body: some View {
        VStack {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
                Text(String(format: "%@ $%.2f", item.transactionType == 1 ? "+" : "-", item.transactionAmount))
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                Text(CommonUtils.formatTimestamp(TimeInterval(item.transactionDate)))
                    .foregroundColor(.white)
                HStack {
                    VStack(alignment: .leading){
                        HStack(alignment: .center){
                            Text("Type :")
                                .foregroundColor(.gray)
                            Text(item.transactionType == 1 ? "Income" : "Expense")
                                .font(.system(size: 18, weight: .bold))
                        }
                        HStack(alignment: .center){
                            Text("Category :")
                                .foregroundColor(.gray)
                            if (item.transactionType == 1) {
                                Text(CommonUtils.getIncomeTransferCategory(input: item.transactionCategory))
                                    .font(.system(size: 18, weight: .bold))
                            } else {
                                Text(CommonUtils.getExpenseTransferCategory(input: item.transactionCategory))
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(item.transactionType == 1 ? .green : .red)
            .cornerRadius(20)
            .padding([.top, .horizontal])
            Line()
              .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
              .frame(height: 1)
              .padding()
            VStack(spacing: 10, content: {
                VStack (alignment: .leading){
                    HStack {
                        Text("Description")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    Text(item.transactionRemark)
                        .padding(.top, 5)
                }
                
                VStack {
                    HStack {
                        Text("Attachment")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    if let transactionImg = item.transactionImg, !transactionImg.isEmpty {
                        KFImage(URL(string: transactionImg))
                            .resizable()
                            .placeholder {
                                ProgressView()
                                    .frame(width: UIScreen.main.bounds.width - 50, height: 200)
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 50, height: 200)
                            .cornerRadius(10)
                            .clipped()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .onLongPressGesture {
                                CommonUtils.saveImageToAlbum(imageURL: item.transactionImg!) { result in
                                    switch result {
                                    case .success(let image):
                                        DispatchQueue.global().async {
                                           DispatchQueue.main.async {
                                               self.transferVM.message = "Image downloaded and saved successfully."
                                               self.transferVM.isSuccess = true
                                               self.transferVM.showToolTip = true
                                           }
                                       }
                                    case .failure(let error):
                                        DispatchQueue.global().async {
                                           DispatchQueue.main.async {
                                               print("Error downloading/saving image: \(error.localizedDescription)")
                                               self.transferVM.message = "File Not Found!"
                                               self.transferVM.isSuccess = false
                                               self.transferVM.showToolTip = true
                                           }
                                       }
                                    }
                                }
                            }
                    } else {
                        HStack {
                            Spacer()
                            Text("- No Attachment Found -")
                            Spacer()
                        }
                    }
                }
                .padding(.top)
            })
            .padding(.horizontal, 25)
            Spacer()
        }
        .navigationBarTitle(item.transactionType == 1 ? "Income Transaction" : "Expence Transaction", displayMode: .inline)
        .popup(isPresented: self.$transferVM.showToolTip) {
            HStack {
                Spacer()
                Image(self.transferVM.isSuccess ? "ic_success" : "ic_warn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 5)
                Text(self.transferVM.message)
                    .font(.system(size: 18, weight: .regular))
                Spacer()
            }
            .padding(.vertical, 10)
            .background(self.transferVM.isSuccess ? Color("#33BBC5") : Color("WarnYellow").opacity(0.5))
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
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

