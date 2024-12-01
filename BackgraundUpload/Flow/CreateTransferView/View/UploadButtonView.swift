import SwiftUI

struct UploadButtonView: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                AppIcons.plus.image
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .padding()
                    .background(AppColors.hex3768EC.color)
                    .cornerRadius(25)
                Text("Upload files")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("Up to 32 MB")
                    .font(.subheadline)
                    .foregroundColor(AppColors.hex757575.color)
            }
        }
    }
}
