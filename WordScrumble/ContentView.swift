//
//  ContentView.swift
//  WordScrumble
//
//  Created by administrator on 09/06/2021.
//

import SwiftUI

struct ContentView: View {
	@State private var inputWord: String = ""
	@State private var answerList: Array<String> = [String]()
	@State private var score = 0
	
	@State private var showAlert = false
	@State private var alertMessage = ""
	
	@State private var rootWord: String = { () -> String in
				if let wordCollectionUrl = Bundle.main.url(forResource: "wordsCollection", withExtension: "txt"){
					if let wordCollectionFileString = try? String(contentsOf: wordCollectionUrl){
						let wordsList = wordCollectionFileString.components(separatedBy: "\n")
						return wordsList.randomElement()?.uppercased() ?? "Emptyword".uppercased()
					}
					return "NoStringAvailable"
				}
				return "errorHappnedInFileUrl"
	}()
	
	
	var body: some View {
		NavigationView{
			
			VStack(alignment: .center, spacing: 30){
				VStack(alignment: .center, spacing: 30){
					Text("\(rootWord)")
						.font(.largeTitle)
					Text("Score: \(score)")
				}
				.padding()
				
				TextField("Enter the word", text: $inputWord, onCommit: listUpdate)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.foregroundColor(.blue)
					.background(Color(.gray))
					.cornerRadius(40)
					.padding()
				
				List(0..<answerList.count, id: \.self){num in
					 HStack{
						Image(systemName: "\(answerList.count - num).circle")
						Text("\(answerList[num])")
						
					}
				}
				.padding()
				
		}
			
			.alert(isPresented: $showAlert){
				Alert(title: Text("Invalid Word"), message: Text("\(alertMessage)"), dismissButton: .default(Text("Retry")))
			}
			
			.navigationBarTitle("WordScramble", displayMode:  .inline)
			.navigationBarItems(trailing: Button(action: {tappedRestart()}){
				Text("Restart")
					.font(.title2)
			})
			
		}
			
		
	}
	
	func tappedRestart(){
		rootWord = { () -> String in
					if let wordCollectionUrl = Bundle.main.url(forResource: "wordsCollection", withExtension: "txt"){
						if let wordCollectionFileString = try? String(contentsOf: wordCollectionUrl){
							let wordsList = wordCollectionFileString.components(separatedBy: "\n")
							return wordsList.randomElement()?.uppercased() ?? "Emptyword".uppercased()
						}
						return "NoStringAvailable"
					}
					return "errorHappnedInFileUrl"
		}()
		self.inputWord = ""
		self.answerList = [String]()
		self.score = 0
		
	}
	
	
	func listUpdate(){
		if isOriginal(inputWord){
			if isPossible(inputWord){
				if isReal(inputWord){
					self.answerList.insert(self.inputWord.uppercased(), at: 0)
					self.inputWord = ""
					self.score += 1
					return
				}
				self.alertMessage = "Its a made up word"
				self.showAlert = true
				self.inputWord = ""
				return
			}
			self.alertMessage = "This word contains an invalid letter"
			self.showAlert = true
			self.inputWord = ""
			return
		}
		self.alertMessage = "Don't repeat words please!"
		self.showAlert = true
		self.inputWord = ""
	}
	
	func isOriginal(_ word: String) -> Bool{
		return !self.answerList.contains(word.uppercased())
	}
	func isPossible(_ word: String) -> Bool{
		let tempWord = self.rootWord
		for letter in word.uppercased(){
			if (tempWord.firstIndex(of: letter) == nil){
				return false
			}
		}
		return true
	}
	func isReal(_ word:String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.uppercased().utf16.count)
		let misspelled = checker.rangeOfMisspelledWord(in: word.uppercased(), range: range, startingAt: 0, wrap: false, language: "en")
		return misspelled.location == NSNotFound
		
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
