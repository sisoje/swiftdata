//
//  AppDataModel.swift
//  swiftdata
//
//  Created by Lazar Otasevic on 17.11.23..
//

import ViewModelify
import SwiftData
import SwiftUI
import Combine

@ViewModelify
@propertyWrapper struct AppDataModel: DynamicProperty {
    @AppStorage("user") var username: String = ""
    @AppStorage("host") var host: String = ""
    
    var email: String { "\(username)@\(host)" }
}


struct AppDataView: View {
    @AppDataModel var model
    var body: some View {
        TextField("user", text: model.$username)
        TextField("host", text: model.$host)
        Text("Email: \(model.email)")
    }
}
