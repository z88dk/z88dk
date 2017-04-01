; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION bss_lib
PUBLIC _SpriteTableY

include "../SMSlib_private.inc"

_SpriteTableY:

IF MAXSPRITES = 64
   defs 64
ELSE
   defs MAXSPRITES+1
ENDIF
