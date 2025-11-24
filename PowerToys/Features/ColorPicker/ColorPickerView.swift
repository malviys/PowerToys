//
//  ColorPickerView.swift
//  PowerToys
//
//  Created by Sourabh Malviya on 24/11/25.
//

import SwiftUI

struct ColorPickerView: View {
    @State private var selectedColor: Color = white
    @State private var recentColors: [Color] = [red, green, blue, orange, purple, pink, yellow, gray]
    @State private var showCopyConfirmation = false
    @State private var copiedFormat = ""

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar: Color Preview & Picker
            HStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedColor)
                    .frame(width: 80, height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(radius: 4)
                
                VStack(alignment: .leading) {
                    Text("Selected Color")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    ColorPicker("Pick a color", selection: $selectedColor)
                        .labelsHidden()
                }
                
                Spacer()
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))
            
            Divider()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Color Formats Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Formats")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 1) {
                            ColorFormatRow(label: "HEX", value: selectedColor.toHex() ?? "N/A", onCopy: copyToClipboard)
                            ColorFormatRow(label: "RGB", value: selectedColor.toRGBString() ?? "N/A", onCopy: copyToClipboard)
                            ColorFormatRow(label: "HSL", value: selectedColor.toHSLString() ?? "N/A", onCopy: copyToClipboard)
                            ColorFormatRow(label: "CMYK", value: selectedColor.toCMYKString() ?? "N/A", onCopy: copyToClipboard)
                        }
                        .background(Color(nsColor: .controlBackgroundColor))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Shades & Tints
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shades & Tints")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 0) {
                            ForEach(-4...4, id: \.self) { i in
                                let color = selectedColor.adjust(by: CGFloat(i) * 0.1)
                                
                                Rectangle()
                                    .fill(color)
                                    .frame(height: 50)
                                    .onTapGesture {
                                        print(color)
                                        selectedColor = color
                                    }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                    }
                    
                    // History
                    VStack(alignment: .leading, spacing: 12) {
                        Text("History")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(recentColors, id: \.self) { color in
                                    Circle()
                                        .fill(color)
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            selectedColor = color
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .overlay(alignment: .bottom) {
            if showCopyConfirmation {
                Text("Copied \(copiedFormat)!")
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(radius: 4)
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onChange(of: selectedColor) { oldValue, newValue in
            addToHistory(newValue)
        }
    }
    
    func addToHistory(_ color: Color) {
        if !recentColors.contains(color) {
            recentColors.insert(color, at: 0)
            if recentColors.count > 20 {
                recentColors.removeLast()
            }
        }
    }
    
    func copyToClipboard(_ value: String, _ label: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(value, forType: .string)
        
        copiedFormat = label
        
        withAnimation {
            showCopyConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopyConfirmation = false
            }
        }
    }
}

struct ColorFormatRow: View {
    let label: String
    let value: String
    let onCopy: (String, String) -> Void
    @State private var isHovering = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 50, alignment: .leading)
            
            Text(value)
                .font(.body.monospaced())
                .textSelection(.enabled)
            
            Spacer()
            
            Button(action: { onCopy(value, label) }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.borderless)
            .opacity(isHovering ? 1 : 0)
        }
        .padding()
        .background(isHovering ? Color.primary.opacity(0.05) : Color.clear)
        .onHover { hover in
            isHovering = hover
        }
    }
}
