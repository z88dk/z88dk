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

   ei
   reti

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

   PUBLIC l_inc_hl

   inc hl
   inc hl

   inc hl
   inc hl
   
   inc hl
   inc hl
   
   inc hl
   inc hl

l_inc_hl:

   ret

; address = 0x0066

   defs 0x0066 - ASMPC

IF __crt_enable_nmi

   EXTERN _z80_nmi
   jp _z80_nmi

ELSE

   retn

ENDIF

IF __crt_org_vector_table = -0x0080

; place vector table at address 0x0080

; current address = 0x0069 or 0x0068
; that is 23 bytes to pad, make it count!

PUBLIC error_mc

   pop hl
   pop hl
   pop hl

error_mc:
   
   ld hl,-1
   scf
   ret

PUBLIC error_zc

   pop hl
   pop hl
   pop hl
   pop hl

error_zc:
   
   ld hl,0
   scf
   ret

; address = 0x80

   defs 0x80 - ASMPC

section code_crt_start

ENDIF

IF (__crt_org_vector_table = -0x0100) || (__crt_org_vector_table = -1)

; place vector table at address 0x0100

; current address = 0x0069 or 0x0068
; that is 151 bytes to pad, make it count!

PUBLIC l_inc_sp
   
   inc sp
   inc sp
   
   inc sp
   inc sp
   
   inc sp
   inc sp
   
   inc sp
   inc sp

l_inc_sp:

   ret

PUBLIC l_setmem_de

   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de

   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de

l_setmem_de:

   ret

PUBLIC l_neg_hl

l_neg_hl:

   ld a,l
   cpl
   ld l,a
   
   ld a,h
   cpl
   ld h,a
   
   inc hl
   ret

PUBLIC l_neg_de

l_neg_de:

   ld a,e
   cpl 
   ld e,a
   
   ld a,d
   cpl
   ld d,a
   
   inc de
   ret

PUBLIC l_neg_bc

l_neg_bc:
   
   ld a,c
   cpl
   ld c,a
   
   ld a,b
   cpl
   ld b,a
   
   inc bc
   ret

PUBLIC error_mc

   pop hl
   pop hl
   pop hl

error_mc:
   
   ld hl,-1
   scf
   ret

PUBLIC error_mnc

   pop hl
   pop hl
   pop hl

error_mnc:
   
   ld hl,-1
   
   scf
   ccf
   
   ret

PUBLIC error_zc

   pop hl
   pop hl
   pop hl
   pop hl

error_zc:
   
   ld hl,0
   scf
   ret

PUBLIC error_znc

   pop hl
   pop hl
   pop hl
   
error_znc:
   
   ld hl,0
   
   scf
   ccf
   
   ret

PUBLIC error_lzc

   pop hl

error_lzc:
   
   ld de,0
   jp error_zc

PUBLIC error_lznc

   pop hl

error_lznc:
   
   ld de,0
   jp error_znc

PUBLIC error_lmc

   pop hl

error_lmc:
   
   ld de,-1
   jp error_mc

PUBLIC error_lmnc

   pop hl

error_lmnc:
   
   ld de,-1
   jp error_mnc

PUBLIC error_oc

   pop hl

error_oc:
   
   ld hl,1
   scf
   
   ret

PUBLIC error_onc

   pop hl
   pop hl
   pop hl

error_onc:
   
   ld hl,1
   
   scf
   ccf
   
   ret

PUBLIC l_readword_hl

   inc hl
   inc hl

   inc hl
   inc hl

   inc hl
   inc hl
   
   inc hl
   inc hl

l_readword_hl:
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ret

PUBLIC l_offset_ix_de

l_offset_ix_de:

   push ix
   pop de
   
   add hl,de
   ret

PUBLIC l_offset_ix_bc

l_offset_ix_bc:

   push ix
   pop bc
   
   add hl,bc
   ret

; address = 0x100

   defs 0x100 - ASMPC

section code_crt_start

ENDIF

defc __page_zero_present = 1
