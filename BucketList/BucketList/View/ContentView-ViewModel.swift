//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Berardino Chiarello on 29/06/23.
//

import SwiftUI
import LocalAuthentication
import MapKit

extension ContentView {
    
    @MainActor class ViewModel: ObservableObject {
        @Published  var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 10), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        //not settable from other scope
        @Published private(set) var locations = [Location]()
        @Published var selectedPlace : Location?
        @Published var showPinScreen = false
        @Published var isUnlocked = false
        
        @Published var showAlert = false
        @Published var alertTitle = "Error"
        @Published var alertMessage = ""
        
        
        let pin = "1234"
        
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
        
        //update place after modification
        func update(location: Location){
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        //delete selected place
        func delete(){
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations.remove(at: index)
                save()
            }
        }
        
        //Biometric authentication
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    Task { @MainActor in
                        if success {
                            self.isUnlocked = true
                        }
                        else {
                            self.showAlert = true
                            self.alertMessage = "Sorry there was a problem with your authentication"
                            
                        }
                    }
                }
            } else {
                showAlert = true
                self.alertMessage = "Sorry your device doesn't support biometric authentication"
                
            }
        }
        
        //check the entered pin
        func pinAuthentication (insertPin: String) {
            if insertPin == pin {
                self.isUnlocked = true
            }
        }
    }
}
