//
// ConsolePlugin.swift
//
// This source file is part of the SMUD open source project
//
// Copyright (c) 2016 SMUD project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SMUD project authors
//

import Foundation
import Dispatch

import Smud
import TextUserInterface
import ScannerUtils

public class ConsolePlugin: SmudPlugin {
    typealias T = ConsolePlugin
    
    let smud: Smud
    let textUserInterface = TextUserInterface()
    let session: ConsoleSession
    var inputMaximumLineLength = 512
    
    public init(smud: Smud) {
        self.smud = smud
        session = ConsoleSession(textUserInterface: textUserInterface)
    }
    
    public func willEnterGameLoop() {
        //print("TextUserInterfacePlugin: willEnterGameLoop()")
        
        session.context = ChooseAccountContext(smud: smud)
        
        DispatchQueue.global(qos: .background).async {
            var eof = false
            repeat {
                autoreleasepool {
                    if let line = readLine(strippingNewline: true) {
                        DispatchQueue.main.async {
                            self.process(line: line)
                        }
                    } else {
                        eof = true
                        print("")
                    }
                }
            } while !eof
            DispatchQueue.main.async {
                self.smud.isTerminated = true
            }
        }
    }
    
    private func process(line: String) {
        var line = line
        if line.characters.count > inputMaximumLineLength {
            session.send("WARNING: Your input was truncated.")
            line = line.substring(to: line.index(
                line.startIndex, offsetBy: inputMaximumLineLength))
        }
    
        guard let context = session.context else { return }
        let scanner = Scanner(string: line)
        let args = Arguments(scanner: scanner)
        
        let action: ContextAction
        do {
            action = try context.processResponse(args: args, session: session)
        } catch {
            session.send(smud.internalErrorMessage)
            print("Error in context \(context): \(error)")
            context.greet(session: session)
            return
        }
        
        switch action {
        case .retry(let reason):
            if let reason = reason {
                session.send(reason)
            }
            context.greet(session: session)
        case .next(let context):
            session.context = context
        case .closeSession:
            // Return to registration instead?
            smud.isTerminated = true
        }
    }
}
