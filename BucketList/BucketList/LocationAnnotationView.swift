//
//  LocationAnnotationView.swift
//  BucketList
//
//  Created by Berardino Chiarello on 30/06/23.
//

import SwiftUI

struct LocationAnnotationView: View {
    var body: some View {
        VStack{
            Circle()
                .frame(width: 44, height: 44)
                .foregroundColor(.white)
                .overlay {
                    Image(systemName: "map.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .font(.headline)
                        .foregroundColor(.red)
                }
                
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 10)
                .rotationEffect(Angle(degrees: 180))
                .foregroundColor(.red)
                .offset(y: -10)
        }
        .padding(.bottom, 27)
    }
}

struct LocationAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAnnotationView()
    }
}
