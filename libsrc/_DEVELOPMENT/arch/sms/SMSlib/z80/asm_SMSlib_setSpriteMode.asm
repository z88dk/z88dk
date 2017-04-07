; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setSpriteMode

EXTERN __SMSlib_spritesHeight, __SMSlib_spritesWidth
EXTERN asm_SMSlib_VDPturnOnFeature, asm_SMSlib_VDPturnOffFeature

asm_SMSlib_setSpriteMode:

   ; void SMS_setSpriteMode (unsigned char mode)
   ;
   ; enter :  l = unsigned char mode
   ;
   ; uses  : af, c, de, hl
   
   ld c,l                      ; c = mode

test_tallmode:

   ld a,c
   and SPRITEMODE_TALL

   ld hl,VDPFEATURE_USETALLSPRITES
   jr z, spritemode_tall_off

spritemode_tall_on:

   call asm_SMSlib_VDPturnOnFeature
   ld a,16
   
   jr spritemode_set_height

spritemode_tall_off:

   call asm_SMSlib_VDPturnOffFeature
   ld a,8

spritemode_set_height:

   ld (__SMSlib_spritesHeight),a

test_zoomed:

   ld a,c
   and SPRITEMODE_ZOOMED
   
   ld hl,VDPFEATURE_ZOOMSPRITES
   jr z, spritezoom_off

spritezoom_on:

   call asm_SMSlib_VDPturnOnFeature
   
   ld a,(__SMSlib_spritesHeight)
   add a,a
   ld (__SMSlib_spritesHeight),a
   
   ld a,16
   jr spritezoom_set_width

spritezoom_off:

   call asm_SMSlib_VDPturnOffFeature
   ld a,8

spritezoom_set_width:

   ld (__SMSlib_spritesWidth),a
   ret
