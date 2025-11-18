import SwiftUI
import PhotosUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: TimerManager
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // App Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About ReMind")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("ReMind is a beautiful timer app that helps you stay on track with notifications.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Set target times for your daily activities, and receive notifications within ±15 minutes of your chosen time. The randomness helps create natural, less predictable reminders.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // How to Use
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How to Use")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 12) {
                                Text("1.")
                                    .fontWeight(.medium)
                                Text("Tap on the time to set your target time")
                            }
                            
                            HStack(alignment: .top, spacing: 12) {
                                Text("2.")
                                    .fontWeight(.medium)
                                Text("Enter a custom notification message")
                            }
                            
                            HStack(alignment: .top, spacing: 12) {
                                Text("3.")
                                    .fontWeight(.medium)
                                Text("Tap + button to add new reminders")
                            }
                            
                            HStack(alignment: .top, spacing: 12) {
                                Text("4.")
                                    .fontWeight(.medium)
                                Text("Swipe left on a timer card to delete it")
                            }
                            
                            HStack(alignment: .top, spacing: 12) {
                                Text("5.")
                                    .fontWeight(.medium)
                                Text("Notifications will fire daily within ±15 minutes of your set time (or exactly on time in Strict Mode)")
                            }
                        }
                        .font(.body)
                        .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Settings
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Settings")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        // Time Format
                        Toggle(isOn: $manager.use24HourFormat) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("24-Hour Format")
                                    .font(.body)
                                Text("Use military time instead of AM/PM")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .tint($manager.backgroundColor.wrappedValue)
                        
                        Divider()
                        
                        // Background Settings
                        VStack(alignment: .leading, spacing: 16) {
                            ColorPicker("Background Color", selection: $manager.backgroundColor, supportsOpacity: false)
                            
                            Divider()
                            
                            ColorPicker("Text Color", selection: $manager.textColor, supportsOpacity: false)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Background Image")
                                    .font(.headline)
                                
                                if let image = manager.backgroundImage {
                                    HStack {
                                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                                .clipped()
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                                )
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Current Image")
                                                .font(.subheadline)
                                            Text("Tap image to change")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(role: .destructive) {
                                            manager.backgroundImage = nil
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                } else {
                                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                        HStack {
                                            Image(systemName: "photo.badge.plus")
                                                .font(.title3)
                                            Text("Add Background Image")
                                                .font(.body)
                                        }
                                        .foregroundColor(.blue)
                                    }
                                }
                                
                                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                    EmptyView()
                                }
                                .onChange(of: selectedPhoto) { newValue in
                                    Task {
                                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                                           let image = UIImage(data: data) {
                                            manager.backgroundImage = image
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(24)
            }
            .navigationTitle("Info & Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
