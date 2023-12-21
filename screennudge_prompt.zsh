#!/bin/zsh
# Script to prompt the end user to approve Screen Recording in System Preferences.

# REQUIREMENTS:
# This script runs on macOS 10.15 or higher. macOS 11 or higher is required for standard user approval (the MDM command was made available in Big Sur.)
#
# The script requires that the app being targeted is being deployed with a Privacy Profile library
# item that lets standard users approve Screen Capture. (Available in macOS Big Sur 11+)
#
# The MDM executing this script requires Full Disk Access in order to read the tcc.db and check to see if screen recording has been approved.
# (Most MDMs should already have this, since they would need access to do MDM-things)

# KNOWN ISSUES:
# On macOS Ventura, using x-urls to open the System Settings pane does not bring the window to the forefront.

###########################################################################################
# Created by Brian Van Peski - macOS Adventures
###########################################################################################
# Current version: 1.8 | See CHANGELOG for full version history.
# Updated: 12/21/2023

# Set logging - Send logs to stdout as well as Unified Log
# Use 'log show --process "logger"' in Terminal to view logs activity and grep for ScreenNudge to filter.
function LOGGING {
    /bin/echo "${1}"
    /usr/bin/logger "ScreenNudge: ${1}"
}

##############################################################
# USER INPUT 
##############################################################
appPath="/Applications/zoom.us.app"
appName="Zoom" #Name of app to present in dialog to user
appIcon="/Applications/zoom.us.app/Contents/Resources/ZPLogo.icns" #Path to app icon for messaging
dialogTitle="Screen Recording Approval"
dialogMessage="Please approve screen recording for $appName."
# SwiftDialog Options
swiftDialogOptions=(
  --mini
  --ontop
  --moveable
)

attempts=6 #How many attempts at prompting the user before giving up.
wait_time=10 #How many seconds to wait between user prompts.

##############################################################
# VARIABLES & FUNCTIONS
##############################################################
osVer="$(sw_vers -productVersion)"
currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
uid=$(id -u "$currentUser")
if [[ -d "$appPath" ]]; then
  bundleid=$(/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "$appPath/Contents/Info.plist")
  #hardcode this value if your app path is unique on each machine
  pppc_status=$(/usr/libexec/PlistBuddy -c 'print "'$bundleid':kTCCServiceScreenCapture:Authorization"' "/Library/Application Support/com.apple.TCC/MDMOverrides.plist")
else
  LOGGING "--- Could not find $appName installed at $appPath."
  exit 0
fi
KandjiAgent="/Library/Kandji/Kandji Agent.app"
#Path to SwiftDialog
dialogPath="/usr/local/bin/dialog"
dialogApp="/Library/Application Support/Dialog/Dialog.app"

runAsUser() {
  # From https://scriptingosx.com/2020/08/running-a-command-as-another-user
  if [ "$currentUser" != "loginwindow" ]; then
    launchctl asuser "$uid" sudo -u "$currentUser" "$@"
  else
    echo "No user logged in"
    # Uncomment the exit command to make the function exit with an error when no user is logged in
    # exit 1
  fi
}

Check_TCC (){
  #Split Screen Recording approval variables for Catalina vs Big Sur+
  if [[ $osVer > 11.* ]]; then
    export scApproval="$(sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" 'SELECT client FROM access WHERE service like "kTCCServiceScreenCapture" AND auth_value = '2'' | grep -o "$bundleid")"
  elif [[ $osVer == 10.15.* ]]; then
    export scApproval="$(sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" 'SELECT service, client FROM access WHERE allowed = '1'' | grep -o "$bundleid")"
  fi
}

UserDialog (){
  #First check if the app icon exists
  if [ -e "$appIcon" ]; then
    iconCMD=(--icon "$appIcon")
  else
    #If the icon file doesn't exist, set an empty array to omit from dialogs.
    iconCMD=()
  fi

  #If KandjiAgent is installed, use Kandji
  if [[ -d "$KandjiAgent" ]]; then
    /usr/local/bin/kandji display-alert --title "$dialogTitle" --message "$dialogMessage" ${iconCMD[@]}
  #No Kandji, and SwiftDialog is installed, use SwiftDialog
  elif [[ -e "$dialogPath" && -e "$dialogApp" ]]; then
    "$dialogPath" --title "$dialogTitle" --message "$dialogMessage" ${swiftDialogOptions[@]} ${iconCMD[@]}
  #No Kandji and no SwiftDialog, default to osascript w/ icon.
  elif [ -e "$appIcon" ]; then
    runAsUser /usr/bin/osascript -e 'display dialog "'"$dialogMessage"'" with title "'"$dialogTitle"'" with icon POSIX file "'"$appIcon"'" buttons {"Okay"} default button 1 giving up after 15'
  #No Kandji, no SwiftDialog, and no appicon. Use osascript.
  else
     runAsUser /usr/bin/osascript -e 'display dialog "'"$dialogMessage"'" with title "'"$dialogTitle"'" buttons {"Okay"} default button 1 giving up after 15'
  fi
}

################################################################
#  THE NEEDFUL
################################################################
#Check for a valid bundleid
if ! [[ $bundleid =~ ^[a-zA-Z0-9]+[-.](.*) ]]; then
  LOGGING "--- Could not find valid bundleid for $appName at $appPath!"
  exit 1
fi
#Check current ScreenCapture approval status
Check_TCC
#Check if Kandji Liftoff is running
if pgrep "Liftoff" >/dev/null; then
    LOGGING "--- Liftoff is running. Exiting to wait for apps to finish installing..."
    exit 0
#Check to see if app is installed and if ScreenCapture is approved.
elif [[ $scApproval == "$bundleid" ]]; then
  LOGGING "ScreenCapture has already been approved for $appName..."
  exit 0
elif [[ -d "$appPath" && $scApproval != "$bundleid" && $pppc_status == "AllowStandardUserToSetSystemService" ]]; then
  LOGGING "--- $appName is installed with bundleid: "$bundleid" and AllowStandardUserToSetSystemService is set via PPPC Profile"
  #Prompt user for Screen Recording Approval and loop until approved.
  dialogAttempts=0
  until [[ $scApproval = $bundleid ]]
    do
      if (( $dialogAttempts >= $attempts )); then
          LOGGING "Prompts have been ignored after $attempts attempts. Giving up..."
          exit 1
      fi
      LOGGING "--- Requesting user to manually approve ScreenCapture for $appName..."
      runAsUser open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
      #Activating System Settings (Ventura Workaround)
      runAsUser /usr/bin/osascript -e 'tell application "System Settings"' -e 'activate' -e 'end tell'
      UserDialog
      #launchctl asuser 501 say -v Samantha 'Please approve Screen Recording for '$AppName' in System Preferences.' #optional voice annoyance prompt for depot/warehouse scenarios
      sleep $wait_time
      ((dialogAttempts++))
      LOGGING "--- Checking for approval of ScreenCapture for $appName..."
      Check_TCC
    done
    LOGGING "Screen Recording for $appName has been approved! Exiting..."
    runAsUser /usr/bin/osascript -e 'quit app "System Preferences"'
    exit 0
elif [[ -d "$appPath" && $pppc_status != "AllowStandardUserToSetSystemService" ]]; then
  LOGGING "--- Could not find valid PPPC Profile for $appName allowing Standard User to Approve."
  exit 1
else
  LOGGING "$appName not found. Exiting..."
  exit 0
fi
