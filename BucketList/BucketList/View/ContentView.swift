//
//  ContentView.swift
//  BucketList
//
//  Created by Berardino Chiarello on 29/06/23.
//
import MapKit
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        //View showed if Authentication goes right or pin is entered
        if viewModel.isUnlocked {
            ZStack {
                //Map with annotation
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations, annotationContent: { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            VStack {
                               LocationAnnotationView()
                            }
                            .onTapGesture {
                                viewModel.selectedPlace = location
                            }
                        }
                })
                .ignoresSafeArea()
                //Center point on the map
                Circle()
                    .fill(.blue)
                    .opacity(0.7)
                    .frame(width: 10, height: 10)
                
                //+ Button on right side
                VStack {
                    Spacer()
                    HStack {
                        Spacer ()
                        Button {
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                    
                }
            }
            //Sheet presented when a user tap on a place(annotation)
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                } delete: {
                        viewModel.delete()
                }
            }
        } else {
            VStack(spacing: 20){
                Button("Unlock Places") {
                    viewModel.authenticate()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Button("Unlock with pin") {
                    viewModel.showPinScreen = true
                }
                .sheet(isPresented: $viewModel.showPinScreen) {
                    PinScreenView { pin in
                        viewModel.pinAuthentication(insertPin: pin)
                    }
                }
            }
            //Alert showed on Biometric authentication fail
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("Try again") { viewModel.authenticate() }
                Button("Unlock with pin") { viewModel.showPinScreen = true }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
