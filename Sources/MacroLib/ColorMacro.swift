import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public enum ColorMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let argumentList = node.argumentList
        guard let hex = argumentList.first?.expression,
              let segments = hex.as(StringLiteralExprSyntax.self)?.segments,
              !segments.contains(where: { $0.is(ExpressionSegmentSyntax.self) }) else {
            throw MacroError.staticStringLiteralRequired
        }
        let (r, g, b) = try parseHex(hex.description)
        let secondIndex = argumentList.index(after: argumentList.startIndex)
        let alpha = if secondIndex == nil {
            "1"
        } else {
            argumentList[secondIndex].expression.description
        }

        return "\(raw: colorClass)(red: \(r), green: \(g), blue: \(b), alpha: \(raw: alpha))"
    }
}

extension SyntaxStringInterpolation {
    mutating func appendInterpolation(_ value: CGFloat) {
        appendLiteral(String(describing: value))
    }
}

extension ColorMacro {
    static func parseHex(_ hex: String) throws -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        guard let match = try #/^"?#?(?<red>[0-9a-fA-F]{2})(?<green>[0-9a-fA-F]{2})(?<blue>[0-9a-fA-F]{2})"?$/#.wholeMatch(in: hex) else {
            throw MacroError.malformedColor(hex)
        }
        let red = UInt(match.output.red, radix: 16)! & 0xFF
        let green = UInt(match.output.green, radix: 16)! & 0xFF
        let blue = UInt(match.output.blue, radix: 16)! & 0xFF

        return (
            CGFloat(red) / 255.0,
            CGFloat(green) / 255.0,
            CGFloat(blue) / 255.0
        )
    }
}

package extension ColorMacro {
    enum MacroError: Error {
        case staticStringLiteralRequired
        case malformedColor(String)
    }
}

extension ColorMacro.MacroError: DiagnosticMessage {
    package var message: String {
        switch self {
        case .staticStringLiteralRequired: "`#color` requires a static string literal"
        case let .malformedColor(value): "Malformed color: '\(value)'"
        }
    }

    package var diagnosticID: MessageID {
        let id: String = switch self {
        case .staticStringLiteralRequired: "staticStringLiteralRequired"
        case .malformedColor: "malformedColor"
        }
        return MessageID(domain: domain, id: id)
    }

    package var severity: DiagnosticSeverity { .error }
}

private extension ColorMacro {
    static var colorClass: String {
        #if canImport(AppKit)
        "NSColor"
        #elseif canImport(UIKit)
        "UIColor"
        #else
        ""
        #endif
    }
}
