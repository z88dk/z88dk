; address = 0x0000

   di
   im 1

   jp __Start

; address = 0x0008

   defs 0x0008 - ASMPC

IF (__crt_enable_rst & $02)

   EXTERN _z80_rst_08h
   jp _z80_rst_08h

ELSE

   ret

ENDIF

   defm "Z88DK"

; address = 0x0010

   defs 0x0010 - ASMPC

IF (__crt_enable_rst & $04)

   EXTERN _z80_rst_10h
   jp _z80_rst_10h

ELSE

   ret

ENDIF

   defm "1.99C"
   
; address = 0x0018

   defs 0x0018 - ASMPC
   
IF (__crt_enable_rst & $08)

   EXTERN _z80_rst_18h
   jp _z80_rst_18h

ELSE

   ret

ENDIF

   PUBLIC l_dec_de

   dec de
   dec de
   dec de
   
l_dec_de:

   ret

; address = 0x0020

   defs 0x0020 - ASMPC

IF (__crt_enable_rst & $10)

   EXTERN _z80_rst_20h
   jp _z80_rst_20h

ELSE

   ret

ENDIF

   PUBLIC l_dec_bc

   dec bc
   dec bc
   dec bc
   
l_dec_bc:

   ret

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

   push af
   in a,(0xbf)
   pop af
   ei
   ret

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

PUBLIC error_lznc

   EXTERN error_znc

   pop hl

error_lznc:
   
   ld de,0
   jp error_znc

; address = 0x0066

   defs 0x0066 - ASMPC

IF __crt_enable_nmi

   EXTERN _z80_nmi
   jp _z80_nmi

ELSE

   retn

ENDIF
