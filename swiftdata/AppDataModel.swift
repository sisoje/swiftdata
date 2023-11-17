//
//  AppDataModel.swift
//  swiftdata
//
//  Created by Lazar Otasevic on 17.11.23..
//

import SwiftUI
import ViewModelify

@ViewModelify
@propertyWrapper struct AppDataModel: DynamicProperty {
    @AppStorage("user") var username: String = ""
    @AppStorage("host") var host: String = ""
    var email: String { "\(username)@\(host)" }
}

struct AppDataView: View {
    @AppDataModel var model
    var body: some View {
        VStack {
            TextField("user", text: model.$username)
            TextField("host", text: model.$host)
            Text("Email: \(model.email)")
        }
    }
}
