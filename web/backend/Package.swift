// swift-tools-version:5.7

// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


let package = Package(

  name: "VaporShell",

  dependencies: [

    .package(url: "https://github.com/vapor/vapor.git", from: "4.76.0"),

    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),

    .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0"),

    .package(url: "https://github.com/vapor/jwt", from: "4.0.0"),

    .package(url: "https://github.com/MihaelIsaev/FCM.git", from: "2.13.0")

  ],

  targets: [

    // Targets are the basic building blocks of a package. A target can define a module or a test suite.

    // Targets can depend on other targets in this package, and on products in packages which this package depends on.

    .executableTarget(name: "EagleEngagement", dependencies: [

                                            .product(name: "Vapor", package: "vapor"),

                                            .product(name: "Fluent", package: "fluent"),

                                            .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),

                                            .product(name: "JWT", package: "jwt"),

                                            .product(name: "FCM", package: "FCM")

                                          ])

  ]


)

