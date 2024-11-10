//
//  ReportCategoryView.swift
//  MyVault
//
//  Created by CodeLabs on 2023-09-30.
//

import SwiftUI

struct ReportCategoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var reportType: Bool
    @EnvironmentObject var reportVM: ReportTransferViewModel
    
    var body: some View {
        VStack{
            if reportType {
                ForEach(0..<reportVM.expenseCategories.count, id: \.self){ index in
                    HStack{
                        Text(reportVM.expenseCategories[index])
                            .padding(.vertical, 10)
                        Spacer()
                        if reportVM.selectedCategory == index {
                            Image("ic_selected")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .background(.white)
                    .onTapGesture {
                        reportVM.selectedCategory = index
                        presentationMode.wrappedValue.dismiss()
                    }
                    Divider()
                }
            } else {
                ForEach(0..<reportVM.incomeCategories.count, id: \.self){ index in
                    HStack{
                        Text(reportVM.incomeCategories[index])
                            .padding(.vertical, 10)
                        Spacer()
                        if reportVM.selectedCategory == index {
                            Image("ic_selected")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .background(.white)
                    .onTapGesture {
                        reportVM.selectedCategory = index
                        presentationMode.wrappedValue.dismiss()
                    }
                    Divider()
                }
            }
            Spacer()
        }
        .padding(.horizontal, 25)
    }
}

#Preview {
    ReportCategoryView(reportType: .constant(false))
}
