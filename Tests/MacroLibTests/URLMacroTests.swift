import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(MacroLib)
import MacroLib
#endif

final class URLMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(MacroLib)
        assertMacroExpansion(
            """
            #url("https://example.com")
            """,
            expandedSource: """
            URL(string: "https://example.com")!
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroEmpty() throws {
        #if canImport(MacroLib)
        assertMacroExpansion(
            """
            #url("")
            """,
            expandedSource: """
            #url("")
            """,
            diagnostics: [
                DiagnosticSpec(message: "Malformed url: ''", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroNonStaticString() throws {
        #if canImport(MacroLib)
        assertMacroExpansion(
            #"""
            #url("https://\(host)")
            """#,
            expandedSource: #"""
            #url("https://\(host)")
            """#,
            diagnostics: [
                DiagnosticSpec(message: "`#url` requires a static string literal", line: 1, column: 1)
            ],
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #url("https://" + "example.com")
            """,
            expandedSource: """
            #url("https://" + "example.com")
            """,
            diagnostics: [
                DiagnosticSpec(message: "`#url` requires a static string literal", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
