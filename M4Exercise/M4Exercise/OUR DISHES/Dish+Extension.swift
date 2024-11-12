import Foundation
import CoreData

extension Dish {

    // Function to check if a dish already exists in the database
    static func doesDishExist(title: String, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", title)
        fetchRequest.fetchLimit = 1

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking if dish exists: \(error)")
            return false
        }
    }

    // Function to create dishes from menu items
    static func createDishesFrom(menuItems: [MenuItem], _ context: NSManagedObjectContext) {
        for menuItem in menuItems {
            // Check if the dish already exists
            if !doesDishExist(title: menuItem.title, in: context) {
                // Create a new Dish object
                let dish = Dish(context: context)
                dish.name = menuItem.title
                dish.price = Float(menuItem.price) ?? 0
                // Populate other properties if necessary

                print("Created new dish: \(dish.name ?? "")")
            }
        }
        
        // Save the context to persist new dishes
        do {
            try context.save()
        } catch {
            print("Error saving new dishes to Core Data: \(error)")
        }
    }
}
