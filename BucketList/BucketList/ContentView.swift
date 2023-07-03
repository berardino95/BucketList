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
        if viewModel.isUnlocked {
            ZStack {
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
                
                Circle()
                    .fill(.blue)
                    .opacity(0.7)
                    .frame(width: 10, height: 10)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer ()
                        Button {
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                    
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                } delete: {
                        viewModel.delete()
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
