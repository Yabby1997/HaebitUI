import ProjectDescription

let targets: [Target] = [
    Target(
        name: "HaebitUI",
        platform: .iOS,
        product: .framework,
        bundleId: "com.seunghun.haebitui",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        sources: ["HaebitUI/Sources/**"],
        settings: .settings(
            base: ["SWIFT_STRICT_CONCURRENCY": "complete"]
        )
    ),
    Target(
        name: "HaebitUIDemo",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebitui.demo",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: .extendingDefault(with: ["UILaunchStoryboardName": "LaunchScreen",]),
        sources: ["HaebitUIDemo/Sources/**"],
        resources: ["HaebitUIDemo/Resources/**"],
        dependencies: [
            .target(name: "HaebitUI"),
        ],
        settings: .settings(
            base: [
                "DEVELOPMENT_TEAM": "5HZQ3M82FA",
                "SWIFT_STRICT_CONCURRENCY": "complete"
            ],
            defaultSettings: .recommended
        )
    )
]

let project = Project(
    name: "HaebitUI",
    organizationName: "seunghun",
    targets: targets
)
