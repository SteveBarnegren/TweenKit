// swift-tools-version:5.1
import PackageDescription

let package = Package(name: "TweenKit",
                      platforms: [.macOS(.v10_14),
                                  .iOS(.v9),
                                  .tvOS(.v9)],
                      products: [.library(name: "TweenKit",
                                          targets: ["TweenKit"])],
                      targets: [.target(name: "TweenKit",
                                        path: "TweenKit/TweenKit"),
                                .testTarget(name: "TweenKitTests",
                                            dependencies: ["TweenKit"],
                                            path: "TweenKit/TweenKitTests")],
                      swiftLanguageVersions: [.v5])
