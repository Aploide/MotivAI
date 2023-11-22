//
//  ContentView.swift
//  MotivatIA
//
//  Created by Carlo Esposito on 14/11/23.
//

import Foundation
import SwiftUI
import UIKit


struct ContentView: View {
    
    //declaration of the variables
    @State public var quotetext = "Do the best you can, and don't take life too serious."
    
    @State public var authortext = "-Will Rogers"
    
    @State var iconcuor = "heart"
    
    @State private var dragAmount = CGSize.zero
    
    @Environment(\.colorScheme) var colorScheme
    
    //all the functions
    func SwipeUPz(){
        let category = "".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/quotes?category="+category!)!
        var request = URLRequest(url: url)
        request.setValue("n7rT0jqVQk22DHUPDf79IA==vOIbgIzDAfL5t9VK", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                if let quote = jsonResponse.first?["quote"] as? String, let author = jsonResponse.first?["author"] as? String {
                    print(quote)
                    print(author)
                    quotetext = quote
                    authortext = "-"+author
                }
            } catch let error {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }}
        task.resume()
        iconcuor = "heart"
        quotetext = "loading..."
        authortext = ""

    }
    
    func Heartz(){
        if iconcuor == "heart" {
            iconcuor = "heart.fill"
        } else{
            iconcuor = "heart"
        }
    }
    
    func getButtonColor() -> Color {
        if colorScheme == .dark {
            return Color.white
        } else {
            return Color.black
        }}
    
    var body: some View {
    
        ZStack{
                
                
                
                VStack {
                    
                    
                    Spacer()
                    
                    Spacer()
                    
                    VStack{
                        Text(quotetext).font(.custom("olyford-semibold" , size: 27)).multilineTextAlignment(.center).accessibilityIdentifier("Quote")
                        Text(authortext).font(.custom("olyford-semibold" , size: 15)).multilineTextAlignment(.center).accessibilityLabel("Author \(authortext)")
                    

                    
                    
                    

                    }.offset(y: dragAmount.height).gesture(
                        DragGesture().onChanged{dragAmount = $0.translation}
                            .onEnded{_ in dragAmount = .zero
                            SwipeUPz()})
                        
                    Spacer()
                    HStack {
                        Spacer()
                        
                        ShareLink(item: quotetext) {
                            Image(systemName: "square.and.arrow.up").scaleEffect(CGSize(width: 2.0, height: 2.0)).foregroundColor(getButtonColor())
                        }.accessibilityIdentifier("Button")
                            .accessibilityLabel("Share the caption").padding().labelsHidden()
                        
                        
                        Button(action:{Heartz()}, label: {
                            Image(systemName: iconcuor) .padding().scaleEffect(CGSize(width: 2.1, height: 2.1))
                            })
                        .foregroundColor(getButtonColor())
                        .accessibilityLabel("Add to favorites")
                        
//                            .onTapGesture {
//                            print("add to loved")
//                            Heartz()}
//                        }.accessibilityIdentifier("Button")
//                            .accessibilityLabel("Add to favorites")
                        
                        Spacer()
                    }
                    
                    
                    SwipeUpView(onSwipeUp: SwipeUPz) {
                        
                        ZStack{
                            Rectangle().frame(width: 1000, height: 150, alignment: .bottom).opacity(0.001)
                            
                            Button(action: {
                                SwipeUPz()
                            }, label: {
                                VStack {
                                    Spacer().frame(height: 80)
                                    Image(systemName: "chevron.up").scaleEffect(CGSize(width: 2.1,
                            height: 2.1))
                                }
                            })
                                .accessibilityLabel("Next Quote")
                                .foregroundColor(getButtonColor())
                            
//                           .onTapGesture {
//                                print("next quote")
//                                SwipeUPz()
//                                iconcuor = "heart"}
                                
                        }
                        
                    }
                }
                
                
        }.padding().onAppear(perform: SwipeUPz)
        
    }
}


//swipe up zone view

struct SwipeUpView<Content: View>: View {
    let onSwipeUp: () -> Void
    let content: () -> Content

    var body: some View {
        let gesture = DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded { value in
                if value.translation.height < 0 {
                    self.onSwipeUp()
                }
            }

        return ZStack {
            content()
                .gesture(gesture)
        }
    }
}

#Preview {
    ContentView()
}
