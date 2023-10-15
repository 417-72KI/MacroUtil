import Foundation

/// A macro that produces a value of URL with compile-time validation.
///
/// For example,
///
///     #color("#FF0000")
///
/// produces
///
///     UIColor(red: 1, green: 0, blue: 0)
///
/// for UIKit, or
///
///     NSColor(red: 1, green: 0, blue: 0)
///
/// for AppKit, and
///
///     #color("")
///
///   produces a compilation error.
@freestanding(expression)
public macro color(_ hex: String, alpha: CGFloat = 1) -> URL = #externalMacro(module: "MacroLib", type: "ColorMacro")
