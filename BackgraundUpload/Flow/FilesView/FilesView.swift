import SwiftUI
import SwiftData

struct FilesView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var coordinator: Coordinator
    @Query private var items: [PhotoItem]
    @State private var isPickerPresented = false
    @State private var selectedImages: [UIImage] = []
    @State private var showLimitAlert = false
    
    private let maxFileSizeMB = 32.0
    private var fileSizeCalculator = FileSizeCalculator(maxFileSizeMB: 32.0)
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(items) { item in
                            FileView(item: item,
                                     totalFileSize: fileSizeCalculator.calculateTotalFileSize(items: [item])) { item in
                                deletePhoto(item: item)
                            }
                        }
                    }.padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.pop()
                }) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(AppColors.hex3768EC.color)
                                .frame(width: 30, height: 30)
                            AppIcons.chevronLeft.image
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isPickerPresented = true
                }) {
                    Text("Add Files")
                        .font(.headline)
                        .foregroundColor(AppColors.hex3768EC.color)
                }
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            PhotoPicker(selectedImages: $selectedImages)
                .onDisappear {
                    if fileSizeCalculator.canAddSelectedImages(items: items, selectedImages: selectedImages) {
                        saveImagesToSwiftData()
                    } else {
                        showLimitAlert = true
                        selectedImages.removeAll()
                    }
                }
        }
        .alert("File Size Limit Exceeded", isPresented: $showLimitAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The total size of files cannot exceed \(maxFileSizeMB) MB.")
        }
    }
    
    private func saveImagesToSwiftData() {
        for image in selectedImages {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let newPhoto = PhotoItem(imageData: imageData)
                modelContext.insert(newPhoto)
            }
        }
        do {
            try modelContext.save()
            selectedImages.removeAll()
        } catch {
            print("Failed to save images: \(error)")
        }
    }
    
    private func deletePhoto(item: PhotoItem) {
        modelContext.delete(item)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete photo: \(error)")
        }
    }
}

#Preview {
    FilesView().modelContainer(for: PhotoItem.self, inMemory: true)
}
