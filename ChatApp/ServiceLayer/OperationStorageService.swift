//
//  SavingByOperations.swift
//  ChatApp
//
//  Created by Anna Belousova on 23.03.2022.
//

import UIKit

class OperationStorageService: IStorageService {
    
    let fileManagerStorage: IFileManagerStorage
    
    init(fileManagerStorage: IFileManagerStorage) {
        self.fileManagerStorage = fileManagerStorage
    }
    
    let operationQueue = OperationQueue()
    
    func writeData(fullName: String?, description: String?, image: UIImage?, _ completion: @escaping(Bool) -> Void) {
        let writeDataOperation = WriteDataOperation(fullName: fullName, profileDescription: description, image: image, fileManagerStorage: fileManagerStorage)
        writeDataOperation.completionBlock = {
            guard let result = writeDataOperation.boolResult else { return }
            completion(result)
        }
        operationQueue.addOperation(writeDataOperation)
    }
    
    func getStoredString(fileName: String, _ completion: @escaping (String) -> Void) {
        let getStoredDataOperation = GetStoredDataOperation(fileName: fileName, fileManagerStorage: fileManagerStorage)
        getStoredDataOperation.completionBlock = {
            completion(getStoredDataOperation.storedString ?? "")
        }
        operationQueue.addOperation(getStoredDataOperation)
    }
    
    func getStoredImage(_ completion: @escaping (UIImage) -> Void) {
        let getStoredDataOperation = GetStoredDataOperation(fileName: "", fileManagerStorage: fileManagerStorage)
        getStoredDataOperation.completionBlock = {
            completion(getStoredDataOperation.storedImage ?? UIImage())
        }
        operationQueue.addOperation(getStoredDataOperation)
    }
}

class WriteDataOperation: AsyncOperation {
    private let fullName: String?
    private let profileDescription: String?
    private let image: UIImage?
    var boolResult: Bool?
    
    init(fullName: String?, profileDescription: String?, image: UIImage?, fileManagerStorage: IFileManagerStorage) {
        self.fullName = fullName
        self.profileDescription = profileDescription
        self.image = image
        super.init(fileManagerStorage: fileManagerStorage)
    }
    
    override func main() {
        if isCancelled {
            state = .finished
            return
        }
        fileManagerStorage.writeData(fullName: fullName, description: profileDescription, image: image) { [weak self] bool in
            self?.boolResult = bool
            self?.state = .finished
        }
    }
}

class GetStoredDataOperation: AsyncOperation {
    private let fileName: String
    var storedString: String?
    var storedImage: UIImage?
    
    init(fileName: String, fileManagerStorage: IFileManagerStorage) {
        self.fileName = fileName
        super.init(fileManagerStorage: fileManagerStorage)
    }
    
    override func main() {
        if isCancelled {
            state = .finished
            return
        }
        if fileName != "" {
            fileManagerStorage.getStoredString(fileName: fileName) { [weak self] string in
                self?.storedString = string
                self?.state = .finished
            }
        } else {
            fileManagerStorage.getStoredImage { [weak self] image in
                self?.storedImage = image
                self?.state = .finished
            }
        }
    }
}

class AsyncOperation: Operation {
    
    let fileManagerStorage: IFileManagerStorage
    
    init(fileManagerStorage: IFileManagerStorage) {
        self.fileManagerStorage = fileManagerStorage
    }
    
    enum State: String {
        case ready, executing, finished, cancelled
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isCancelled: Bool {
        return state == .cancelled
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .cancelled
    }
}
