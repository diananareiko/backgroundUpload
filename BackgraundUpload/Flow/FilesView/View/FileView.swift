import SwiftUI

struct FileView: View {
    let item: PhotoItem
    let totalFileSize: String
    let onDelete: (PhotoItem) -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                if let imageData = item.imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: .infinity, height: 100)
                        .clipped()
                } else {
                    Color.gray
                        .frame(height: 100)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(totalFileSize)")
                        .font(.subheadline)
                        .padding()
                }
            }.frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 1)
            Button(action: {
                onDelete(item)
            }) {
                AppIcons.close.image
                    .foregroundColor(AppColors.hex3768EC.color)
                    .background(Color.white)
                    .clipShape(Circle())
                    .offset(x: -10, y: 10)
            }
        }
    }
}
