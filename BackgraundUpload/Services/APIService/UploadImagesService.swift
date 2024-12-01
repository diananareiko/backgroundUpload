import Alamofire
import Combine
import Foundation

protocol UploadImagesServiceProtocol {
    
    func uploadImages(_ images: [Data]) -> AnyPublisher<Double, APIServiceError>
}

class UploadImagesService: UploadImagesServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func uploadImages(_ images: [Data]) -> AnyPublisher<Double, APIServiceError> {
        let totalImages = images.count
        let progressSubject = CurrentValueSubject<Double, APIServiceError>(0.0)

        let dispatchGroup = DispatchGroup()
        var uploadErrors: [Error] = []
        let target = ImgBBAPI.uploadImage

        var individualProgress = Array(repeating: 0.0, count: totalImages)

        for (index, imageData) in images.enumerated() {
            dispatchGroup.enter()
            let uid = UUID()
            guard let httpBody = try? createMultipartBody(imageData: imageData, boundary: uid.uuidString),
                  let temporaryFileURL = try? saveRequestBodyToTemporaryFile(httpBody) else {
                progressSubject.send(completion: .failure(.multipartEncodingFailed))
                return progressSubject.eraseToAnyPublisher()
            }
            apiService.upload(target: target, uid: uid, from: temporaryFileURL)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { uploadCompletion in
                    switch uploadCompletion {
                    case .finished:
                        individualProgress[index] = 1.0
                        let progress = individualProgress.reduce(0.0, +) / Double(totalImages)
                        progressSubject.send(progress)
                    case .failure(let error):
                        uploadErrors.append(error)
                    }
                    dispatchGroup.leave()
                }, receiveValue: { (_: EmptyResponse) in })
                .store(in: &self.cancellables)
        }

        dispatchGroup.notify(queue: .main) {
            if uploadErrors.isEmpty {
                progressSubject.send(completion: .finished)
            } else {
                progressSubject.send(completion: .failure(APIServiceError.partialFailure(uploadErrors)))
            }
        }

        return progressSubject.eraseToAnyPublisher()
    }

    private func saveRequestBodyToTemporaryFile(_ body: Data) throws -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString)
        try body.write(to: tempFileURL)
        return tempFileURL
    }
    
    private func createMultipartBody(imageData: Data, boundary: String) throws -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        let base64String = imageData.base64EncodedString()
        
        body.append(boundaryPrefix)
        body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n")
        body.append(base64String)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    private var cancellables = Set<AnyCancellable>()
}
