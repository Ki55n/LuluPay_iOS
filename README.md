**LuluPay iOS Framework**

**Overview**

LuluPay is an iOS framework for seamless financial operations. It offers UI components, API services, and models for quick integration.

**Installation**

CocoaPods

Add the following to your Podfile:

pod 'LuluPay'

**📌 Key Features**

Secure Authentication (Face ID)

Seamless Remittance and Utility Payment Processing

Effortless Integration with Minimal Code

Secure User Credential Management

Simple Theme Management

**SDKThemeManager – Theme Support**

Supports light, dark, and system modes.

**Example:**

    @IBAction func themeButtonTapped(_ sender: UIButton) {
        // Get current theme and toggle
        let current = SDKThemeManager.currentTheme
        let next: SDKTheme

        switch current {
        case .light:
            next = .dark
        case .dark:
            next = .system
        case .system:
            next = .light
        }

        // Save to user defaults (optional)
        saveThemeSelection(ThemeOption(rawValue: "\(next)") ?? .system)

        // Apply and update
        SDKThemeManager.configure(theme: next)

        if let window = UIApplication.shared.windows.first {
            SDKThemeManager.applyTheme(to: window)
        }

        // Optional: update button title
        sender.setTitle("Theme: \(next)", for: .normal)
    }


Supports custom colors using SDKThemeManager.customColors.

**Face ID Login**

First Login: Face ID is offered after login (if supported).

Next Logins: Face ID is used automatically if enabled.

**Secure Credential Storage (Keychain)**

Credentials are securely stored using Keychain.

Automatically encrypted and persisted across launches.

Accessible only after first unlock.

**MyStoryboardLoader**

Easily load and present the initial view controller from the SDK's storyboard.

**Usage**

@objc func payButtonTapped() {
    
    let frameworkVC = MyStoryboardLoader.instantiateViewController()
    
    frameworkVC.modalPresentationStyle = .fullScreen
    
    present(frameworkVC, animated: true, completion: nil)
    
}
