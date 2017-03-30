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

__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGPlay,void *song)
__OPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,h,l,iyl,iyh',void,,PSGCancelLoop,void)
__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGPlayNoRepeat,void *song)
__OPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,h,l,iyl,iyh',void,,PSGStop,void)
__OPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,PSGGetStatus,void)
__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGSetMusicVolumeAttenuation,unsigned char attenuation)

__DPROTO(`b,iyl,iyh',`iyl,iyh',void,,PSGSFXPlay,void *sfx,unsigned char channels)
__DPROTO(`b,iyl,iyh',`iyl,iyh',void,,PSGSFXPlayLoop,void *sfx, unsigned char channels)
__OPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,h,l,iyl,iyh',void,,PSGSFXCancelLoop,void)
__OPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGSFXStop,void)
__OPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,PSGSFXGetStatus,void)

__OPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,h,l,iyl,iyh',void,,PSGSilenceChannels,void)
__OPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',void,,PSGRestoreVolumes,void)

__OPROTO(`d,e',`d,e',void,,PSGFrame,void)
__OPROTO(`d,e',`d,e',void,,PSGSFXFrame,void)

#endif
