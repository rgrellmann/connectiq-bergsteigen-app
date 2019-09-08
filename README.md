# connectiq-bergsteigen-app
A device app for Garmin Smart Watches intended for mountain tours.

It has two data fields with values which I find useful during mountain tours.

Currently it is only working on the vívoactive 3 series.
Currently only english and german translations are available.

The first DataField contains informations which are of permanent interest during mountain tours, and should be easily readable while walking or climbing.
* current altitiude
* current heart rate
* total ascent and total descent (in my opinion the ascent and descent are more important during mountain tours than the elapsed distance, which can be found on DataField 2)
* elapsed time
* battery status icon
* current clock time

The second DataField contains informations which may be useful on mountain tours, but not of permanent interest or not frequently needed.
Values on this DataField:
* current position (latitude/longitude in decimal degrees, like on Google Maps)
* current heading (degrees and letters)
* time of sunrise and time of sunset at the current location
* burned calories during this activity
* elapsed distance during this activity (in my opinion the ascent and descent are more important during mountain tours, so these values are on DataField 1)
* battery status icon
* current clock time
* current temperature in degrees celsius
* current barometric pressure and mean sea level pressure (altitude and temperature compensated value) in hPa

## Plans for the future
* more translations (help is appreciated!)
* a confirmation dialog before discarding an activity
* maybe some graphs (heart rate, altitude)
* maybe a very simple map with way points
* suggestions are welcome
