import Combine
import Foundation

protocol APIServiceProtocol {

    var backgroundCompletionHandler: (() -> Void)? { get set }
    func upload<T: Decodable>(target: TargetType, uid: UUID, from file: URL) -> AnyPublisher<T, APIServiceError>
}

class APIService: NSObject, APIServiceProtocol, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    private var urlSession: URLSession!
    private var taskToResultMap: [URLSessionTask: PassthroughSubject<Data, APIServiceError>] = [:]
    private var taskToResponseDataMap: [URLSessionTask: Data] = [:] // For storing received response data
    var backgroundCompletionHandler: (() -> Void)?

    override init() {
        super.init()
        let appBundleName = Bundle.main.bundleURL.lastPathComponent.lowercased().replacingOccurrences(of: " ", with: ".")
        let configuration = URLSessionConfiguration.background(withIdentifier: appBundleName)
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = false
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    // MARK: - APIServiceProtocol
    
    func upload<T: Decodable>(target: TargetType, uid: UUID, from file: URL) -> AnyPublisher<T, APIServiceError> {
        guard var request = try? target.createURLRequest() else {
            return Fail(error: APIServiceError.requestCreationError).eraseToAnyPublisher()
        }
        
        request.setValue("multipart/form-data; boundary=\(uid.uuidString)", forHTTPHeaderField: "Content-Type")
        let uploadTask = urlSession.uploadTask(with: request, fromFile: file)
        
        let resultSubject = PassthroughSubject<Data, APIServiceError>()
        taskToResultMap[uploadTask] = resultSubject
        
        uploadTask.resume()
        
        return resultSubject
            .tryMap { data in
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            }
            .mapError { error in
                error as? APIServiceError ?? APIServiceError.responseError
            }
            .eraseToAnyPublisher()
    }

    // MARK: - URLSessionTaskDelegate

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let resultSubject = taskToResultMap[task] else { return }
        
        defer {
            print("Task \(task.taskIdentifier) completed.")
            taskToResultMap.removeValue(forKey: task)
            taskToResponseDataMap.removeValue(forKey: task)
        }

        if let error = error {
            print("Task \(task.taskIdentifier) completed with error: \(error.localizedDescription)")
            resultSubject.send(completion: .failure(.responseError))
            return
        }

        guard let httpResponse = task.response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode),
              let responseData = taskToResponseDataMap[task] else {
            print("Task \(task.taskIdentifier) failed: invalid response or no data")
            resultSubject.send(completion: .failure(.responseError))
            return
        }

        print("Task \(task.taskIdentifier) completed successfully.")
        resultSubject.send(responseData)
        resultSubject.send(completion: .finished)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        print("Task \(task.taskIdentifier): Upload progress: \(progress * 100)%")
    }

    // MARK: - URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let existingData = taskToResponseDataMap[dataTask] {
            taskToResponseDataMap[dataTask] = existingData + data
        } else {
            taskToResponseDataMap[dataTask] = data
        }
    }

    // MARK: - URLSessionDelegate (Optional for Background Handling)
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("Background tasks finished")
        backgroundCompletionHandler?()
        backgroundCompletionHandler = nil
    }
}
