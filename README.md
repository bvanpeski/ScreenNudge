# ScreenNudge
A tool for prompting users to approve Screen Recording on macOS

<img width="600" alt="screennudge_example" src="https://user-images.githubusercontent.com/4316081/197368115-b2309720-8d47-444e-9044-051000ae3868.png">


## Requirements
* This script runs on macOS 10.15 or higher. macOS 11 or higher is required for standard user approval (that MDM command was made available in Big Sur.)
* The script requires that the app being targeted is being deployed with a Privacy Profile library item that lets standard users approve Screen Capture (`AllowStandardUserToSetSystemService`). (Available in macOS Big Sur 11+). Use your MDM's built-in Privacy profile controls or if that's not an option, use a tool like [iMazing Profile Editor](https://imazing.com/profile-editor).
* The MDM agent running this script needs Full Disk Access in order to read the tcc.db and confirm screen recording has been approved. Most MDM agents have this access by default (check the MDM Profile installed on the machine in System Preferences > Profiles), but if your specific MDM does not you'll want to grant it access with a PPPC Profile.

## Notes
While this script was designed with Kandji in mind, it is designed to be plug-and-play for just about any MDM.

I’ve included three options for messaging the end-user leveraging the Kandji CLI, <a href="https://github.com/bartreardon/swiftDialog" title="">SwiftDialog</a>, or standard osascript, but feel free to add your messaging binary of choice.

**Pro Tip:** osascript dialogs look pretty boring and dated these days in macOS, but adding a path to an app icon goes a long ways towards making it look less terrible.

![dialog_boxes](https://user-images.githubusercontent.com/4316081/197363964-e7b69c9c-7986-44e8-99d3-0155f60379f9.jpg)


<!-- wp:paragraph -->
<p>All you as the admin need to do is to complete the <span style="text-decoration: underline;">User Input</span> section of the script. Here is where you'll define the path to the application, choose the messaging you want to present in the dialog, and add an optional icon.</p>
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

## Troubleshooting
* I get an error `Error: unable to open database "/Library/Application Support/com.apple.TCC/TCC.db": authorization denied`
  * This means the agent running the script doesn't have Full Disk Access permissions to read the TCC.db. Keep in mind that with some MDMs, if you trigger a script via Terminal (rather than waiting for agent check-in), it will run as Terminal rather than as the agent.  (Please don't deploy a PPPC Profile granting Terminal Full Disk access to solve this, as that is a huge security risk). Wait for the device to check in, and it should run fine.
* Reading the Logs
  * You probably have logs from the script in your MDM, but if you need to grab them locally on a machine you can grep them out of the unified log. `log show --style compact --process "logger" | grep "ScreenNudge"`
* Run the script as zsh
  * The most common issue that people run into is running the script as a bash script rather than as zsh. Zsh has been the default shell on macOS since macOS 10.15 Catalina. If your MDM does not support running scripts as zsh, I encourage you to reach out to them and request that they support zsh, which has been the default shell on macOS since October 2019.