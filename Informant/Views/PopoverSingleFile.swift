//
//  Popover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

struct PopoverSingleFile: View {

	var selection: SelectItem

	var body: some View {

		ComponentsPanelFrame {

			ComponentsPanelHeader(
				headerIcon: selection.typeIcon!,
				headerTitle: selection.title!,
				headerSubtitle: selection.fileDateModifiedAsString!
			)

			Divider().padding(.bottom, 10)

			VStack(alignment: .leading, spacing: 20) {
				// Kind - Size
				HStack {
					ComponentsPanelItemField(label: ContentManager.Labels.panelKind, value: String(selection.fileKind!))
					ComponentsPanelItemField(label: ContentManager.Labels.panelSize, value: String(selection.sizeAsString!))
				}

				// Created
				ComponentsPanelItemField(label: ContentManager.Labels.panelCreated, value: selection.fileDateCreatedAsString!)

				// Path
				ComponentsPanelItemField(label: ContentManager.Labels.panelPath, value: selection.path!)
			}
		}
	}
}
