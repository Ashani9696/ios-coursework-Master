//
//  ReportTransferView.swift
//  MyVault
//
//  Created by CodeLabs on 2023-09-30.
//

import SwiftUI
import PopupView

struct ReportTransferView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var reportType: Bool
    @ObservedObject var reportVM: ReportTransferViewModel
    
    init(reportType: Binding<Bool>) {
        self._reportType = reportType
        self.reportVM = ReportTransferViewModel(reportType: reportType.wrappedValue)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Spacer()
            VStack(alignment: .leading){
                Text("How much?")
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                HStack(content: {
                    Text("$")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                    TextField("00", text: $reportVM.transAmount)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                })
            }
            .padding(.horizontal, 25)
            Spacer()
            VStack(alignment: .leading, spacing: 15){
                HStack{
                    Text(reportType ? reportVM.expenseCategories[reportVM.selectedCategory] : reportVM.incomeCategories[reportVM.selectedCategory])
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.vertical)
                .padding(.horizontal, 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray, lineWidth: 1)
                )
                .background(.white)
                .onTapGesture {
                    self.reportVM.showCategories.toggle()
                }
                HStack{
                    TextField("Description", text: $reportVM.transDesc)
                    Spacer()
                }
                .padding(.vertical)
                .padding(.horizontal, 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray, lineWidth: 1)
                )
                if reportVM.selectedImage != nil {
                    Image(uiImage: reportVM.selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .cornerRadius(10)
                        .overlay(
                            Button(action: {
                                reportVM.selectedImage = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .padding(2)
                            }
                            .background(Color.red)
                            .clipShape(Circle())
                            .padding(2)
                            .offset(x: 10, y: -10), alignment: .topTrailing)
                } else {
                    Button(action: {
                        self.reportVM.isPickerPresented.toggle()
                    }, label: {
                        HStack{
                            Spacer()
                            Image(systemName: "paperclip")
                                .foregroundColor(.gray)
                            Text("Add Attachment")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [10]))
                        )
                    })
                }
                if (reportVM.isLoading) {
                    HStack{
                        Spacer()
                        ProgressView()
                            .padding(.all)
                        Spacer()
                    }
                } else {
                    Button(action: {
                        if reportVM.validateReport() {
                            if reportVM.selectedImage != nil{
                                reportVM.uploadToStorage(selectedImage: reportVM.selectedImage!)
                            } else {
                                reportVM.reportTransfer()
                            }
                        } else {
                            reportVM.isError.toggle()
                        }
                    }, label: {
                        Spacer()
                        Text("Submit")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.white)
                        Spacer()
                    })
                    .padding(.all)
                    .background(reportType ? .red : .green)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 50)
            .background(.white)
            .cornerRadius(topLeft: 25, topRight: 25, bottomLeft: 25, bottomRight: 25)
            .padding(.horizontal,10)
        }
        .background(reportType ? .red : .green)
        .navigationTitle(reportType ? "Expence" : "Income")
        .sheet(isPresented: $reportVM.isPickerPresented) {
            ImagePickerUtils(selectedImage: $reportVM.selectedImage)
        }
        .popup(isPresented: $reportVM.isError) {
            HStack {
                Spacer()
                Image("ic_warn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 5)
                Text("Amount / Description Cannot Be Empty!")
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
        .popup(isPresented: $reportVM.isSuccess) {
            HStack {
                Spacer()
                Image("ic_success")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 5)
                Text("Successfully Reported")
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
            .dismissCallback({
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        NavigationLink(destination:
                        ReportCategoryView(reportType: $reportType)
                            .environmentObject(reportVM)
                            .navigationBarTitle(reportType ? "Expense Categories" : "Income Categories", displayMode: .inline), isActive: $reportVM.showCategories) {}
    }
}

#Preview {
    ReportTransferView(reportType: .constant(true))
}

