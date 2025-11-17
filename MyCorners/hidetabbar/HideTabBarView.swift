//import SwiftUI
//import SwiftUIIntrospect
//
//struct HideTabBarView<Content: View>: View {
//    let content: Content
//    
//    init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//    
//    var body: some View {
//        content
//            .introspect(.tabView, on: .iOS(.v16, .v17, .v18)) { tabBarController in
//                tabBarController.tabBar.isHidden = true
//            }
//    }
//}
