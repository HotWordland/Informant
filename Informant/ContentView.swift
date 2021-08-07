//
//  ContentView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

// Currently this is what gets displayed in the popover
struct ContentView: View {

	/// This contains the app delegate, which can is used for all functionality
	var appDelegate: AppDelegate

	/// This contians all information to be displayed on the interface
	@ObservedObject var interfaceData: InterfaceDataWrapper

	/// Lets us know if the object is being dragged in the snap zone
	@ObservedObject var interfaceState: InterfaceState

	// Initialize app delegate object
	init() {
		appDelegate = AppDelegate.current()
		interfaceState = appDelegate.interfaceState
		interfaceData = InterfaceDataWrapper(data: appDelegate.interfaceData)
	}

	var body: some View {

		// MARK: Full Stacked View
		ZStack {

			// This is the pause blur group
			Group {

				// This is the main panel group
				Group {
					// MARK: - Panel Backing Material
					VisualEffectView(material: .menu, blendingMode: .behindWindow, emphasized: true)
						.edgesIgnoringSafeArea(.all)

					// MARK: - Panel Main
					// So we can add padding to the main interface
					VStack(alignment: .center, spacing: 0) {

						// Confirm that accessibility is enabled
						if interfaceState.privacyAccessibilityEnabled == true {

							// MARK: - Selection View Picker
							// Figure out which view to present based on the # of items selected
							switch interfaceData.data?.selection?.selectionType {

								// MARK: - Singles
								// One item selected - no metadata
								case .Single: PanelSingleItem(interfaceData.data?.selection)

								// One item selected - with metadata ⤵︎
								case .Image: PanelSingleImageItem(interfaceData.data?.selection)

								case .Movie: PanelSingleMovieItem(interfaceData.data?.selection)

								case .Audio: PanelSingleAudioItem(interfaceData.data?.selection)

								case .Directory: PanelSingleDirectoryItem(interfaceData.data?.selection)

								case .Application: PanelSingleApplicationItem(interfaceData.data?.selection)

								case .Volume: PanelSingleVolumeItem(interfaceData.data?.selection)

								// MARK: - Multi
								// More than one item selected
								case .Multi: PanelMultiItem(interfaceData.data?.selection)

								// Errors
								case .Error: PanelSelectionErrorItem()

								// No items selected
								default: PanelNoItem()
							}
						}

						// Otherwise show the 'not-authorized' view
						else {
							PanelAuthErrorItem()
						}
					}
					.padding(.horizontal, 15)
				}

				// MARK: - Is Paused Indicator

				// Blurs view when being dragged in the snap zone
				.blur(radius: interfaceState.settingsPauseApp ? 15.0 : 0.0)
				.animation(.spring(), value: self.interfaceState.settingsPauseApp)

				ComponentsPanelLabelIconFrame(
					icon: "􀊇",
					iconSize: 16,
					label: ContentManager.SettingsLabels.paused
				)
				.opacity(interfaceState.settingsPauseApp ? 1.0 : 0.0)
				.animation(.spring(), value: self.interfaceState.settingsPauseApp)

				// When the user clicks on this blurred screen the app resumes operation
				if interfaceState.settingsPauseApp {
					Color.clear
						.inactiveWindowTap { pressed in
							if !pressed {
								interfaceState.settingsPauseApp = false
							}
						}
				}
			}

			// MARK: - Panel Snap Zone Indicator

			// Blurs view when being dragged in the snap zone
			.blur(radius: interfaceState.isPanelInSnapZone ? 15.0 : 0.0)
			.animation(.spring(), value: self.interfaceState.isPanelInSnapZone)

			VStack(alignment: .center, spacing: 4) {

				Text("􀁶")
					.font(.system(size: 18))
					.opacity(Style.Text.opacity)
					.rotationEffect(Angle(degrees: interfaceState.panelSnapZoneDirection))

				Text(ContentManager.Labels.panelSnapZoneIndicator)
					.H1()
					.opacity(Style.Text.opacity)
			}
			.opacity(interfaceState.isPanelInSnapZone ? 1.0 : 0.0)
			.animation(.spring(), value: self.interfaceState.isPanelInSnapZone)

			// When the user clicks on this blurred screen the app resumes operation
			if interfaceState.isPanelInSnapZone {
				Color.clear
					.inactiveWindowTap { pressed in
						if !pressed {
							interfaceState.isPanelInSnapZone = false
						}
					}
			}

			// MARK: - Panel Bottom Buttons

			VStack {

				// Makes sure button rests on the bottom of the interface
				Spacer()

				// Settings button stack
				HStack(spacing: 0) {

					// Additional file tags
					ComponentsPanelAttributes(interfaceData.data?.selection)
						.padding([.leading], 11)

					// Ensures buttons align to the right
					Spacer()

					// More button
					ComponentsPanelIconMenuButton(ContentManager.Icons.panelPreferencesButton, size: 16.25) {
						appDelegate.interfaceMenuController!.openMenuAtPanel()
					}
				}
			}
			.padding(4)
		}

		// Please see PanelCloseButton.swift for partnering logic
		.whenHovered { hovering in
			if appDelegate.statusBarController?.interfaceHidingState != .Hidden {
				if interfaceState.closeHoverZone != .Button || hovering {
					interfaceState.isMouseHoveringClose = hovering
				}

				interfaceState.isMouseHoveringPanel = hovering
			}
		}
		.frame(width: 256)
		.edgesIgnoringSafeArea(.top)
		.fixedSize()
	}
}
