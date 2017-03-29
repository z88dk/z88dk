include(__link__.m4)

#ifndef _SMS_PSGLIB_H
#define _SMS_PSGLIB_H

/* **************************************************
   PSGlib - C programming library for the SEGA PSG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   Synchronized March 29, 2017
   ************************************************** */

#define PSG_STOPPED         0
#define PSG_PLAYING         1

#define SFX_CHANNEL2        0x01
#define SFX_CHANNEL3        0x02
#define SFX_CHANNELS2AND3   SFX_CHANNEL2|SFX_CHANNEL3

__DPROTO(,,void,,PSGPlay,void *song)
__OPROTO(,,void,,PSGCancelLoop,void)
__DPROTO(,,void,,PSGPlayNoRepeat,void *song)
__OPROTO(,,void,,PSGStop,void)
__OPROTO(,,unsigned char,,PSGGetStatus,void)
__DPROTO(,,void,,PSGSetMusicVolumeAttenuation,unsigned char attenuation)

__DPROTO(,,void,,PSGSFXPlay,void *sfx,unsigned char channels)
__DPROTO(,,void,,PSGSFXPlayLoop,void *sfx, unsigned char channels)
__OPROTO(,,void,,PSGSFXCancelLoop,void)
__OPROTO(,,void,,PSGSFXStop,void)
__OPROTO(,,unsigned char,,PSGSFXGetStatus,void)

__OPROTO(,,void,,PSGSilenceChannels,void)
__OPROTO(,,void,,PSGRestoreVolumes,void)

__OPROTO(,,void,,PSGFrame,void)
__OPROTO(,,void,,PSGSFXFrame,void)

#endif
