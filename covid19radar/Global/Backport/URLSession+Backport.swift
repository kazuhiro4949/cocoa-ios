//
//  URLSession+Backport.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

@available(iOS, deprecated: 15.0)
extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        var dataTask: URLSessionDataTask?
        let onCancel = { dataTask?.cancel() }
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                dataTask = self.dataTask(with: request) { data, response, error in
                    guard let data = data, let response = response else {
                        let error = error ?? URLError(.badServerResponse)
                        return continuation.resume(throwing: error)
                    }

                    continuation.resume(returning: (data, response))
                }

                dataTask?.resume()
            }
        } onCancel: {
            onCancel()
        }
    }
}
