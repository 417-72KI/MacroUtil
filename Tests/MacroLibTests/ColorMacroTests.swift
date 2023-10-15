import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(MacroLib)
import MacroLib
#endif

final class ColorMacroTests: XCTestCase {
    #if canImport(UIKit)
    func testMacro_UIKit() throws {
        #if canImport(MacroLib)
        assertMacroExpansion(
            """
            #color("#FF0000")
            #color("#00FF00")
            #color("#0000FF")
            #color("#666666", alpha: 0.5)
            """,
            expandedSource: """
            UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
            UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1)
            UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
            UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.5)
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    #endif

    #if canImport(AppKit)
    func testMacro_AppKit() throws {
        #if canImport(MacroLib)
        assertMacroExpansion(
            """
            #color("#FF0000")
            #color("#00FF00")
            #color("#0000FF")
            #color("#666666", alpha: 0.5)
            """,
            expandedSource: """
            NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
            NSColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1)
            NSColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
            NSColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.5)
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    #endif
}
