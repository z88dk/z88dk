# Aquarius+ Turbosound Player

[Turbo Sound](https://cs.wikipedia.org/wiki/Turbo_Sound) refers to 2 x [AY-3-891X](https://en.wikipedia.org/wiki/General_Instrument_AY-3-8910) style devices providing 6 channels of tone + 2 noise channels. Since the Aquarius+ has 2 x AY devices, it is Turbo Sound capable.

The PT3 module format allows for 1 or 2 AY devices. [Vortex Tracker II](https://github.com/ivanpirog/vortextracker/releases) is capable of loading a [Turbo Sound PT3 file](https://zxart.ee/eng/music/database/formatGroup:ts/format:PT3/sortParameter:date/sortOrder:desc/resultsType:zxitem/) and saving it as 2 separate PT3 formatted files, one for each AY device.

This example takes the 2 PT3 files and instantiates 2 instances of the VTII PT3 player, one for each AY device. The result is 6 tone channels and 2 noise channels of audio.
