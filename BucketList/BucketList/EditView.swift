//
//  EditView.swift
//  BucketList
//
//  Created by Berardino Chiarello on 29/06/23.
//

import SwiftUI

struct EditView: View {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    var delete: () -> Void
    
    
    @State private var name: String
    @State private var description: String
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby...") {
                    switch loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
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
                        var newLocation = location
                        newLocation.id = UUID()
                        newLocation.name = name
                        newLocation.description = description
                        
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
                await fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void, delete: @escaping () -> Void) {
        self.location = location
        self.onSave = onSave
        self.delete = delete

        //Assign the initial value of name to name and location @State variable
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
            
        } catch {
            loadingState = .failed
        }
        
    }
    
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in } delete: { }
    }
}
