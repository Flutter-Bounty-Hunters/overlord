## 0.0.4
### July 9, 2025
 * Upgraded `follow_the_leader` to `v0.0.5` which changed the `FollowerBoundary` 
   and `FollowerAligner` APIs.
 * Started using `flutter_test_goldens` for golden tests.

## 0.0.3+5
### Feb, 2024
Added `PopoverScaffold` for building popover drop down lists.

## 0.0.3+4
### Sept, 2023
Upgraded `follow_the_leader` to `0.0.4+5`.

## 0.0.3+3
### Sept, 2023
Upgraded `follow_the_leader` to `0.0.4+4` and added a scrolling demo.

## 0.0.3+2
### April, 2023
Better match for iOS popover and toolbar.

 * Popover and toolbar can extend content into the popover's arrow region.
 * Arrow icons replaced with chevrons.
 * Adjusted some colors.

## 0.0.3+1
### Jan, 2023
Toolbar elevation, `follow_the_leader` update.

 * CupertinoPopoverToolbar and CupertinoPopoverMenu support elevation with shadows.
 * Upgraded `follow_the_leader` to v0.0.4+2 to get updated Follower scaling support.

## 0.0.3
### Jan, 2023
Fidelity and nullability.

 * `LeaderMenuFocalPoint` now follows the global `Leader` offset, instead of the local `Leader` offset.
 * `LeaderMenuFocalPoint` now accounts for `Leader` scale when reporting focal point offset.
 * `CupertinoPopoverMenu` doesn't blow up when the focal point offset is null.  

## 0.0.2+1
### Jan, 2023
`CupertinoPopoverMenu` hit-test fix.

 * `CupertinoPopoverMenu` was hit-testing its paging buttons even when they were invisible.

## 0.0.2
### Dec, 2023
Easier menu arrow orientation.

 * Replaced `globalFocalPoint` in `CupertinoPopoverToolbar` and `CupertinoPopoverMenu` with `focalPoint` of type `MenuFocalPoint`, which looks up the `Offset` on demand.
 * Added `LeaderMenuFocalPoint`, which gets its focal point offset from a `Leader` widget.

## 0.0.1
### Dec, 2022
Initial Release.

 * `CupertinoPopoverToolbar` - an iOS-style popover toolbar with configurable buttons
 * `CupertinoPopoverMenu` - an iOS-style popover menu
 * `FollowerAligner`s are available to integrate Cupertino popovers with `follow_the_leader` for easy positioning
