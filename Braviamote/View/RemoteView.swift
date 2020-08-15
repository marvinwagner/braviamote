//
//  ContentView.swift
//  Braviamote
//
//  Created by Marvin Wagner on 16/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State var showBack = false

    let sample1 = "If you know you have an unpleasant nature and dislike people, this is no obstacle to work."
    let sample2 = "One thing is for sure – a sheep is not a creature of the air."

    var body : some View {

        let front = FrontCard {
            withAnimation(Animation.linear(duration: 0.3)) {
                  self.showBack.toggle()
            }
        }
        let back = CardFace(text: sample2, background: Color.green)
//        let resetBackButton = Button(action: { self.showBack = true }) { Text("Back")}.disabled(showBack == true)
//        let resetFrontButton = Button(action: { self.showBack = false }) { Text("Front")}.disabled(showBack == false)
//        let animatedToggle = Button(action: {
//              withAnimation(Animation.linear(duration: 0.8)) {
//                    self.showBack.toggle()
//              }
//        }) { Text("Toggle")}


        return FlipView(front: front, back: back, showBack: $showBack)
    }
}


struct FlipView<SomeTypeOfViewA : View, SomeTypeOfViewB : View> : View {

    var front : SomeTypeOfViewA
    var back : SomeTypeOfViewB

    @State private var flipped = false
    @Binding var showBack : Bool

    var body: some View {

        return VStack {
              Spacer()

              ZStack() {
                    front.opacity(flipped ? 0.0 : 1.0)
                    back.opacity(flipped ? 1.0 : 0.0)
              }
              .modifier(FlipEffect(flipped: $flipped, angle: showBack ? 180 : 0, axis: (x: 0, y: 1)))
              .onTapGesture {
                    withAnimation(Animation.linear(duration: 0.8)) {
                          self.showBack.toggle()
                    }
              }
              Spacer()
        }
    }
}

struct CardFace<SomeTypeOfView : View> : View {
      var text : String
      var background: SomeTypeOfView

      var body: some View {
            Text(text)
                  .multilineTextAlignment(.center)
                  .padding(5).frame(width: 250, height: 150).background(background)
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().previewDevice("iPhone Xr")
    }
}

struct FlipEffect: GeometryEffect {

      var animatableData: Double {
            get { angle }
            set { angle = newValue }
      }

      @Binding var flipped: Bool
      var angle: Double
      let axis: (x: CGFloat, y: CGFloat)

      func effectValue(size: CGSize) -> ProjectionTransform {

            DispatchQueue.main.async {
                  self.flipped = self.angle >= 90 && self.angle < 270
            }

            let tweakedAngle = flipped ? -180 + angle : angle
            let a = CGFloat(Angle(degrees: tweakedAngle).radians)

            var transform3d = CATransform3DIdentity;
            transform3d.m34 = -1/max(size.width, size.height)

            transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}

struct FrontCard : View {
    var closure : ()->Void
    
      var body: some View {
           ZStack {
            LinearGradient(Color.darkStart, Color.darkEnd).edgesIgnoringSafeArea(.all)

               VStack(spacing: 20) {
                    Button(action: {
                        self.closure()
//                        DispatchQueue.main.async {
//                            self.flipped.toggle()
//                        }
                    }) {
                        Text("Flip")
                    }
                
                   HStack(spacing: 20) {


                       ZStack(alignment: .topTrailing) {
                           
                           Text("")
                           
                           VStack(alignment: .leading) {
                               Text("Sony Bravia")
                               Text("self.tv.volumeDescription").frame(width: 180, alignment: .leading)
                           }
                       }
                       .padding(20)
                       .background(
                           RoundedRectangle(cornerRadius: 20)
                               .fill(Color.gray)
                               .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
                               .shadow(color: Color.gray.opacity(0.3), radius: 10, x: -10, y: -10)
                       )
                    }
                }
            }
      }
}

struct BackCard : View {
      var body: some View {
            Text("If you know you have an unpleasant nature and dislike people, this is no obstacle to work.").padding(5).frame(width: 250, height: 150).background(Color.green)
      }
}
