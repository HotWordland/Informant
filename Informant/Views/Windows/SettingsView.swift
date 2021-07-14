//
//  Preferences.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import KeyboardShortcuts
import LaunchAtLogin
import SwiftUI

// This is the main settings window view
struct SettingsView: View {

	let appDelegate: AppDelegate!

	@ObservedObject var interfaceState: InterfaceState

	init() {
		appDelegate = AppDelegate.current()
		interfaceState = appDelegate.interfaceState
	}

	var body: some View {

		// Main stack
		HStack {

			// Left side
			SettingsLeftSideView()
				.frame(width: 260)

			// Divider
			Divider()
			Spacer(minLength: 0)

			// Right side
			SettingsRightSideView(interfaceState: interfaceState)

			// Makes sure view is centered
			Spacer(minLength: 0)
		}
		.padding([.bottom, .leading, .trailing])
		.frame(width: 650, height: 400, alignment: .center)
	}
}

struct SettingsLeftSideView: View {

	var version: String!
	var name: String!

	let linkIcon = "→ "

	init() {

		let info = Bundle.main.infoDictionary

		if let appVersion = info?["CFBundleShortVersionString"] as? String {
			version = appVersion
		}

		if let appName = info?["CFBundleName"] as? String {
			name = appName
		}
	}

	var body: some View {
		VStack(alignment: .center) {

			Spacer()

			// App image stack
			VStack(spacing: 6) {

				// App icon
				Image(nsImage: NSImage(named: ContentManager.Images.appIcon) ?? NSImage())
					.offset(y: 9.0)

				// Name
				if let name = name {
					Text(name)
						.font(.system(size: 25))
						.fontWeight(.medium)
				}

				// Copyright
				Text("©2021 Ty Irvine")
					.SettingsVersionFont()

				// Version
				if let version = version {
					Text(version)
						.SettingsVersionFont()
				}
			}

			Spacer()

			#warning("Add link functionality")
			// Link stack
			VStack(alignment: .leading, spacing: 12) {

				// Acknowledgements
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
				} content: {
					Text(linkIcon + ContentManager.SettingsLabels.privacyPolicy)
						.SettingsLabelButtonFont()
				}

				// Feedback
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
				} content: {
					Text(linkIcon + ContentManager.SettingsLabels.feedback)
						.SettingsLabelButtonFont()
				}

				// Help
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
				} content: {
					Text(linkIcon + ContentManager.SettingsLabels.help)
						.SettingsLabelButtonFont()
				}
			}

			Spacer()
		}
	}
}

struct SettingsRightSideView: View {

	@ObservedObject var interfaceState: InterfaceState

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {

			// MARK: - Panel
			Text(ContentManager.SettingsLabels.panel)
				.SettingsLabelFont(padding: 7)

			VStack(alignment: .leading, spacing: 12) {

				// Shortcut to activate panel
				HStack {
					Text(ContentManager.SettingsLabels.toggleDetailsPanel)
					KeyboardShortcuts.Recorder(for: .togglePopover)
				}

				// Show where a selected file is located instead of the full path
				Toggle(" " + ContentManager.SettingsLabels.showFullPath, isOn: $interfaceState.settingsPanelShowFullPath)

				// Enable created property
				Toggle(" " + ContentManager.SettingsLabels.enableCreated, isOn: $interfaceState.settingsPanelEnableCreatedProp)

				// Enable path property
				Toggle(" " + ContentManager.SettingsLabels.enablePath, isOn: $interfaceState.settingsPanelEnablePathProp)

				// Enable name property
				Toggle(" " + ContentManager.SettingsLabels.enableName, isOn: $interfaceState.settingsPanelEnableNameProp)
			}

			// Divides system and panel
			Spacer().frame(height: 30)

			// MARK: - System
			Text(ContentManager.SettingsLabels.system)
				.SettingsLabelFont()

			VStack(alignment: .leading, spacing: 12) {

				// Pick root url
				SettingsPickRootURL(interfaceState.settingsRootURL)

				// Launch informant on system startup
				LaunchAtLogin.Toggle(" " + ContentManager.SettingsLabels.launchOnStartup)

				// Enable menubar-utility
				Toggle(" " + ContentManager.SettingsLabels.menubarUtility, isOn: $interfaceState.settingsMenubarUtilityBool)
			}
		}
		.fixedSize()
	}
}

struct SettingsPickRootURL: View {

	let rootURL: String?

	@State var isHovering: Bool = false

	let securityBookmarkHelper: SecurityBookmarkHelper

	init(_ rootURL: String?) {
		self.rootURL = rootURL
		securityBookmarkHelper = AppDelegate.current().securityBookmarkHelper
	}

	var body: some View {

		// Descriptor
		VStack(alignment: .leading) {

			// Root URL Stack
			HStack {

				// Label
				Text(ContentManager.SettingsLabels.pickRootURL)

				// Button
				ZStack {

					// Backing
					RoundedRectangle(cornerRadius: 7)
						.opacity(isHovering ? 0.15 : 0.07)
						.animation(.easeInOut(duration: 0.25), value: isHovering)

					// Root url
					ScrollView(.horizontal, showsIndicators: false) {
						Text(rootURL ?? ContentManager.SettingsLabels.none)
							.PanelPathFont()
							.padding(4)
							.opacity(rootURL != nil ? 1 : 0.5)
					}
					.frame(width: 200)

					// Clear button stack
					HStack {

						Spacer()

						// Clear button
						ComponentsPanelIconButton("xmark.circle.fill", size: 13.5) {
							securityBookmarkHelper.deleteRootURLPermission()
						}
					}
				}
				.fixedSize(horizontal: false, vertical: true)
				.whenHovered { hovering in
					isHovering = hovering
				}
				.onTapGesture {
					securityBookmarkHelper.pickRootURL()
				}
			}

			// Descriptor
			Text(ContentManager.Messages.settingsRootURLDescriptor)
				.SettingsVersionFont()
		}
	}
}