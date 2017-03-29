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
