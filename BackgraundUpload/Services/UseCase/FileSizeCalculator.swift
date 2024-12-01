import SwiftUI

struct FileSizeCalculator {
    let maxFileSizeMB: Double
    
    func calculateTotalFileSize(items: [PhotoItem]) -> String {
        let totalSizeInBytes = items.reduce(0) { total, item in
            total + (item.imageData?.count ?? 0)
        }
        let sizeInMB = Double(totalSizeInBytes) / 1_048_576
        return String(format: "%.2f MB", sizeInMB)
    }
    
    func getTotalFileSizeInMB(items: [PhotoItem]) -> Double {
        let totalSizeInBytes = items.reduce(0) { total, item in
            total + (item.imageData?.count ?? 0)
        }
        return Double(totalSizeInBytes) / 1_048_576
    }
    
    func getSelectedImagesSizeInMB(selectedImages: [UIImage]) -> Double {
        let selectedSizeInBytes = selectedImages.reduce(0) { total, image in
            total + (image.jpegData(compressionQuality: 1.0)?.count ?? 0)
        }
        return Double(selectedSizeInBytes) / 1_048_576
    }
    
    func canAddSelectedImages(items: [PhotoItem], selectedImages: [UIImage]) -> Bool {
        let totalSize = getTotalFileSizeInMB(items: items) + getSelectedImagesSizeInMB(selectedImages: selectedImages)
        return totalSize <= maxFileSizeMB
    }
}
