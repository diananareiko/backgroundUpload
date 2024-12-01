import SwiftUI

struct ProgressView: View {
    
    @Binding var progress: Double
    @Binding var count: Int

    var body: some View {
        HStack(spacing: 20){
            CircularProgressBar(progress: $progress)
                                    .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 10) {
                Text("Transferring...")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("Sending \(count) file")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }.padding()
            .background(RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(radius: 8))
    }
}

#Preview {
    ProgressView(progress: .constant(0.2), count: .constant(2))
}
