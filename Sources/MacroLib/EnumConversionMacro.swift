import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum EnumConversionMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard case let .argumentList(arguments) = node.arguments,
              arguments.count == 1,
              let type = arguments.first?.expression
            .as(MemberAccessExprSyntax.self)?.base?
            .as(DeclReferenceExprSyntax.self) else {
            throw CommonError.unexpected
        }
        let propertyName = type.baseName.text.lowercased()
        let memberList = declaration.memberBlock.members
        let cases = memberList
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .compactMap(\.elements.first?.name.text)
            .map { "case .\($0): .\($0)" }
        return [
            """
            var \(raw: propertyName): \(type.baseName) {
                switch self {
                \(raw: cases.joined(separator: "\n"))
                }
            }
            """
        ]
    }
}
