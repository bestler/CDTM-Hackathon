import SwiftUI

struct ExtractedGeneralInfoView: View {
    @ObservedObject var viewModel: GeneralInformationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    Text(viewModel.isManualEntry ?
                        "Enter your personal information below." :
                        "This is the information extracted from your document. Please review and correct any information if needed.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Form {
                        Section(header: Text("Personal Information")) {
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                TextField("Name", text: Binding(
                                    get: { viewModel.generalInformation?.name ?? "" },
                                    set: { newValue in
                                        var updated = viewModel.generalInformation ?? GeneralInformation(
                                            name: "",
                                            dateOfBirth: "",
                                            gender: "",
                                            address: "",
                                            insurance: Insurance(provider: "", insuranceNumber: "")
                                        )
                                        updated = GeneralInformation(
                                            name: newValue,
                                            dateOfBirth: updated.dateOfBirth,
                                            gender: updated.gender,
                                            address: updated.address,
                                            insurance: updated.insurance
                                        )
                                        viewModel.updateGeneralInformation(updated)
                                    }
                                ))
                                .font(.headline)
                            }
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.orange)
                                    .frame(width: 20)
                                TextField("Date of Birth (YYYY-MM-DD)", text: Binding(
                                    get: { viewModel.generalInformation?.dateOfBirth ?? "" },
                                    set: { newValue in
                                        var updated = viewModel.generalInformation ?? GeneralInformation(
                                            name: "",
                                            dateOfBirth: "",
                                            gender: "",
                                            address: "",
                                            insurance: Insurance(provider: "", insuranceNumber: "")
                                        )
                                        updated = GeneralInformation(
                                            name: updated.name,
                                            dateOfBirth: newValue,
                                            gender: updated.gender,
                                            address: updated.address,
                                            insurance: updated.insurance
                                        )
                                        viewModel.updateGeneralInformation(updated)
                                    }
                                ))
                            }
                            
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(.purple)
                                    .frame(width: 20)
                                TextField("Gender", text: Binding(
                                    get: { viewModel.generalInformation?.gender ?? "" },
                                    set: { newValue in
                                        var updated = viewModel.generalInformation ?? GeneralInformation(
                                            name: "",
                                            dateOfBirth: "",
                                            gender: "",
                                            address: "",
                                            insurance: Insurance(provider: "", insuranceNumber: "")
                                        )
                                        updated = GeneralInformation(
                                            name: updated.name,
                                            dateOfBirth: updated.dateOfBirth,
                                            gender: newValue,
                                            address: updated.address,
                                            insurance: updated.insurance
                                        )
                                        viewModel.updateGeneralInformation(updated)
                                    }
                                ))
                            }
                            
                            HStack {
                                Image(systemName: "house")
                                    .foregroundColor(.green)
                                    .frame(width: 20)
                                TextField("Address", text: Binding(
                                    get: { viewModel.generalInformation?.address ?? "" },
                                    set: { newValue in
                                        var updated = viewModel.generalInformation ?? GeneralInformation(
                                            name: "",
                                            dateOfBirth: "",
                                            gender: "",
                                            address: "",
                                            insurance: Insurance(provider: "", insuranceNumber: "")
                                        )
                                        updated = GeneralInformation(
                                            name: updated.name,
                                            dateOfBirth: updated.dateOfBirth,
                                            gender: updated.gender,
                                            address: newValue,
                                            insurance: updated.insurance
                                        )
                                        viewModel.updateGeneralInformation(updated)
                                    }
                                ))
                            }
                        }
                        
                        Section(header: Text("Insurance Information")) {
                            HStack {
                                Image(systemName: "cross.case")
                                    .foregroundColor(.red)
                                    .frame(width: 20)
                                TextField("Insurance Provider", text: Binding(
                                    get: { viewModel.generalInformation?.insurance.provider ?? "" },
                                    set: { newValue in
                                        var updated = viewModel.generalInformation ?? GeneralInformation(
                                            name: "",
                                            dateOfBirth: "",
                                            gender: "",
                                            address: "",
                                            insurance: Insurance(provider: "", insuranceNumber: "")
                                        )
                                        updated = GeneralInformation(
                                            name: updated.name,
                                            dateOfBirth: updated.dateOfBirth,
                                            gender: updated.gender,
                                            address: updated.address,
                                            insurance: Insurance(
                                                provider: newValue,
                                                insuranceNumber: updated.insurance.insuranceNumber
                                            )
                                        )
                                        viewModel.updateGeneralInformation(updated)
                                    }
                                ))
                            }
                            
                            HStack {
                                Image(systemName: "number")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                TextField("Insurance Number", text: Binding(
                                    get: { viewModel.generalInformation?.insurance.insuranceNumber ?? "" },
                                    set: { newValue in
                                        var updated = viewModel.generalInformation ?? GeneralInformation(
                                            name: "",
                                            dateOfBirth: "",
                                            gender: "",
                                            address: "",
                                            insurance: Insurance(provider: "", insuranceNumber: "")
                                        )
                                        updated = GeneralInformation(
                                            name: updated.name,
                                            dateOfBirth: updated.dateOfBirth,
                                            gender: updated.gender,
                                            address: updated.address,
                                            insurance: Insurance(
                                                provider: updated.insurance.provider,
                                                insuranceNumber: newValue
                                            )
                                        )
                                        viewModel.updateGeneralInformation(updated)
                                    }
                                ))
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle(viewModel.isManualEntry ? "Manual Information Entry" : "Extracted Information")
            .navigationBarItems(
                trailing: Button(action: {
                    // Save and dismiss
                    viewModel.handleSave()
                    viewModel.isManualEntry = false
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            )
            .onAppear {
                // If we don't have general information yet, create an empty one
                if viewModel.generalInformation == nil {
                    viewModel.updateGeneralInformation(GeneralInformation(
                        name: "",
                        dateOfBirth: "",
                        gender: "",
                        address: "",
                        insurance: Insurance(provider: "", insuranceNumber: "")
                    ))
                }
            }
        }
    }
}
