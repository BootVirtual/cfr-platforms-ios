#  CFR Platforms

This project serves as a client for my [CFR Arrivals/Departures API](https://github.com/BootVirtual/cfr-platforms).

## Note

This app is provided as-is, the accuracy of the displayed information is not guaranteed (more on that on the API Readme, link above).

## Features

The app is a departures/arrivals board, currently supporting Bucharest North and Cluj Napoca.

You can change the API address in the settings panel. The app also remembers your last station and tab (arrivals/departures) across restarts.

There are also widgets available, for departures and arrivals, configurable in the settings panel. They come in medium and large sizes, showing up to 3, respectively 8 trains at a time and _should_ refresh every minute. There is one caveat, in that all departures widgets share the same station, and same with arrivals. I tried to make a proper configurable widget, so you can adapt them individually, but ca. 7 hours of debugging led to nothing so this is going to be it.

Also, the app and widgets should be smart enough to automatically show new stations shall they be added to the API.

Live activities could be an interesting feature, but honestly, seeing how (in)accurate the OCR is, it would probably be a pain to keep track of the same train accross data refreshes. A similar issue would arise with trying to link to the train page on the CFR/Infofer/operator websites, as one wrong digit could lead to a 404 or to the wrong train being fetched.

## Endnote

This project is being developed as a submission to [HackClub](https://hackclub.com/). It is still very much a WIP.

