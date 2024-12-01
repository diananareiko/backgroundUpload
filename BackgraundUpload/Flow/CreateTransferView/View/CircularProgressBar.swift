import SwiftUI

struct CircularProgressBar: View {
    
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.3)
                .foregroundColor(AppColors.hex3768EC.color)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .foregroundColor(AppColors.hex3768EC.color)
                .rotationEffect(.degrees(-90))
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(AppColors.hex3768EC.color)
                .bold()
        }
        .frame(width: 50, height: 50)
    }
}
