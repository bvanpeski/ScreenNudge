# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v 1.8 | 2023-12-21
`CHANGED` - Modified all `open` and `osascript` commands to run as the currently logged in user to catch edge cases where the open command failed to open System Settings.

## v 1.7 | 2023-02-27
`ADDED` - Included check for PPPC Profile allowing standard user to approve the app.

`ADDED` - Added user input for how many attempts to make before giving up.

`ADDED` - User input for wait time between prompts

`ADDED` - Support for SwiftDialog

`CHANGED` - Modified applescript dialog to resolve issue where it would fail to execute in some instances.

## v 1.6.1 | 2023-01-03
`CHANGED` - Modified bundleid regex logic to account for non-standard bundle id formats.

## v 1.6 | 2022-10-22
`ADDED` - Bundleid/app path checks

`ADDED` - Added an osascript command to bring System Settings to the forefront since the `open x-url` commands don't seem to do that in macOS Ventura. Bug has been filed with Apple.

## v 1.5 | 2022-05-12
`ADDED` - Added a dialog function to present display the dialog depending on variables that have been set.

## v 1.4 | 2022-02-22
`CHANGED` - Unified logging

## v 1.3 | 2018-02-18
`CHANGED` - Final v1 tweaks

## v 1.2 | 2022-02-16
`CHANGED` - Consolidated TCCcheck logic

`ADDED` - Added an additional check to see if ScreenCapture is already approved.

## v 1.1.1 | 2021-05-14
`CHANGED` -  Improved TCCcheck to ensure it checks for ScreenCapture approval specifically in the tcc.db.

## v 1.1 | 2020-07-30
`ADDED` - Added logic for Screen Recording approval on macOS Catalina.

## v 1.0 | 2020-02-20
`ADDED` - First go at a solution for guiding users to approve screen recording.
