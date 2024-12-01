import SwiftUI
import SwiftData
import Combine

struct CreateTransferView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var coordinator: Coordinator
    @State private var isPickerPresented = false
    @State private var selectedImages: [UIImage] = []
    @Query private var items: [PhotoItem]
    @State private var showLimitAlert = false
    @State private var isUploadVisible = false
    @State private var cancellable = Set<AnyCancellable>()

    private let maxFileSizeMB = 32.0
    private var fileSizeCalculator = FileSizeCalculator(maxFileSizeMB: 32.0)
    
    @StateObject private var viewModel = CreateTransferViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if items.isEmpty {
                    EmptyStateView
                } else {
                    FileListView
                }
            }
            .padding(.top, 20)
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle("Create Transfer")
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(selectedImages: $selectedImages)
                    .onDisappear {
                        handleSelectedImages()
                    }
            }
            .alert("File Size Limit Exceeded", isPresented: $showLimitAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("The total size of files cannot exceed \(maxFileSizeMB) MB.")
            }
        }
        .task {
            subscribeToViewModel()
        }
    }
    
    // MARK: - Subviews
    private var EmptyStateView: some View {
        VStack {
            UploadButtonView(action: {
                isPickerPresented = true
            })
            .padding()
            .frame(maxWidth: .infinity, minHeight: 200)
            .background(AppColors.hexF8F8F8.color)
            .cornerRadius(20)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var FileListView: some View {
        VStack {
            FilesScrollView(
                items: items,
                totalFileSize: fileSizeCalculator.calculateTotalFileSize(items: items),
                onAddButtonTapped: {
                    isPickerPresented = true
                },
                onShowAllFilesButtonTapped: {
                    coordinator.push(page: .filesPage)
                },
                onDelete: deletePhoto
            )
            .padding()
            .frame(maxWidth: .infinity, minHeight: 200)
            .background(AppColors.hexF8F8F8.color)
            .cornerRadius(20)
            .padding(.horizontal)
            
            Spacer()
            
            if viewModel.isUploadingFinished {
                TransferButton
            } else {
                ProgressView(progress: $viewModel.progress, count: .constant(items.count))
                    .offset(y: isUploadVisible ? 0 : UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 0.4), value: isUploadVisible)
                    .padding(.horizontal)
            }
        }
    }
    
    private var TransferButton: some View {
        Button(action: {
            isUploadVisible = true
            viewModel.uploadImages(items)
        }) {
            Text("Transfer")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.hex3768EC.color)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Methods
    private func handleSelectedImages() {
        if fileSizeCalculator.canAddSelectedImages(items: items, selectedImages: selectedImages) {
            saveImagesToSwiftData()
        } else {
            showLimitAlert = true
            selectedImages.removeAll()
        }
    }
    
    private func saveImagesToSwiftData() {
        for image in selectedImages {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
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
    
    private func subscribeToViewModel() {
        viewModel.$needCleanDataBase
            .receive(on: DispatchQueue.main)
            .sink { isUploadingFinished in
                if isUploadingFinished {
                    self.deletePhotos()
                }
            }
            .store(in: &cancellable)
    }
    
    private func deletePhotos() {
        for item in items {
            deletePhoto(item: item)
        }
    }
}
