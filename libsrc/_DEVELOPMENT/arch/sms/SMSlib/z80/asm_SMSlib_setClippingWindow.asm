; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setClippingWindow

EXTERN __SMSlib_clipWin_x0, __SMSlib_clipWin_x1

asm_SMSlib_setClippingWindow:

   ; void SMS_setClippingWindow (unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1)
   ;
   ; enter :  e = x0
   ;          d = y0
   ;          l = x1
   ;          h = y1
   ;
   ; uses  : none
   
   ld (__SMSlib_clipWin_x0),de
   ld (__SMSlib_clipWin_x1),hl
   ret
