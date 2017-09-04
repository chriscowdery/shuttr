Shuttr
======
A drop-dead simple app for taking pics from the command line on macOS.

Building
========
Requires macOS 10.12 or higher to build. Nothing else is required.

Running
=======
- Run the app and it will take a picture and save it to ```~/photobooth-shots```.
- The absolute path to the photo is logged to the stdout (so it can be used in other apps).
- Photos are saved in TIFF format.
- If you don't have a CI-compliant source connected, it'll default to your iSight camera.