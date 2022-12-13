## 0.0.2
Easier menu arrow orientation:

* Replaced `globalFocalPoint` in `CupertinoPopoverToolbar` and `CupertinoPopoverMenu` with `focalPoint` of type `MenuFocalPoint`, which looks up the `Offset` on demand.
* Added `LeaderMenuFocalPoint`, which gets its focal point offset from a `Leader` widget.

## 0.0.1
Initial Release:

* `CupertinoPopoverToolbar` - an iOS-style popover toolbar with configurable buttons
* `CupertinoPopoverMenu` - an iOS-style popover menu
* `FollowerAligner`s are available to integrate Cupertino popovers with `follow_the_leader` for easy positioning
