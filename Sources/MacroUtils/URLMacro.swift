import Foundation

/// A macro that produces a value of URL with compile-time validation.
///
/// For example,
///
///     #url("https://foo.bar")
///
/// produces
///
///     URL(string: "https://foo.bar")!
///
/// and
///
///     #url("")
///
///   produces a compilation error.
@freestanding(expression)
public macro url(_ value: String) -> URL = #externalMacro(module: "MacroLib", type: "URLMacro")
