import SwiftUI
import CardStack

struct Photo: Identifiable {
    let id = UUID()
    let image: UIImage
    
    static let mock: [Photo] = [
        Photo(image: UIImage(named: "sc1")!),
        Photo(image: UIImage(named: "sc2")!),
        Photo(image: UIImage(named: "sc3")!),
        Photo(image: UIImage(named: "sc4")!),
        Photo(image: UIImage(named: "1")!),
        Photo(image: UIImage(named: "2")!),
        Photo(image: UIImage(named: "3")!),
        Photo(image: UIImage(named: "4")!),
        Photo(image: UIImage(named: "5")!)
    ]
}

struct CardView: View {
    let photo: Photo
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Image(uiImage: self.photo.image)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: geo.size.width)
                    .clipped()
            }
            .cornerRadius(12)
            .shadow(radius: 4)
        }
        .padding()
    }
}


struct MainLabelingView: View {
    @State var data: [Photo] = Photo.mock
  
    var body: some View {
        VStack {
            CardStack(
                direction: LeftRight.direction,
                data: data,
                onSwipe: { card, direction in
                    print("Swiped \(direction)")
        
                    if direction == .right
                    {
                        print("오른쪽 : 라벨 추가")
                    }
                    
                },
                content: { photo,_,_  in
                    CardView(photo: photo)
                }
            )
            .padding()
            .scaledToFit()
            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("N")
                }).padding(50.0)
                
                Button(action: {
                    
                }, label: {
                    Text("Y")
                }).padding(50.0)
            }.padding(30)
            }
        }
    }
    
    
struct MainLabelingView_Previews: PreviewProvider {
    static var previews: some View {
        MainLabelingView()
    }
}
 
