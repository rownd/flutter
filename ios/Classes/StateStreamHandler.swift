//
//  StateStreamHandler.swift
//  rownd_flutter_plugin
//
//  Created by Matt Hamann on 9/16/22.
//

import Foundation
import Rownd
import SwiftUI
import Combine

class StateStreamHandler: NSObject, FlutterStreamHandler {

    private var eventSink: FlutterEventSink? = nil

    @ObservedObject private var state = Rownd.getInstance().state().subscribe { $0 }

    private var stateCancellable: AnyCancellable?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("listening to events")
        eventSink = events

        stateCancellable = state.$current.sink { [weak self] newState in
            print("newState receieved: \(String(describing: newState))")
            guard let self = self else { return }
            do {
                let serializedState = try newState.toJson()
                self.eventSink?(serializedState)
            } catch {
                return
            }
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("subscription canceled")
        stateCancellable?.cancel()
        eventSink = nil
        return nil
    }
}
