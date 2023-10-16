import Foundation

@attached(member, names: arbitrary)
public macro EnumConversion<T>(_ value: T.Type) = #externalMacro(module: "MacroLib", type: "EnumConversionMacro")

enum Foo {
    case a
    case b
    case c
}

@EnumConversion(Foo.self)
enum Bar {
    case a
    case b
    case c
}
