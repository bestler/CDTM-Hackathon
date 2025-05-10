import SwiftUI

struct ExtractedVaccinationsView: View {
    @ObservedObject var viewModel: VaccinationReviewViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddVaccinationSheet = false
    @State private var newVaccinationName = ""
    @State private var newVaccinationDoctor = ""
    @State private var newVaccinationDate = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    Text("These are the vaccinations recognized from your document. Please review and correct any information if needed.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Form with vaccinations
                    Form {
                        Section(header: Text("Extracted Vaccinations")) {
                            ForEach(Array(viewModel.vaccinations.enumerated()), id: \.offset) { idx, vaccination in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "syringe")
                                            .foregroundColor(.blue)
                                        TextField("Name", text: Binding(
                                            get: { vaccination.name },
                                            set: { newValue in
                                                var updated = vaccination
                                                updated = Vaccination(name: newValue, doctor: vaccination.doctor, date: vaccination.date)
                                                viewModel.updateVaccination(updated, at: idx)
                                            })
                                        )
                                        .font(.headline)
                                    }

                                    HStack {
                                        Image(systemName: "person.text.rectangle")
                                            .foregroundColor(.green)
                                            .frame(width: 20)
                                        TextField("Doctor", text: Binding(
                                            get: { vaccination.doctor },
                                            set: { newValue in
                                                var updated = vaccination
                                                updated = Vaccination(name: vaccination.name, doctor: newValue, date: vaccination.date)
                                                viewModel.updateVaccination(updated, at: idx)
                                            })
                                        )
                                    }

                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.orange)
                                            .frame(width: 20)
                                        TextField("Date", text: Binding(
                                            get: { vaccination.date },
                                            set: { newValue in
                                                var updated = vaccination
                                                updated = Vaccination(name: vaccination.name, doctor: vaccination.doctor, date: newValue)
                                                viewModel.updateVaccination(updated, at: idx)
                                            })
                                        )
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteVaccination)
                        }
                    }
                    .scrollContentBackground(.hidden)

                    Button(action: {
                        showingAddVaccinationSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add New Vaccination")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Extracted Vaccinations")
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            )
            .background(Color(.systemGray6))
            .sheet(isPresented: $showingAddVaccinationSheet) {
                addVaccinationView
            }
        }
    }

    // View for adding a new vaccination
    private var addVaccinationView: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)
                Form {
                    Section(header: Text("New Vaccination Details")) {
                        TextField("Vaccination Name", text: $newVaccinationName)
                        TextField("Doctor", text: $newVaccinationDoctor)
                        TextField("Date (YYYY-MM-DD)", text: $newVaccinationDate)
                    }
                    .scrollContentBackground(.hidden)
                }
                .navigationTitle("Add Vaccination")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingAddVaccinationSheet = false
                        resetNewVaccinationFields()
                    },
                    trailing: Button("Save") {
                        addNewVaccination()
                        showingAddVaccinationSheet = false
                    }
                        .disabled(newVaccinationName.isEmpty)
                )
            }
        }
    }

        // Function to add a new vaccination
        private func addNewVaccination() {
            let newVaccination = Vaccination(
                name: newVaccinationName,
                doctor: newVaccinationDoctor,
                date: newVaccinationDate
            )
            viewModel.addVaccination(newVaccination)
            resetNewVaccinationFields()
        }

        // Function to reset the form fields
        private func resetNewVaccinationFields() {
            newVaccinationName = ""
            newVaccinationDoctor = ""
            newVaccinationDate = ""
        }

        // Function to delete a vaccination
        private func deleteVaccination(at offsets: IndexSet) {
            viewModel.removeVaccinations(at: offsets)
        }
    }
