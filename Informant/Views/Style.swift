//
//  Styling.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

/// Contains all styling constants to be used across app
class Style {
	public enum Text {
		static let opacity = 0.5
		static let darkOpacity = 0.7
		static let fontSFCompact = "SF Compact Display"
		static let fontSFMono = "SF Mono"
	}

	public enum Button {
		static let labelButtonOpacity = 0.8
	}

	public enum Font {
		static let h1_Size: CGFloat = 17
		static let h2_Size: CGFloat = 17
		static let h3_Size: CGFloat = 11
		static let h4_Size: CGFloat = 11
	}
}

extension Text {

	func H1() -> some View {
		self.font(.system(size: Style.Font.h1_Size))
			.fontWeight(.regular)
			.lineLimit(1)
	}

	func H2() -> Text {
		self.font(.system(size: Style.Font.h2_Size))
			.kerning(-0.1)
			.fontWeight(.regular)
	}

	func H3(opacity: Double = Style.Text.opacity) -> some View {
		self.font(.system(size: Style.Font.h3_Size))
			.fontWeight(.medium)
			.opacity(opacity)
			.lineLimit(1)
	}

	func H4() -> some View {
		self.font(.system(size: Style.Font.h4_Size))
			.fontWeight(.medium)
			.kerning(-0.25)
			.lineLimit(1)
			.opacity(Style.Text.opacity)
	}

	func PanelPadIconFont() -> some View {
		self.font(.system(size: 14.5))
			.fontWeight(.semibold)
	}

	func PanelAlertFont(_ size: CGFloat, _ weight: Font.Weight = .medium) -> Text {
		self.font(.system(size: size))
			.fontWeight(weight)
	}

	func PanelTitleFont() -> some View {
		self.font(.system(size: 14))
			.fontWeight(.semibold)
			.kerning(-0.25)
			.lineLimit(1)
			.truncationMode(.middle)
	}

	func PanelPathFont() -> some View {
		self.font(.custom(Style.Text.fontSFMono, size: 13))
			.lineSpacing(3.0)
	}

	func TildeFont() -> Text {
		self.font(.custom(Style.Text.fontSFCompact, size: 18))
	}
}