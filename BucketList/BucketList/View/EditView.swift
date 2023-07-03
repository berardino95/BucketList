//
//  EditView.swift
//  BucketList
//
//  Created by Berardino Chiarello on 29/06/23.
//

import SwiftUI

struct EditView: View {
    
    @StateObject private var viewModel : ViewModel
 
    
    
    @Environment(\.dismiss) var dismiss
    
    var onSave: (Location) -> Void
    var delete: () -> Void

    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            /*@START_MENU_TOKEN@*/Text(page.title)/*@END_MENU_TOKEN@*/
                            + Text(": ")
                            + Text(page.description)
                                .italic() 
                        }
                    case .failed:
                        Text("Please try again later")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save") {
                        let newLocation = viewModel.createNewLocation()
                        onSave(newLocation)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete") {
                        delete()
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void, delete: @escaping () -> Void){
        self.onSave = onSave
        self.delete = delete
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
    }
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in } delete: { }
    }
}
