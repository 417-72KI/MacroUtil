import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
              !segments.contains(where: { $0.is(ExpressionSegmentSyntax.self) }) else {
            throw MacroError.staticStringLiteralRequired
        }
        guard let _ = URL(string: segments.description) else {
            throw MacroError.malformedURL(segments.description)
        }
        return "URL(string: \(argument))!"
    }
}

package extension URLMacro {
    enum MacroError: Error {
        case staticStringLiteralRequired
        case malformedURL(String)
    }
}

extension URLMacro.MacroError: DiagnosticMessage {
    package var message: String {
        switch self {
        case .staticStringLiteralRequired: "`#url` requires a static string literal"
        case let .malformedURL(value): "Malformed url: '\(value)'"
        }
    }

    package var diagnosticID: MessageID {
        let id: String = switch self {
        case .staticStringLiteralRequired: "staticStringLiteralRequired"
        case .malformedURL: "malformedURL"
        }
        return MessageID(domain: domain, id: id)
    }

    package var severity: DiagnosticSeverity { .error }
}
