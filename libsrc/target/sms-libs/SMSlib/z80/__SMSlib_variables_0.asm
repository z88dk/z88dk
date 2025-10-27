; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION data_clib
SECTION data_SMSlib

PUBLIC __SMSlib_VDPReg
PUBLIC __SMSlib_spritesHeight
PUBLIC __SMSlib_spritesWidth
PUBLIC __SMSlib_spritesTileOffset
PUBLIC __SMSlib_theLineInterruptHandler

EXTERN l_ret, _GLOBAL_SMS_VDP_R0R1

defc __SMSlib_VDPReg = _GLOBAL_SMS_VDP_R0R1  ; /* the VDP registers #0 and #1 'shadow' (initialized RAM) */

__SMSlib_spritesHeight:

   defb 8

__SMSlib_spritesTileOffset:    ; /* MUST FOLLOW spritesHeight */

   defb 1

__SMSlib_spritesWidth:

   defb 8

__SMSlib_theLineInterruptHandler:

   defw l_ret                  ; /* 'empty' line interrupt handler */


SECTION bss_clib
SECTION bss_SMSlib

PUBLIC __SMSlib_VDPBlank
PUBLIC __SMSlib_VDPFlags
PUBLIC __SMSlib_PauseRequested
PUBLIC __SMSlib_VDPType
PUBLIC __SMSlib_KeysStatus
PUBLIC __SMSlib_PreviousKeysStatus
PUBLIC __SMSlib_SpriteTableY
PUBLIC __SMSlib_SpriteTableXN
PUBLIC __SMSlib_SpriteNextFree

__SMSlib_VDPBlank:

   defb 0                      ; /* used by INTerrupt */

__SMSlib_VDPFlags:

   defb 0                      ; /* holds the sprite overflow and sprite collision flags */

__SMSlib_PauseRequested:

   defb 0                      ; /* used by NMI (SMS only) */

__SMSlib_VDPType:

   defb 0                      ; /* used by NTSC/PAL and VDP type detection (SMS only) */

__SMSlib_KeysStatus:

   defw 0

__SMSlib_PreviousKeysStatus:

   defw 0

__SMSlib_SpriteTableY:

IF MAXSPRITES = 64

   defs MAXSPRITES

ELSE

   defs MAXSPRITES + 1

ENDIF

__SMSlib_SpriteTableXN:

   defs MAXSPRITES * 2

__SMSlib_SpriteNextFree:

   defb 0
