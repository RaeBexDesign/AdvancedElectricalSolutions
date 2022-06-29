//
//  ProjectMapView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 5/19/22.
//

import SwiftUI
import MapKit

//struct ProjectMapView: View {
//    var coordinate: CLLocationCoordinate2D
//    @State private var region = MKCoordinateRegion()
//    
//    struct Place: Identifiable {
//        let id = UUID()
//        let name: String
//        let coordinate: CLLocationCoordinate2D
//    }
//    @State var annotations: [Place] = [] //<-
//    
//    var body: some View {
//        Map(coordinateRegion: $region, annotationItems: annotations) {
//            MapMarker(coordinate: $0.coordinate)
//        }
//            .onAppear {
//                setRegion(coordinate)
//                annotations = [
//                    Place(name: "Xyz", coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
//                ]
//            }
//    }
//    
//    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
//        region = MKCoordinateRegion(
//            center: coordinate,
//            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
//        )
//    }
//}
//
//struct ProjectMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectMapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
//    }
//}
