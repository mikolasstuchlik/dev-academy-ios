//
//  Places.swift
//  DevAcademy
//
//  Created by Zdenko Čepan on 25/07/2023.
//

import SwiftUI
import ActivityIndicatorView

struct PlacesScene: View {
    @EnvironmentObject var coordinator: Coordinator
    
    let state: PlacesSceneState = PlacesSceneState()
    
    var body: some View {
        NavigationStack {
            Group {
                if state.isLoaded {
                    List(state.showFavorites ? state.getFavoritesRows() : state.features, id: \.properties.ogcFid) { feature in
                        NavigationLink(destination: coordinator.placesDetail(with: feature, favorites: state.$favorites, isFav: state.isFavorit(feature: feature))) {
                            PlacesRow(state: PlacesRowState(feature: feature))
                                .onTapGesture {
                                    state.onFeatureTapped(feature: feature)
                                } // TAP
                        } // LINK
                    } // LIST
                    .listStyle(.plain)
                    .animation(.default, value: state.features)
                } else {
                    ActivityIndicatorView(isVisible: .constant(true),
                                          type: .growingCircle)
                } // ELSE
            } // GROUP
            .navigationTitle("Kulturmapa")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: state.favoritesPressed) {
                        Label("", systemImage: state.showFavorites ? "heart.fill" : "heart")
                            .foregroundColor(.black)
                    } // BUTTON
                } // TOOLBAR ITEM
            } // TOOLBAR
        } // NAVIGATION
        .task{
            await state.fetch()
        }
    }
}

struct Places_Previews: PreviewProvider {
    static var previews: some View {
        PlacesScene()
            .injectPreviewsEnvironment()
    }
}
