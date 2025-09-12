# Changelog

All notable changes (starting from v1.0) will be documented here

<!-- options to add in the file: 
- Added
- Changed
- Depricated
- Removed
- Fixed
- Security -->

## v1.3.2 - 18/07/2025

### Fixed

- Autostart function was not working properly
- Presentation docs was being moved to `Others` directory 

## v1.3.1 - 18/06/2025

### Fixed

- status was showing `Loaded` even if it was disabled

## v1.3.0 - 18/06/2025

### Added

Added few new options

- `restart` : Stops current running processes and restarts watching
- `enable` : Sets up a configuration to autostart the program (watching) on boot
- `disable` : Changes the configuration to stop autostart on boot
- `status` : Checks the status and shows if running, enabled, etc

## v1.2.1 - 17/06/2025

### Fixed

- `downganizer start` was throwing up warnings/errors on the terminal
- `downganizer stop` was not stopping the process `inotifywait`

## v1.2.0 - 17/06/2025

### Added

- option `stop` to stop any currently running monitors

### Changed

- `downganizer start` disowns the process and runs in background

## v1.1.1 - 15/06/2025

### Fixed

- version and help flags not working

## v1.1 - 13/06/2025

### Fixed

- Weren't moving some files downloaded while monitoring

### Known issues
    
- Can't use version or help flag

## v1.0 - 12/06/2025

### Features

- downganizer do: Organized current files in the ~/Downloads folder
- downganizer start: Monitors the Downloads folder in realtime and moves any new file(created or downloaded).