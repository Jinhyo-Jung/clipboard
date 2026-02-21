import Foundation
import ServiceManagement

enum LaunchAtLoginService {
    static func apply(enabled: Bool) -> Result<Void, Error> {
        guard #available(macOS 13.0, *) else {
            return .failure(LaunchAtLoginError.unsupportedOS)
        }

        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

enum LaunchAtLoginError: LocalizedError {
    case unsupportedOS

    var errorDescription: String? {
        switch self {
        case .unsupportedOS:
            return "현재 macOS 버전에서는 시작 시 자동 실행을 지원하지 않습니다."
        }
    }
}
