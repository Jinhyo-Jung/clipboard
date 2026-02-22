import Foundation
import ServiceManagement

enum LaunchAtLoginService {
    static func apply(enabled: Bool) -> Result<Void, Error> {
        guard #available(macOS 13.0, *) else {
            return .failure(LaunchAtLoginError.unsupportedOS)
        }

        guard Bundle.main.bundleURL.pathExtension == "app" else {
            return .failure(LaunchAtLoginError.invalidBundleContext)
        }

        guard let bundleID = Bundle.main.bundleIdentifier, bundleID.isEmpty == false else {
            return .failure(LaunchAtLoginError.missingBundleIdentifier)
        }

        let appPath = Bundle.main.bundleURL.path
        guard appPath.hasPrefix("/Applications/") else {
            return .failure(LaunchAtLoginError.appNotInstalledInApplications)
        }

        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            return .success(())
        } catch {
            let nsError = error as NSError
            if nsError.domain == NSOSStatusErrorDomain, nsError.code == -50 {
                return .failure(LaunchAtLoginError.invalidArgument(bundleID: bundleID))
            }
            return .failure(error)
        }
    }
}

enum LaunchAtLoginError: LocalizedError {
    case unsupportedOS
    case invalidBundleContext
    case missingBundleIdentifier
    case appNotInstalledInApplications
    case invalidArgument(bundleID: String)

    var errorDescription: String? {
        switch self {
        case .unsupportedOS:
            return "현재 macOS 버전에서는 시작 시 자동 실행을 지원하지 않습니다."
        case .invalidBundleContext:
            return "시작 시 자동 실행은 .app 번들 실행에서만 동작합니다. 터미널(swift run) 실행은 지원되지 않습니다."
        case .missingBundleIdentifier:
            return "앱 번들 식별자(CFBundleIdentifier)가 없어 자동 실행을 설정할 수 없습니다."
        case .appNotInstalledInApplications:
            return "시작 시 자동 실행은 /Applications 설치본에서만 지원됩니다. 앱을 Applications로 설치 후 다시 시도해주세요."
        case let .invalidArgument(bundleID):
            return "자동 실행 설정이 거부되었습니다(invalid argument). 앱 서명/설치 상태를 확인해주세요. 번들 ID: \(bundleID)"
        }
    }
}
