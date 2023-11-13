# Decoupling SwiftData from the SwiftUI.View
There is an article on [hacking with swift](https://www.hackingwithswift.com/quick-start/swiftdata/how-to-use-mvvm-to-separate-swiftdata-from-your-views) about SwiftData. This article shows the wrong way of decoupling SwiftData from the SwiftUI.View. As a conclusion it says:
```
a number of people have said outright that they think MVVM is dead with SwiftData
```
Actually MVVM was dead with the first release of SwiftUI. It was just that most of community was pushing that MVVM nonsense and abusing observable **objects** to decouple business logic from the SwiftUI.View.
That way of decoupling is just moving thigs in a circle and breaking basic principles of SwiftUI.

### Apple killed the view
We can not use any of the M**V** patterns because we dont have a view. Apple never uses the term `viewModel`. We have just a model-struct and a body-function. Both of them are just a SwiftUI.View protocol. That is not a real view.
Its just some **value** that conforms to a SwiftUI.View protocol.

### Values
Its important to note that only value type can be a SwiftUI.View and can acess environment. Thats why using observable **object** is breaking the basics of SwiftUI.

### Decoupling SwiftData business logic from SwiftUI.View
If we decide to decouple business logic from the SwiftUI.View then we have to make components a value type a struct. This can be achieved using `DynamicProperty` like this:
```
@ViewModelify
@propertyWrapper struct SwiftDataModel: DynamicProperty {
    @Environment(\.modelContext) private var modelContext
    @Query var items: [Item]
    func addItem() throws {
        let newItem = Item(timestamp: Date())
        modelContext.insert(newItem)
        try modelContext.save()
    }
    func deleteItems(offsets: IndexSet) throws {
        for index in offsets {
            modelContext.delete(items[index])
        }
        try modelContext.save()
    }
}
```

# Testing
I use a great package [ViewInspector](https://github.com/nalexn/ViewInspector) for unit testing. Basically there is no other way to properly test models with `@State` inside. Here is a test:
```
var model = SwiftDataModel()
let exp = model.on(\.inspect) { view in
    let model = try view.actualView()
    XCTAssertEqual(model.items.count, 0)
    try model.addItem()
    XCTAssertEqual(model.items.count, 1)
    try model.deleteItems(offsets: .init(integer: 0))
    XCTAssertEqual(model.items.count, 0)
}
ViewHosting.host(
    view: model.environment(\.modelContext, modelContainer.mainContext)
)
wait(for: [exp], timeout: 1)
```
