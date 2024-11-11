//
//  AppleMapsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 11/11/2024.
//

import SwiftUI
import MapKit

private struct AppleMapsViewRepresentable: UIViewRepresentable {
    @StateObject private var locationManager = LocationManager()
    @Binding var shouldCenterOnUser: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.mapDidPan))
        panGesture.delegate = context.coordinator
        mapView.addGestureRecognizer(panGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        guard let coordinate = locationManager.userLocation else { return }
        
        if shouldCenterOnUser {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapView: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var mapView: AppleMapsViewRepresentable
        
        init(mapView: AppleMapsViewRepresentable) {
            self.mapView = mapView
        }
        
        @objc func mapDidPan() {
            mapView.shouldCenterOnUser = false
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}


struct AppleMapsView: View {
    @State private var shouldCenterOnUser = true
    
    var body: some View {
        ZStack {
            AppleMapsViewRepresentable(shouldCenterOnUser: $shouldCenterOnUser)
                .ignoresSafeArea(.all, edges: .bottom)
            
            Button(action: {
                shouldCenterOnUser = true
            }) {
                Image(systemName: shouldCenterOnUser ? "location.fill" : "location")
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .navigationTitle("ApplesMaps")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppleMapsView()
}
