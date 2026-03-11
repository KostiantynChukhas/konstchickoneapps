import SwiftUI

struct QuizView: View {
    @EnvironmentObject var data: AppDataManager

    @State private var questions = QuizQuestion.bank.shuffled()
    @State private var currentIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showFunFact = false
    @State private var score = 0
    @State private var quizDone = false

    private var current: QuizQuestion { questions[currentIndex] }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                progressBar

                if quizDone {
                    resultsView
                } else {
                    chickenThinking
                    questionCard
                    optionsList
                    if showFunFact { funFactCard }
                    Spacer()
                    if selectedAnswer != nil { nextButton }
                }
            }
            .padding(.top)
            .navigationTitle("Cluck Quiz ❓")
        }
    }

    // MARK: — Progress

    private var progressBar: some View {
        HStack {
            ProgressView(value: Double(currentIndex), total: Double(questions.count))
                .tint(.green)
            Text("\(currentIndex)/\(questions.count)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    // MARK: — Chicken emoji

    private var chickenThinking: some View {
        Text(showFunFact ? "🤓" : "🤔")
            .font(.system(size: 64))
            .animation(.spring(), value: showFunFact)
    }

    // MARK: — Question Card

    private var questionCard: some View {
        Text(current.question)
            .font(.system(size: 18, weight: .black, design: .rounded))
            .multilineTextAlignment(.center)
            .padding(18)
            .background(Color(.systemBackground))
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.05), radius: 8)
            .padding(.horizontal)
    }

    // MARK: — Options

    private var optionsList: some View {
        VStack(spacing: 10) {
            ForEach(current.options.indices, id: \.self) { i in
                Button(action: { selectAnswer(i) }) {
                    HStack {
                        Text(["A", "B", "C", "D"][i])
                            .font(.system(size: 13, weight: .black, design: .rounded))
                            .frame(width: 28, height: 28)
                            .background(optionLetterBg(i))
                            .foregroundColor(optionLetterFg(i))
                            .cornerRadius(8)

                        Text(current.options[i])
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)

                        Spacer()

                        if let sel = selectedAnswer {
                            if i == current.correctIndex {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else if i == sel {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                            }
                        }
                    }
                    .padding(14)
                    .background(optionCardBg(i))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(optionBorder(i), lineWidth: 2)
                    )
                }
                .disabled(selectedAnswer != nil)
            }
        }
        .padding(.horizontal)
    }

    // MARK: — Fun Fact

    private var funFactCard: some View {
        Text("💡 \(current.funFact)")
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
            .padding(14)
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
    }

    // MARK: — Next Button

    private var nextButton: some View {
        Button("Next →") { nextQuestion() }
            .font(.system(size: 18, weight: .black, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.green)
            .cornerRadius(18)
            .padding(.horizontal, 32)
    }

    // MARK: — Results

    private var resultsView: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Quiz Done! 🎉")
                .font(.system(size: 32, weight: .black, design: .rounded))
            Text("\(score)/\(questions.count) correct")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.green)
            Text("+\(score * 15) 🪙 earned!")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.yellow)
            Button("Play Again 🔄") { resetQuiz() }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .font(.system(size: 18, weight: .black, design: .rounded))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: — Logic

    private func selectAnswer(_ i: Int) {
        selectedAnswer = i
        showFunFact = true
        if i == current.correctIndex {
            score += 1
            data.addCoins(15)
            data.recordCorrectAnswer()
        }
    }

    private func nextQuestion() {
        if currentIndex + 1 >= questions.count {
            quizDone = true
        } else {
            currentIndex += 1
            selectedAnswer = nil
            showFunFact = false
        }
    }

    private func resetQuiz() {
        questions = QuizQuestion.bank.shuffled()
        currentIndex = 0
        score = 0
        quizDone = false
        selectedAnswer = nil
        showFunFact = false
    }

    // MARK: — Color Helpers

    private func optionLetterBg(_ i: Int) -> Color {
        guard let sel = selectedAnswer else { return Color(.systemGray5) }
        if i == current.correctIndex { return .green }
        if i == sel { return .red }
        return Color(.systemGray5)
    }

    private func optionLetterFg(_ i: Int) -> Color {
        guard let sel = selectedAnswer else { return .secondary }
        if i == current.correctIndex || i == sel { return .white }
        return .secondary
    }

    private func optionCardBg(_ i: Int) -> Color {
        guard let sel = selectedAnswer else { return Color(.systemBackground) }
        if i == current.correctIndex { return .green.opacity(0.08) }
        if i == sel { return .red.opacity(0.08) }
        return Color(.systemBackground)
    }

    private func optionBorder(_ i: Int) -> Color {
        guard let sel = selectedAnswer else { return Color(.systemGray4) }
        if i == current.correctIndex { return .green }
        if i == sel { return .red }
        return Color(.systemGray5)
    }
}
