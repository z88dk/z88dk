include(__link__.m4)

#ifndef _SMS_PSGLIB_H
#define _SMS_PSGLIB_H

#include <arch.h>

/* **************************************************
   PSGlib - C programming library for the SEGA PSG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   Synchronized March 29, 2017
   ************************************************** */

#define PSG_STOPPED         __PSGLIB_PSG_STOPPED
#define PSG_PLAYING         __PSGLIB_PSG_PLAYING

#define SFX_CHANNEL2        __PSGLIB_SFX_CHANNEL2
#define SFX_CHANNEL3        __PSGLIB_SFX_CHANNEL3
#define SFX_CHANNELS2AND3   __PSGLIB_SFX_CHANNELS2AND3

__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGPlay,void *song)
__OPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,h,l,iyl,iyh',void,,PSGCancelLoop,void)
__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGPlayNoRepeat,void *song)
__OPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,h,l,iyl,iyh',void,,PSGStop,void)
__OPROTO(`a,b,c,d,e,iyl,iyh',`a,b,c,d,e,iyl,iyh',unsigned char,,PSGGetStatus,void)
__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGSetMusicVolumeAttenuation,unsigned char attenuation)

__DPROTO(`b,iyl,iyh',`iyl,iyh',void,,PSGSFXPlay,void *sfx,unsigned char channels)
__DPROTO(`b,iyl,iyh',`iyl,iyh',void,,PSGSFXPlayLoop,void *sfx, unsigned char channels)
__OPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,h,l,iyl,iyh',void,,PSGSFXCancelLoop,void)
__OPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGSFXStop,void)
__OPROTO(`a,b,c,d,e,iyl,iyh',`a,b,c,d,e,iyl,iyh',unsigned char,,PSGSFXGetStatus,void)

__OPROTO(`a,d,e,iyl,iyh',`a,d,e,iyl,iyh',void,,PSGSilenceChannels,void)
__OPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGRestoreVolumes,void)

__OPROTO(`d,e,iyl,iyh',`d,e,iyl,iyh',void,,PSGFrame,void)
__OPROTO(`d,e,iyl,iyh',`d,e,iyl,iyh',void,,PSGSFXFrame,void)

#endif
