import SwiftUI

struct FilesScrollView: View {
    let items: [PhotoItem]
    let totalFileSize: String
    let onAddButtonTapped: () -> Void
    let onShowAllFilesButtonTapped: () -> Void
    let onDelete: (PhotoItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Files")
                    .font(.headline)
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    onShowAllFilesButtonTapped()
                }) {
                    AppIcons.chevronRight.image
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button(action: {
                        onAddButtonTapped()
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(width: 100, height: 100)
                            .overlay {
                                AppIcons.plus.image
                                    .font(.title)
                                    .foregroundColor(.gray)
                            }
                    }
                    
                    ForEach(items, id: \.id) { item in
                        if let imageData = item.imageData, let image = UIImage(data: imageData) {
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(25)
                                Button(action: {
                                    onDelete(item)
                                }) {
                                    AppIcons.close.image
                                        .foregroundColor(AppColors.hex3768EC.color)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .offset(x: -5, y: 5)
                                }
                            }
                        }
                    }
                }
            }
            VStack(alignment: .leading) {
                Text("\(items.count) files added")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(.horizontal)
                Text("\(totalFileSize) of 32 MB used")
                    .foregroundColor(AppColors.hex757575.color)
                    .font(.subheadline)
                    .padding(.horizontal)
            }
        }
    }
}

