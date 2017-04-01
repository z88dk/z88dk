; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_crt_common
PUBLIC asm_SMS_nmi_isr

EXTERN _SMS_Flags

asm_SMS_nmi_isr:

   push hl
   
   ld hl,_SMS_Flags
   set 0,(hl)
   
   pop hl
   retn
