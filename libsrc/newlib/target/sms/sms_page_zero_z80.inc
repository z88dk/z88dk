; address = 0x0000

   di
   im 1

   jp __Start

; address = 0x0008

   defs 0x0008 - ASMPC

IF ((__crt_enable_rst & $0202) = $02)

   EXTERN _z80_rst_08h
   jp     _z80_rst_08h

ELSE

   IF ((__crt_enable_rst & $0202) = $0202)

   jp     __z80_rst_08h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $0202) != $0202)
   
   PUBLIC _z80_rst_08h_vector
   defc   _z80_rst_08h_vector = $09
     
ENDIF

   defm "Z88DK"

; address = 0x0010

   defs 0x0010 - ASMPC

IF ((__crt_enable_rst & $0404) = $04)

   EXTERN _z80_rst_10h
   jp     _z80_rst_10h

ELSE

   IF ((__crt_enable_rst & $0404) = $0404)

   jp     __z80_rst_10h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $0404) != $0404)
   
   PUBLIC _z80_rst_10h_vector
   defc   _z80_rst_10h_vector = $11
      
ENDIF

   defm "2.00"
   
; address = 0x0018

   defs 0x0018 - ASMPC
   
IF ((__crt_enable_rst & $0808) = $08)

   EXTERN _z80_rst_18h
   jp     _z80_rst_18h

ELSE

   IF ((__crt_enable_rst & $0808) = $0808)

   jp     __z80_rst_18h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $0808) != $0808)
   
   PUBLIC _z80_rst_18h_vector
   defc   _z80_rst_18h_vector = $19
      
ENDIF

   PUBLIC l_dec_de

   dec de
   dec de
   dec de
   
l_dec_de:

   ret

; address = 0x0020

   defs 0x0020 - ASMPC

IF ((__crt_enable_rst & $1010) = $10)

   EXTERN _z80_rst_20h
   jp     _z80_rst_20h

ELSE

   IF ((__crt_enable_rst & $1010) = $1010)

   jp     __z80_rst_20h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $1010) != $1010)
   
   PUBLIC _z80_rst_20h_vector
   defc   _z80_rst_20h_vector = $21
      
ENDIF

   PUBLIC l_dec_bc

   dec bc
   dec bc
   dec bc
   
l_dec_bc:

   ret

; address = 0x0028

   defs 0x0028 - ASMPC

IF ((__crt_enable_rst & $2020) = $20)

   EXTERN _z80_rst_28h
   jp     _z80_rst_28h

ELSE

   IF ((__crt_enable_rst & $2020) = $2020)

   jp     __z80_rst_28h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $2020) != $2020)
   
   PUBLIC _z80_rst_28h_vector
   defc   _z80_rst_28h_vector = $29
      
ENDIF

   PUBLIC l_ret
   
   pop hl
   pop hl
   pop hl
   
l_ret:
   
   ret

; address = 0x0030

   defs 0x0030 - ASMPC

IF ((__crt_enable_rst & $4040) = $40)

   EXTERN _z80_rst_30h
   jp     _z80_rst_30h

ELSE

   IF ((__crt_enable_rst & $4040) = $4040)

   jp     __z80_rst_30h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $4040) != $4040)
   
   PUBLIC _z80_rst_30h_vector
   defc   _z80_rst_30h_vector = $31
      
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

IF ((__crt_enable_rst & $8080) = $80)

   EXTERN _z80_rst_38h
   jp     _z80_rst_38h

ELSE
IF ((__crt_enable_rst & $8080) = $8080)

   jp     __z80_rst_38h

ELSE

   push af
   in a,(0xbf)
   pop af
   ei
   ret

ENDIF
ENDIF

IF ((__crt_enable_rst & $8080) = $80)
   
   PUBLIC _z80_rst_38h_vector
   defc   _z80_rst_38h_vector = $39
      
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

IF (__crt_enable_nmi = 1)

   EXTERN _z80_nmi
   jp     _z80_nmi

ELSE

   IF (__crt_enable_nmi > 1)

   jp     __z80_nmi

   ELSE

   EXTERN l_retn
   jp     l_retn

   ENDIF

ENDIF

IF (__crt_enable_nmi <= 1)
   
   PUBLIC _z80_nmi_vector
   defc   _z80_nmi_vector = $67
      
ENDIF

defc __page_zero_present = 1
