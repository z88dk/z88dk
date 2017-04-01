; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_init

EXTERN _VDPReg_init, _VDPType
EXTERN asm_SMS_resetPauseRequest
EXTERN asm_SMS_initSprites, asm_SMS_finalizeSprites, asm_SMS_copySpritestoSAT

include "../SMSlib_private.inc"

asm_SMS_init:

   di
   
   ld b,11
   ld hl,_VDPReg_init
   
loop:

   ld a,(hl)
   inc hl
   
   out (VDPControlPort),a
   
   ld a,11+0x80
   sub b
   
   out (VDPControlPort),a
   
   djnz loop
   
   ei
   
   call asm_SMS_initSprites
   call asm_SMS_finalizeSprites
   call asm_SMS_copySpritestoSAT
   call asm_SMS_resetPauseRequest
   
   ;; void SMS_detect_VDP_type (void)
   
loop00:

   in a,(VDPVCounterPort)
   
   cp 0x81
   jr nc, loop00               ; // wait next frame starts

loop01:

   in a,(VDPVCounterPort)
   
   cp 0x80
   jr c, loop01                ; // wait next half frame
   
loop02:

   in a,(VDPVCounterPort)
   ld c,a
   
   in a,(VDPVCounterPort)
   
   cp c
   jr nc, loop02               ; // wait until VCounter 'goes back'
   
   ld a,c
   cp 0xe7
   
   ld a,VDP_PAL
   jr nc, detected
   
   ld a,VDP_NTSC

detected:
   
   ld (_VDPType),a
   ret
