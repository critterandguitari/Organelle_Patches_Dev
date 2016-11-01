# abl_link~
Ableton Link integration for Pd.

## Desktop version

Users:

* Simply install `abl_link~` from deken and check out the help patch.

Developers:

* Build the external by saying `make` in `abl_link/external` and install it like any other external.
* Run the metronome patch in `abl_link/external` to check the timing of the external against the LinkHut sample app.

## iOS version

**This version uses Ableton LinkKit 2.0.0.**

To see the iOS version of abl_link~ in action, try PdLinkSample in this repository.

### Getting started

* Set up a libpd-based Xcode project as usual.
* Add the Link library and headers to your project setup as described here: http://ableton.github.io/linkkit/#getting-started
* Add `abl_link/ios` to your header search path.
* Add `abl_link/ios/PdLinkAudioUnit.{h,m}` to the sources of your project.
* Add the Link preference pane to your user interface (e.g., by cargo-culting the relevant bits of the LinkHut sample project).
* Create a Link instance, a PdLinkAudioUnit instance, and a PdAudioController instance:

```
ABLLinkRef linkRef = ABLLinkNew(120);
PdLinkAudioUnit pdAudioUnit = [[PdLinkAudioUnit alloc] initWithLinkRef:linkRef];
PdAudioContoller pd = [[PdAudioController alloc] initWithAudioUnit:pdAudioUnit];
```

* Create a Pd patch using the desktop version of the Link external, `abl_link~`.
* Add the patch to your Xcode project.

