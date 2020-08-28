# Color Tracking

Matlab script for color based tracking algorithm. Currently the algorithm tracks two objects which are selected by the user.
*Note: This script performs tracking on recorded video files, it does not perform live tracking.*

### Input:
- Video file

### Output:
- Coordinates (in pixels) of the objects tracked

## Preparations:
1. Download and save all the scripts in the same folder.
2. Transfer the video file that will be used for tracking.
3. Change your current folder in MATLab to the folder with the scripts and video file.

## Running the script:
1. Open the MultipleColorTracking.m script.
2. Replace the string in line 25 with the video file for tracking.
`obj = VideoReader('REPLACEME'); `
3. If needed, replace the naming of the output in line 134 and 135 `Rover.mat` in `save Rover.mat output1`
4. Upon running the script, a window will appear where you will click and drag around the first object for tracking. It will appear again immediately to select the second object.
