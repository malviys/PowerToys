//
//  ContentView.swift
//  PowerToys
//
//  Created by Sourabh Malviya on 24/11/25.
//

import SwiftUI


struct ContentView: View {
    @State private var selection: Panel? = .colorPicker

        enum Panel: Hashable {
            case colorPicker
//            case windowManager
//            case imageResizer
        }

        var body: some View {
            NavigationSplitView {
                List(selection: $selection) {
                    Section(header: Text("Tools")) {
                        NavigationLink(value: Panel.colorPicker) {
                            Label("Color Picker", systemImage: "eyedropper")
                        }
                    }
                }
                .navigationTitle("MacPowerToys")
                .listStyle(.sidebar)
            } detail: {
                switch selection {
                case .colorPicker:
                    ColorPickerView()
                case .none:
                    Text("Select a tool")
                }
            }
            .frame(minWidth: 600, minHeight: 400)
        }
}

#Preview {
    ContentView()
}
