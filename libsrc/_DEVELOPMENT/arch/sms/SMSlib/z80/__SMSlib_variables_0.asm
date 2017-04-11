; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION rodata_clib
SECTION rodata_SMSlib

PUBLIC __SMSlib_VDPReg_init

__SMSlib_VDPReg_init:

   defb 0x04                   ; /* reg0: Mode 4 */
   defb 0x20                   ; /* reg1: display OFF - frame int (vblank) ON */
   defb ((__SMSLIB_PNTADDRESS & 0x3800) >> 10) + 0xf1                     ; /* reg2: PNT at 0x3800 */
   defb 0xFF                   ; /* reg3: no effect (when in mode 4) */
   defb 0xFF                   ; /* reg4: no effect (when in mode 4) */
   defb ((__SMSLIB_SATADDRESS & 0x3f00) >> 7) + 0x81                      ; /* reg5: SAT at 0x3F00 */
   defb ((__SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS & 0x2000) >> 11) + 0xfb  ; /* reg6: Sprite tiles at 0x2000 */
   defb 0x00                   ; /* reg7: backdrop color (zero) */
   defb 0x00                   ; /* reg8: scroll X (zero) */
   defb 0x00                   ; /* reg9: scroll Y (zero) */
   defb 0xFF                   ; /* regA: line interrupt count (offscreen) */


SECTION data_clib
SECTION data_SMSlib

PUBLIC __SMSlib_VDPReg
PUBLIC __SMSlib_spritesHeight
PUBLIC __SMSlib_spritesWidth
PUBLIC __SMSlib_theLineInterruptHandler

EXTERN l_ret

__SMSlib_VDPReg:

   defb 0x04, 0x20             ; /* the VDP registers #0 and #1 'shadow' (initialized RAM) */

__SMSlib_spritesHeight:

   defb 8

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
