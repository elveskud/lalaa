import SwiftUI
import CoreData

struct OurDishes: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var dishesModel = DishesModel()
    @State private var showAlert = false
    @State var searchText = ""
    
    
    var body: some View {
        VStack {
            LittleLemonLogo()
                .padding(.bottom, 10)
                .padding(.top, 50)
            
            Text ("Tap to order")
                .foregroundColor(.black)
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 8)
                .background(Color("approvedYellow"))
                .cornerRadius(20)
            
            
            NavigationView {
                FetchedObjects(
                    predicate:buildPredicate(),
                    sortDescriptors: buildSortDescriptors()) {
                        (dishes: [Dish]) in
                        List {
                            ForEach(dishes){
                                item in DisplayDish(item).onTapGesture {
                                    showAlert.toggle()
                                }
                            }
                        }
                    }
            }.navigationTitle("Dishes")
            .searchable(text: $searchText, prompt: "Search Dishes")
            
            // SwiftUI has this space between the title and the list
            // that is amost impossible to remove without incurring
            // into complex steps that run out of the scope of this
            // course, so, this is a hack, to bring the list up
            // try to comment this line and see what happens.
            .padding(.top, -10)//
            
            .alert("Order placed, thanks!",
                   isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
            // makes the list background invisible, default is gray
                   .scrollContentBackground(.hidden)
            
            // runs when the view appears
                   .task {
                       await dishesModel.reload(viewContext)
                   }
            
        }
    }
    // Helper function to build the predicate based on search text
     func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true) // No filtering when search text is empty
        } else {
            // Filter dishes by name containing search text (case-insensitive)
            return NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
    }
    
    // Helper function to build the sort descriptors
     func buildSortDescriptors() -> [NSSortDescriptor] {
         // Sort descriptor for sorting by `name` in ascending order
           let sortDescriptor = NSSortDescriptor(
               key: "name",
               ascending: true,
               selector: #selector(NSString.localizedStandardCompare(_:))
           )
           
           return [sortDescriptor]
    }
}

struct OurDishes_Previews: PreviewProvider {
    static var previews: some View {
        OurDishes()
    }
}






