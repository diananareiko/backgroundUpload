import Combine

class CreateTransferViewModel: ObservableObject {
    
    @Published var progress = 0.0
    @Published var isUploadingFinished = true
    @Published var needCleanDataBase = false

    @Injected var apiClient: UploadImagesServiceProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    func uploadImages(_ images: [PhotoItem]) {
        let imagesData = images.map { $0.imageData! }
        isUploadingFinished = false
        apiClient?.uploadImages(imagesData).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.isUploadingFinished = true
                self.needCleanDataBase = true
            case .failure:
                self.isUploadingFinished = true
            }
        }, receiveValue: { progress in
            self.progress = progress
        }).store(in: &cancellable)
    }
}
