## 0.0.3
Fidelity and nullability (January, 2023)

 * `LeaderMenuFocalPoint` now follows the global `Leader` offset, instead of the local `Leader` offset.
 * `LeaderMenuFocalPoint` now accounts for `Leader` scale when reporting focal point offset.
 * `CupertinoPopoverMenu` doesn't blow up when the focal point offset is null.  

## 0.0.2+1
`CupertinoPopoverMenu` hit-test fix (January, 2023)

 * `CupertinoPopoverMenu` was hit-testing its paging buttons even when they were invisible.

## 0.0.2
Easier menu arrow orientation (December, 2022):

 * Replaced `globalFocalPoint` in `CupertinoPopoverToolbar` and `CupertinoPopoverMenu` with `focalPoint` of type `MenuFocalPoint`, which looks up the `Offset` on demand.
 * Added `LeaderMenuFocalPoint`, which gets its focal point offset from a `Leader` widget.

## 0.0.1
Initial Release (December, 2022):

 * `CupertinoPopoverToolbar` - an iOS-style popover toolbar with configurable buttons
 * `CupertinoPopoverMenu` - an iOS-style popover menu
 * `FollowerAligner`s are available to integrate Cupertino popovers with `follow_the_leader` for easy positioning
