import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let appCoordinator = AppCoordinator(window: window)
        let startPage = ModuleFactory.makeStartPageModule(appCoordinator: appCoordinator)
        let mainScreen = CustomNavigationController(rootViewController: startPage)
        window?.rootViewController = mainScreen
        window?.makeKeyAndVisible()
    }
}

