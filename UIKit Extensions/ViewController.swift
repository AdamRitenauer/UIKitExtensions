//
//  ViewController.swift
//  DJ App
//
//  Created by Adam Ritenauer on 8/23/16.
//  Copyright © 2016 Rhapsody International. All rights reserved.
//

import UIKit

public class ViewController:UIViewController {
	

	/// A GCD queue used to defer the execution of view related operation until the view is available
	let viewQueue = dispatch_queue_create("com.AdamRitenauer.UIKitExtensions.ViewController.viewQueue", DISPATCH_QUEUE_CONCURRENT)
	
	//MARK: - Init
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		
		super.init(coder: aDecoder)
		
		setup()
	}
	
	private func setup() {
		
		// Configure viewQueue to execute on the main thread
		dispatch_set_target_queue(viewQueue, dispatch_get_main_queue())
		
		// Suspend viewQueue until viewDidLoad is executed
		dispatch_suspend(viewQueue)
	}
	
	//MARK: - UIViewController
	
	override public func viewDidLoad() {
		
		// The view is now available, execute all defered view operations
		dispatch_resume(viewQueue)
	}
	
	//MARK: - Utilities
	
	/**
		The handler type used with dispatch_view
	
		- discussion: Provides a strong reference to self
	*/
	public typealias DispatchViewHandler = ViewController->Void
	
	/** 
		Executes the handler after the view loads
	
		- parameter handler: The code to execute after viewDidLoad executes
		- discussion: Reduces the need for transient state variables, by enquing view related operations unitl after the view is available. Hanlders scheduled before the execution viewDidLoad will be defered, Handlers scheduled after viewDidLoad will execute immediately, albeit asynchronously.
	*/
	public func dispatch_view(handler:ViewController->Void) {
		
		dispatch_async(viewQueue) { [weak self] in
			
			guard let sself = self else {
				
				assertionFailure()
				return
			}
			
			handler(sself)
		}
	}
}