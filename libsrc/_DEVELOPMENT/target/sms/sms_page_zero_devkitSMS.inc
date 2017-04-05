; address = 0x0000

   di
   im 1

   jp __Start

; address = 0x0008

   defs 0x0008 - ASMPC

   PUBLIC _SMS_crt0_RST08
   PUBLIC __RST08_SMS_crt0_RST08

_SMS_crt0_RST08:               ; Restart 08h - write HL to VDP Control Port
__RST08_SMS_crt0_RST08:

   ld c,0xbf                   ; set VDP Control Port
   di                          ; make it interrupt SAFE
   out (c),l
   out (c),h
   ei
   ret

   defm "Z88DK"
   
; address = 0x0018

   defs 0x0018 - ASMPC

   PUBLIC _SMS_crt0_RST18
   PUBLIC __RST18_SMS_crt0_RST18

_SMS_crt0_RST18:               ; Restart 18h - write HL to VDP Data Port
__RST18_SMS_crt0_RST18:

   ld a,l                      ; (respecting VRAM time costraints)
   out (0xbe),a                ; 11
   ld a,h                      ; 4
   sub 0                       ; 7
   nop                         ; 4 = 26 (VRAM SAFE)
   out (0xbe),a
   ret

   defm "1.99C"

; address = 0x0028

   defs 0x0028 - ASMPC

IF (__crt_enable_rst & $20)

   EXTERN _z80_rst_28h
   jp _z80_rst_28h

ELSE

   ret

ENDIF

   PUBLIC l_ret
   
   pop hl
   pop hl
   pop hl
   
l_ret:
   
   ret

; address = 0x0030

   defs 0x0030 - ASMPC

IF (__crt_enable_rst & $40)

   EXTERN _z80_rst_30h
   jp _z80_rst_30h

ELSE

   ret

ENDIF

IF __SDCC_IY

   PUBLIC l_jpix
   
   l_jpix:
   
      defb $fd
   
   PUBLIC l_jphl
   
   l_jphl:
   
      jp (hl)
   
   PUBLIC l_jpiy
   
   l_jpiy:
   
      jp (ix)

ELSE

   PUBLIC l_jpix
   
   l_jpix:
   
      defb $dd
   
   PUBLIC l_jphl
   
   l_jphl:
   
      jp (hl)
   
   PUBLIC l_jpiy
   
   l_jpiy:
   
      jp (iy)

ENDIF

; address = 0x0038
; im 1 isr

   defs 0x0038 - ASMPC

IF (__crt_enable_rst & $80)

   EXTERN _z80_rst_38h
   jp _z80_rst_38h

ELSE
IF (__SMSLIB_ENABLE_MDPAD = 0)

   EXTERN asm_SMSlib_isr
   jp     asm_SMSlib_isr

ELSE

   EXTERN asm_SMSlib_isr_mdpad
   jp     asm_SMSlib_isr_mdpad

ENDIF
ENDIF

   PUBLIC l_setmem_hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

l_setmem_hl:

   ret

PUBLIC error_mc

   pop hl
   pop hl
   pop hl

error_mc:

   ; set hl = -1
   ; set carry flag
   
   ld hl,-1
   scf
   ret

; address = 0x0066

   defs 0x0066 - ASMPC

IF __crt_enable_nmi

   EXTERN _z80_nmi
   jp _z80_nmi

ELSE

   EXTERN asm_SMSlib_nmi_isr
   jp     asm_SMSlib_nmi_isr

ENDIF
