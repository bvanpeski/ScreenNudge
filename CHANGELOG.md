# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6] - 2022-10-22
### Added
- Added bundleid/app path checks
- Added an osascript command to bring System Settings to the forefront since the x-url doesn't seem to do that in macOS Ventura. Bug has been filed with Apple.

## [1.5] - 2022-05-12
### Added
- Added dialog function to present display the dialog depending on variables that have been set.

## [1.4] - 2022-02-22
### Added
- Added unified logging

## [1.3] - 2018-02-18
### Changed
- Final v1 tweaks

## [1.2] - 2022-02-16
### Changed
- Consolidated TCCcheck logic
- Added separate check to see if ScreenCapture was already approved.

## [1.1.1] - 2021-05-14
### Changed
- Improved TCCcheck to ensure it checks for ScreenCapture approval specifically in the tcc.db.

## [1.1] - 2020-07-30
### Added
- Added logic for Screen Recording approval on macOS Catalina.

## [1.0] - 2020-02-20
### Added
- First go at a solution for guiding users to approve screen recording.
