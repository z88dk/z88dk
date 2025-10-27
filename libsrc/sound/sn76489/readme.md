PSGlib library from [devkitSMS](https://github.com/sverx/devkitSMS)
synchronized March 29, 2017

PSGlib
======

these are the currently defined functions/macros:

```
void PSGPlay (unsigned char *song);             /* this will make your PSG tune start */
void PSGCancelLoop (void);                      /* tell the library to stop the tune at next loop */
void PSGPlayNoRepeat (unsigned char *song);     /* this will make your PSG tune start and stop at loop */
void PSGStop (void);                            /* this will make your PSG tune stop */
unsigned char PSGGetStatus (void);              /* get the current status of the tune */

void PSGSetMusicVolumeAttenuation (unsigned char attenuation);   /* this will set the tune attenuation (0-15) */

void PSGSFXPlay (unsigned char *sfx, unsigned char channels);         /* this will make your SFX start */
void PSGSFXPlayLoop (unsigned char *sfx, unsigned char channels);     /* this will make your looping SFX start */
void PSGSFXCancelLoop (void);                                         /* tell the library to stop the SFX at next loop */
void PSGSFXStop (void);                                               /* this will make your SFX stop */
unsigned char PSGSFXGetStatus (void);                                 /* get the current status of the SFX */

void PSGSilenceChannels (void);
                 /* this will silence all PSG channels */
void PSGRestoreVolumes (void);
                  /* this will restore PSG channels volume */

void PSGFrame (void);                           /* you should call this at a constant pace */
void PSGSFXFrame (void);                        /* you should call this too at a constant pace, if you use SFXs */
```

Information
===========

Z80 ASM library (and C conversion/compression tools) to allow replay of VGMs as background music/SFX in SEGA 8 bit homebrew programs

Typical workflow:

1) You (or a friend of yours) track one or more module(s) and SFX(s) using either Mod2PSG2 or DefleMask or VGM Music Maker (or whatever tool you prefer as long as it supports exporting in VGM format).

2) Optional, but warmly suggested: optimize your VGM(s) using Maxim's VGMTool

3) Convert the VGM to PSG file(s) using the vgm2psg tool.

4) Optional, suggested: compress the PSG file(s) using the psgcomp tool. The psgdecomp tool can be used to verify that the compression was right.

5) include the library and 'incbin' the PSG file(s) to your Z80 ASM source.

6) call PSGInit once somewhere near the beginning of your code.

7) Set up a steady interrupt (vertical blanking for instance) so to call PSGFrame and PSGSFXFrame at a constant pace (very important!). The two calls are separated so you can eventually switch banks when done processing background music and need to process SFX.

8) Start/stop tunes when needed using PSGPlay and PSGStop calls, start/stop SFXs when needed using PSGSFXPlay and PSGSFXStop calls.
   
 * Looping SFXs are supported too: fire them using a PSGSFXPlayLoop call, cancel their loop using a PSGSFXCancelLoop call.

 * Tunes can be set to run just once instead of endlessly using PSGPlayNoRepeat call, or set a playing tune to have no more loops using PSGCancelLoop call at any time.
 
 * To check if a tune is still playing use PSGGetStatus call, to check if a SFX is still playing use PSGSFXGetStatus call.
 
+) You can set the music 'master' volume using PSGSetMusicVolumeAttenuation, even when a tune it's playing (and this won't affect SFX volumes).
 
+) If you need to temporary suspend audio, use PSGSilenceChannels and stop calling PSGFrame and PSGSFXFrame. When ready to resume, use PSGRestoreVolumes.
