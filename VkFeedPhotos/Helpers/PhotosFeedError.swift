//
//  PhotosFeedError.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 19.08.2021.
//

import Foundation

enum PhotosFeedError {
    case authError
    case serverError
    case nullResponseError
}

extension PhotosFeedError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .authError:
            return NSLocalizedString("Прерван процесс авторизации", comment: "")
        case .serverError:
            return NSLocalizedString("Нет соединения с сервером", comment: "")
        case .nullResponseError:
            return NSLocalizedString("Ошибка получения результата с сервера", comment: "")
        }
    }
}
