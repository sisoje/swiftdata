# There is no view
There is an article on [hacking with swift](https://www.hackingwithswift.com/quick-start/swiftdata/how-to-use-mvvm-to-separate-swiftdata-from-your-views) about SwiftData. This article shows you the wrong way of separating SwiftData from the SwiftUI.View. It proves to be a failure because it does not work completely and there is a conclusion:

> a number of people have said outright that they think **MVVM is dead with SwiftData**

### MVVM is dead with SwiftUI
Sadly most of iOS dev community started pushing MVVM into SwiftUI, probably influenced by past experiences.
General MVVM approach is abusing observable **objects** to decouple business logic from the SwiftUI.View.
That way of decoupling is just moving code in a circle and breaking basic principles of SwiftUI.

### Decoupling is (kinda) good
Decoupling is good if plan to reuse components and test them in isolation. But why bother testing the code that is broken by design? And when its broken by design then we can not even reuse it properly. It makes a mess inside the project once again.

### SwiftUI.View is not a real view
We can not use any of the **MV** patterns because we dont have a view. In general we have have a model (struct) and a body (function). Model conforms to SwiftUI.View and body returns a SwiftUI.View.

### Apple killed the view
SwiftUI.View has no properties of a view, no frame, no colors, no nothing. Its just a protocol. Apple never uses the term `viewModel` because they know there is no view, they just use a term `model` instead.

### Business logic and values
Model represents a state and then entire body **is** the business logic. SwiftUI.View is required to be a **value** type. Only from value types you can access environment. Thats why using observable **object** is breaking the basics of SwiftUI and you should not move business logic code into a class.

## Decoupling correctly
Decoupled is not always the best. But if we still decide to decouple business logic from the SwiftUI.View then we have to make components that are a value type, a struct. This can be achieved using `DynamicProperty` like this:
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
[@ViewModelify](https://github.com/sisoje/viewmodelify-swift) is just a small macro that implements boilerplate code for us:
- wrappedValue required for DynamicProperty
- inspect property required by [ViewInspector](https://github.com/nalexn/ViewInspector)
- dummy view protocol extension required for testing

## Testing
I use a great package [ViewInspector](https://github.com/nalexn/ViewInspector) for unit testing. Basically there is no other way to properly test **models** with `@State` inside. Here is a test:
```
var model = SwiftDataModel()
let exp = model.on(\.inspect) { view in
    let model = try view.actualView() // conforms to View
    XCTAssertEqual(model.items.count, 0)
    try model.addItem()
    XCTAssertEqual(model.items.count, 1)
    try model.deleteItems(offsets: .init(integer: 0))
    XCTAssertEqual(model.items.count, 0)
}
ViewHosting.host(
    view: model.environment(\.modelContext, modelContainer.mainContext) // environment works
)
wait(for: [exp], timeout: 1)
```
# Special thanks to Apple for providing SwiftData!
