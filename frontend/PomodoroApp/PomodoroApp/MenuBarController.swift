//
//  MenuBarController.swift
//  Pomodoro
//
//  Created by Jimmy Sambuo on 5/13/24.
//

#if canImport(Cocoa)
import Cocoa

class MenuBarController {
    private var statusItem: NSStatusItem?

    init() {
        setupMenuBar()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Timer")
            button.action = #selector(menuBarIconClicked)
            button.target = self
        }

        let menu = NSMenu()
        let startItem = NSMenuItem(title: "Start Timer", action: #selector(startTimer), keyEquivalent: "S")
        startItem.target = self
        menu.addItem(startItem)
        
        let stopItem = NSMenuItem(title: "Stop Timer", action: #selector(stopTimer), keyEquivalent: "P")
        stopItem.target = self
        menu.addItem(stopItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
    }

    @objc private func menuBarIconClicked() {
        // Handle the menu bar icon click if needed
    }

    @objc private func startTimer() {
        // Integrate with your PomodoroTimer start logic
        print("Start Timer")
    }

    @objc private func stopTimer() {
        // Integrate with your PomodoroTimer stop logic
        print("Stop Timer")
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
#endif

#if canImport(Cocoa)
class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("from App deleate")
        menuBarController = MenuBarController()
    }
}
#endif
