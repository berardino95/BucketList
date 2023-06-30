//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Berardino Chiarello on 29/06/23.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    
    @MainActor class ViewModel: ObservableObject {
        @Published  var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 20, longitude: 15), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        //not settable from other scope
        @Published private(set) var locations = [Location]()
        @Published var selectedPlace : Location?
        @Published var isUnlocked = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        //loading data
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        //Save data to a file in the disk
        func save(){
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            }  catch {
                print("Unable to save data")
            }
        }
        
        func addLocation(){
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location){
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func delete(location: Location){
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations.remove(at: index)
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        // error
                    }
                }
            }
        }
    }
}
