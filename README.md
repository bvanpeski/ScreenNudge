# ScreenNudge
A tool for prompting users to approve Screen Recording on macOS

## Requirements
* This script runs on macOS 10.15 or higher. macOS 11 or higher is required for standard user approval (that MDM command was made available in Big Sur.)
* The script works best when the app being targeted is being deployed with a Privacy Profile library item that lets standard users approve Screen Capture. (Available in macOS Big Sur 11+). Use your MDM's built-in Privacy profile controls or if that's not an option, use a tool like [iMazing Profile Editor](https://imazing.com/profile-editor).
* The MDM agent running this script needs Full Disk Access in order to read the tcc.db and confirm screen recording has been approved. Most MDM agents have this access by default (check the MDM Profile installed on the machine in System Preferences > Profiles), but if your specific MDM does not you'll want to grant it access with a PPPC Profile.

## Notes
While this script was designed with Kandji in mind, it is designed to be plug-and-play for just about any MDM.

I’ve included two options for messaging the end-user leveraging the Kandji CLI or standard osascript, but feel free to add your messaging binary of choice if you prefer using <a href="https://github.com/julienXX/terminal-notifier" title="">Terminal Notifier</a>, <a href="https://github.com/bartreardon/swiftDialog" title="">SwiftDialog</a>, or other solutions.

<!-- wp:preformatted -->
<pre class="wp-block-preformatted"><strong>Pro Tip:</strong> osascript dialogs look pretty boring and dated these days in macOS, but adding a path to an app icon goes a long ways towards making it look less terrible.</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>All you as the admin need to do is to complete the <span style="text-decoration: underline;">User Input</span> section of the script. Here is where you'll define the path to the application, choose the messaging you want to present the dialog, and add an icon.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Here's a few examples:</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>For Zoom:</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">appPath="/Applications/zoom.us.app"
appName="Zoom" #Name of app to present in dialog to user
appIcon="/Applications/zoom.us.app/Contents/Resources/ZPLogo.icns" #Path to app icon for messaging
dialogTitle="Screen Recording Approval"
dialogMessage="Please approve screen recording for $appName."</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>For AnyDesk:</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">appPath="/Applications/AnyDesk.app"
appName="AnyDesk" #Name of app to present in dialog to user
appIcon="/Applications/AnyDesk.app/Contents/Resources/AppIcon-1.icns" #Path to app icon for messaging
dialogTitle="Screen Recording Approval"
dialogMessage="Please approve screen recording for $appName."</pre>
<!-- /wp:preformatted -->
