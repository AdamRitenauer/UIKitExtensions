//
//  ViewController.swift
//  DJ App
//
//  Created by Adam Ritenauer on 8/23/16.
//  Copyright © 2016 Rhapsody International. All rights reserved.
//

import UIKit

open class ViewController:UIViewController {
	

	/// A GCD queue used to defer the execution of view related operation until the view is available
	let viewQueue = DispatchQueue(label: "com.AdamRitenauer.UIKitExtensions.ViewController.viewQueue", attributes: DispatchQueue.Attributes.concurrent)
	
	//MARK: - Init
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		
		super.init(coder: aDecoder)
		
		setup()
	}
	
	fileprivate func setup() {
		
		// Configure viewQueue to execute on the main thread
		viewQueue.setTarget(queue: DispatchQueue.main)
		
		// Suspend viewQueue until viewDidLoad is executed
		viewQueue.suspend()
	}
	
	//MARK: - UIViewController
	
	override open func viewDidLoad() {
		
		// The view is now available, execute all defered view operations
		viewQueue.resume()
	}
	
	//MARK: - Utilities
	
	/**
		The handler type used with dispatch_view
	
		- discussion: Provides a strong reference to self
	*/
	public typealias DispatchViewHandler = (ViewController)->Void
	
	/** 
		Executes the handler after the view loads
	
		- parameter handler: The code to execute after viewDidLoad executes
		- discussion: Reduces the need for transient state variables, by enquing view related operations unitl after the view is available. Hanlders scheduled before the execution viewDidLoad will be defered, Handlers scheduled after viewDidLoad will execute immediately, albeit asynchronously.
	*/
	open func dispatch_view(_ handler:@escaping (ViewController)->Void) {
		
		viewQueue.async { [weak self] in
			
			guard let sself = self else {
				
				assertionFailure()
				return
			}
			
			handler(sself)
		}
	}
}
