# mindfulnotifier

## About this app

This app is a simple mindfulness-based timer which displays a 
notification/reminder at user-defined intervals. Reminders are taken 
from a configurable list, and can be configured
either for periodic or random intervals.

Some default reminders are provided as examples. 

You can add and remove from the notifications defaults as you like.
There are 5 bells included, and you can also configure a custom bell
from your phone's local storage.

The app is built using [Flutter](https://flutter.dev/).

It currently only runs on Android.


### Features:

* Configure either a periodic or random reminder interval.
    - e.g. hourly, or every 15 minutes, or randomly between 30 minutes and an hour
    - periodic intervals are aligned from the top of the hour
* Edit or add your own reminder messages.
    - Choose from a set of default bells, or provide your own.
* Separate controls for 'mute' and 'vibrate'.
* Define a time range for daily quiet hours.

### Notes on Application Settings in Android

#### Battery Optimization

Some phones will kill apps when running in the background after a relatively short period of time.
Unfortunately, if your phone is killing the app then you will stop getting notifications.
If this is happening, you must disable any 'battery optimization' settings for this app. This
varies from phone-to-phone - generally you must go into the settings for the app on your phone and turn off
any battery optimization. See https://dontkillmyapp.com/ for your phone type and android version for
more information.


### Bells

* Bell 1: is from user 'steaq' via [https://freesound.org/s/346328](https://freesound.org/s/346328/)
and is licensed under the [Creative Commons 0 License][CC0].

* Bell 2: is from user 'itsallhappening' via [https://freesound.org/people/itsallhappening/sounds/48795](https://freesound.org/s/48795/)
and is licensed under the [Creative Commons Sampling+ License][CCS]

* Bell 3: is from user 'suburban grilla' via [https://freesound.org/people/suburban%20grilla/sounds/2166](https://freesound.org/s/2166/)
and is licensed under the [Creative Commons Sampling+ License][CCS]

* Bell 4: is from user 'kerri' via [https://freesound.org/people/kerri/sounds/27421/](https://freesound.org/people/kerri/sounds/27421/)
and is licensed under the [Creative Commons Attribution License][CCA]

* Bell 5: is from user 'dobroide' via [https://freesound.org/people/dobroide/sounds/436976/](https://freesound.org/people/dobroide/sounds/436976/)
and is licensed under the [Creative Commons Attribution License][CCA]

[CC0]: http://creativecommons.org/publicdomain/zero/1.0/   "Creative Commons 0 License"
[CCS]: http://creativecommons.org/licenses/sampling+/1.0/  "Creative Commons Sampling+ License"
[CCA]: https://creativecommons.org/licenses/by/3.0/        "Creative Commons Attribution License"


## License

This project is licensed under the terms of the GNU General Public License v3.0.
