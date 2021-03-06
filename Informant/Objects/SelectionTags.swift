//
//  SelectionTags.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-29.
//

import Foundation
import SwiftUI

/// Used for capturing the tag data on a file (red, green, etc.). This gets represented in the single panel frame view.
class SelectionTags {

	var colourTags: [SelectionTag]

	var itemTags: [String]?

	internal init(tags: [String]) {
		colourTags = SelectionTags.formatTags(tags)
	}

	// Function for getting colour based on tag
	static func formatTags(_ tags: [String]) -> [SelectionTag] {

		var selectionTags: [SelectionTag] = []

		// Sort through all tags and match them
		for tag in tags {

			switch tag {

			case TagMatch.Red.label: selectionTags.append(TagMatch.Red)
				break

			case TagMatch.Orange.label: selectionTags.append(TagMatch.Orange)
				break

			case TagMatch.Yellow.label: selectionTags.append(TagMatch.Yellow)
				break

			case TagMatch.Green.label: selectionTags.append(TagMatch.Green)
				break

			case TagMatch.Blue.label: selectionTags.append(TagMatch.Blue)
				break

			case TagMatch.Purple.label: selectionTags.append(TagMatch.Purple)
				break

			case TagMatch.Gray.label: selectionTags.append(TagMatch.Gray)
				break

			default: selectionTags.append(SelectionTag(label: tag, color: .clear))
				break
			}
		}

		return selectionTags
	}

	/// Contains all possible colours that macOS supports for tags
	enum TagMatch {
		static let Red = SelectionTag(label: ContentManager.Colors.Red, color: .red)
		static let Orange = SelectionTag(label: ContentManager.Colors.Orange, color: .orange)
		static let Yellow = SelectionTag(label: ContentManager.Colors.Yellow, color: .yellow)
		static let Green = SelectionTag(label: ContentManager.Colors.Green, color: .green)
		static let Blue = SelectionTag(label: ContentManager.Colors.Blue, color: .blue)
		static let Purple = SelectionTag(label: ContentManager.Colors.Purple, color: .purple)
		static let Gray = SelectionTag(label: ContentManager.Colors.Grey, color: .gray)
	}

	/// A basic selection tag unit. Can go without colour to just represent a singular tag
	class SelectionTag {

		var label: String
		var color: Color?

		internal init(label: String, color: Color? = nil) {
			self.label = label
			self.color = color
		}
	}
}
