# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v 1.7 | 2023-02-02
`Added` - Added user input for how many attempts to make before giving up.
`Added` - User input for wait time between prompts

## v 1.6.1 | 2023-01-03
`Changed` - Modified bundleid regex logic to account for non-standard bundle id formats.

## v 1.6 | 2022-10-22
`Added` - Bundleid/app path checks

`Added` - Added an osascript command to bring System Settings to the forefront since the `open x-url` commands don't seem to do that in macOS Ventura. Bug has been filed with Apple.

## v 1.5 | 2022-05-12
`Added` - Added a dialog function to present display the dialog depending on variables that have been set.

## v 1.4 | 2022-02-22
`Added` - Unified logging

## v 1.3 | 2018-02-18
`Changed` - Final v1 tweaks

## v 1.2 | 2022-02-16
`Changed` - Consolidated TCCcheck logic
`Added` - Added an additional check to see if ScreenCapture is already approved.

## v 1.1.1 | 2021-05-14
`Changed` -  Improved TCCcheck to ensure it checks for ScreenCapture approval specifically in the tcc.db.

## v 1.1 | 2020-07-30
`Added` - Added logic for Screen Recording approval on macOS Catalina.

## v 1.0 | 2020-02-20
`Added` - First go at a solution for guiding users to approve screen recording.
