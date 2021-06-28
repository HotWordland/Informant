//
//  MultiSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-24.
//

import Cocoa
import Foundation

class MultiSelection: SelectionHelper, SelectionProtocol, ObservableObject {
	
	var selectionType: SelectionType = .Multi
	var itemResources: URLResourceValues?
	
	// MARK: - Async work block
	var workQueue: [DispatchWorkItem] = []
	
	// Metadata ⤵︎
	var itemTitle: String?
	var itemTotalIcons: [NSImage] = []
	
	var itemSize: Int?
	@Published var itemSizeAsString: String?
	
	/// Fills the data in for intention to be used in a multi-select interface
	required init(_ urls: [String], selection: SelectionType = .Multi) {
		
		selectionType = selection
		
		super.init()
		
		// MARK: - Establish Title
		// Establish item count
		let totalCount = urls.count
		
		// Establish title
		itemTitle = String(totalCount) + " " + ContentManager.Labels.multiSelectTitle
		
		// MARK: - Establish Size
		// Start size off at 0
		itemSize = 0
		
		// Tell the user we're starting to calculate
		itemSizeAsString = SelectionHelper.State.Calculating
		
		// Async request file size
		if AppDelegate.current().securityBookmarkHelper.startAccessingRootURL() == true {
			asyncRetrieveSizeOfURLS(urls)
		} else {
			itemSizeAsString = State.Unavailable
		}
		
		// MARK: - Establish Icon Collection
		/// Gather the icons from the first two or three files and use those layered on top of eachother!
		for (index, url) in urls.enumerated() {
			
			let icon = NSWorkspace.shared.icon(forFile: url)
			guard let iconResized = icon.resized(to: ContentManager.Icons.panelHeaderIconSize) else { return }
			itemTotalIcons.append(iconResized)
		
			// Escape loop at desired iteration
			if index >= 6 {
				break
			}
		}
	}
	
	/// Simplifies code by tucking all async into one function
	func asyncRetrieveSizeOfURLS(_ urls: [String]) {
		workQueue.append(DispatchWorkItem { self.getSizeOfURLS(urls) })
		DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.1, execute: workQueue[0])
	}
	
	/// Retrieves total size of all files including subdirectories of the url collection
	func getSizeOfURLS(_ urls: [String]) {
		
		let keys: Set<URLResourceKey> = [
			.totalFileSizeKey,
			.isDirectoryKey
		]
		
		// Cycle through all urls and get the size of each
		for url in urls {
			
			// Get resources
			guard let resources = SelectionHelper.getURLResources(URL(fileURLWithPath: url), keys) else { return }
			
			// Check to see if the item is a directory
			if resources.isDirectory == true {
				do {
					itemSize? += try Int(FileManager.default.allocatedSizeOfDirectory(at: URL(fileURLWithPath: url)))
				} catch { }
				continue
			}
			
			// Otherwise it's a regular file
			guard let size = resources.totalFileSize else {
				break
			}
			
			// Assign size
			itemSize? += size
		}
		
		// Once finished update the item size
		DispatchQueue.main.async {
			self.updateItemSizeAsString()
			AppDelegate.current().securityBookmarkHelper.stopAccessingRootURL()
		}
	}
	
	/// Formats the item size as a string
	func updateItemSizeAsString() {
		if let size = itemSize {
			itemSizeAsString = ContentManager.Labels.multiSelectSize + " " + ByteCountFormatter().string(fromByteCount: Int64(size))
		}
	}
}
