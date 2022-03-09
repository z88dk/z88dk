; address = 0x0000

   jp     __Start

; address = 0x0008

   ALIGN 0x0008

IF ((__crt_enable_rst & $0202) = $02)

   EXTERN _8085_rst_08h
   jp     _8085_rst_08h

ELSE

   IF ((__crt_enable_rst & $0202) = $0202)

   jp     __8085_rst_08h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $0202) != $0202)
   
   PUBLIC _8085_rst_08h_vector
   defc   _8085_rst_08h_vector = $09

ENDIF

   defm "Z88DK"

; address = 0x0010

   ALIGN 0x0010

IF ((__crt_enable_rst & $0404) = $04)

   EXTERN _8085_rst_10h
   jp     _8085_rst_10h

ELSE

   IF ((__crt_enable_rst & $0404) = $0404)

   jp     __8085_rst_10h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $0404) != $0404)

   PUBLIC _8085_rst_10h_vector
   defc   _8085_rst_10h_vector = $11

ENDIF

   defm "2.20"

; address = 0x0018

   ALIGN 0x0018

IF ((__crt_enable_rst & $0808) = $08)

   EXTERN _8085_rst_18h
   jp     _8085_rst_18h

ELSE

   IF ((__crt_enable_rst & $0808) = $0808)

   jp     __8085_rst_18h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $0808) != $0808)

   PUBLIC _8085_rst_18h_vector
   defc   _8085_rst_18h_vector = $19

ENDIF

; address = 0x0020

   ALIGN 0x0020

IF ((__crt_enable_rst & $1010) = $10)

   EXTERN _8085_rst_20h
   jp     _8085_rst_20h

ELSE

   IF ((__crt_enable_rst & $1010) = $1010)

   jp     __8085_rst_20h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $1010) != $1010)
   
   PUBLIC _8085_rst_20h_vector
   defc   _8085_rst_20h_vector = $21

ENDIF

; address = 0x0024

   ALIGN 0x0024

IF (__crt_enable_trap = 1)

   EXTERN _8085_trap
   jp     _8085_trap

ELSE

   IF (__crt_enable_trap > 1)

   jp     __8085_trap

   ELSE

   EXTERN l_ret
   jp     l_ret

   ENDIF

ENDIF

IF (__crt_enable_trap <= 1)
   
   PUBLIC _8085_trap_vector
   defc   _8085_trap_vector = $25

ENDIF

; address = 0x0028

   ALIGN 0x0028

IF ((__crt_enable_rst & $2020) = $20)

   EXTERN _8085_rst_28h
   jp     _8085_rst_28h

ELSE

   IF ((__crt_enable_rst & $2020) = $2020)

   jp     __8085_rst_28h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $2020) != $2020)
   
   PUBLIC _8085_rst_28h_vector
   defc   _8085_rst_28h_vector = $29
      
ENDIF

; address = 0x002C

   ALIGN 0x002C

IF (__crt_enable_int55 = 1)

   EXTERN _8085_int55
   jp     _8085_int55

ELSE

   IF (__crt_enable_int55 > 1)

   jp     __8085_int55

   ELSE

   EXTERN l_ei_ret
   jp     l_ei_ret

   ENDIF

ENDIF

IF (__crt_enable_int55 <= 1)
   
   PUBLIC _8085_int55_vector
   defc   _8085_int55_vector = $2D

ENDIF

; address = 0x0030

   ALIGN 0x0030

IF ((__crt_enable_rst & $4040) = $40)

   EXTERN _8085_rst_30h
   jp     _8085_rst_30h

ELSE

   IF ((__crt_enable_rst & $4040) = $4040)

   jp     __8085_rst_30h

   ELSE

   jp     l_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $4040) != $4040)
   
   PUBLIC _8085_rst_30h_vector
   defc   _8085_rst_30h_vector = $31
      
ENDIF

; address = 0x0034

   ALIGN 0x0034

IF (__crt_enable_int65 = 1)

   EXTERN _8085_int65
   jp     _8085_int65

ELSE

   IF (__crt_enable_int65 > 1)

   jp     __8085_int65

   ELSE

   EXTERN l_ei_ret
   jp     l_ei_ret

   ENDIF

ENDIF

IF (__crt_enable_int65 <= 1)
   
   PUBLIC _8085_int65_vector
   defc   _8085_int65_vector = $35

ENDIF

; address = 0x0038

   ALIGN 0x0038

IF ((__crt_enable_rst & $8080) = $80)

   EXTERN _8085_rst_38h
   jp     _8085_rst_38h

ELSE

   IF ((__crt_enable_rst & $8080) = $8080)

   jp     __8085_rst_38h

   ELSE

   EXTERN l_ei_ret
   jp     l_ei_ret

   ENDIF

ENDIF

IF ((__crt_enable_rst & $8080) != $8080)
   
   PUBLIC _8085_rst_38h_vector
   defc   _8085_rst_38h_vector = $39
      
ENDIF

; address = 0x003C

   ALIGN 0x003C

IF (__crt_enable_int75 = 1)

   EXTERN _8085_int75
   jp     _8085_int75

ELSE

   IF (__crt_enable_int75 > 1)

   jp     __8085_int75

   ELSE

   EXTERN l_ei_ret
   jp     l_ei_ret

   ENDIF

ENDIF

IF (__crt_enable_int75 <= 1)
   
   PUBLIC _8085_int75_vector
   defc   _8085_int75_vector = $3D

ENDIF


; address = 0x0040

   ALIGN 0x0040

IF (__crt_enable_rst40h = 1)

   EXTERN _8085_rst40h
   jp     _8085_rst40h

ELSE

   IF (__crt_enable_rst40h > 1)

   jp     __8085_rst40h

   ELSE

   EXTERN l_ei_ret
   jp     l_ei_ret

   ENDIF

ENDIF

IF (__crt_enable_rst40h <= 1)
   
   PUBLIC _8085_rst40h_vector
   defc   _8085_rst40h_vector = $41

ENDIF

   PUBLIC l_ret
   
   pop hl
   pop hl
   pop hl
   
.l_ret
   
   ret

   PUBLIC l_dec_de

   dec de
   dec de
   dec de
   
.l_dec_de

   ret

   PUBLIC l_dec_bc

   dec bc
   dec bc
   dec bc

.l_dec_bc

   ret

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

.l_setmem_hl

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

.l_inc_hl

   ret

IF (__crt_org_vector_table = -0x0080)

; place vector table at address 0x0080

; current address = 0x0069
; that is 23 bytes to pad, make it count!

PUBLIC error_mc

   pop hl
   pop hl
   pop hl

.error_mc

   ld hl,-1
   scf
   ret

PUBLIC error_zc

   pop hl
   pop hl
   pop hl
   pop hl

.error_zc

   ld hl,0
   scf
   ret

; address = 0x80

   ALIGN 0x0080

section code_crt_start

ELIF (__crt_org_vector_table = -0x0100)

; place vector table at address 0x0100

; current address = 0x0069
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

.l_inc_sp

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

.l_setmem_de

   ret

PUBLIC l_neg_hl

.l_neg_hl

   ld a,l
   cpl
   ld l,a

   ld a,h
   cpl
   ld h,a

   inc hl
   ret

PUBLIC l_neg_de

.l_neg_de

   ld a,e
   cpl 
   ld e,a

   ld a,d
   cpl
   ld d,a

   inc de
   ret

PUBLIC l_neg_bc

.l_neg_bc

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

.error_mc

   ld hl,-1
   scf
   ret

PUBLIC error_mnc

   pop hl
   pop hl
   pop hl

.error_mnc

   ld hl,-1
   scf
   ccf
   ret

PUBLIC error_zc

   pop hl
   pop hl
   pop hl
   pop hl

.error_zc

   ld hl,0
   scf
   ret

PUBLIC error_znc

   pop hl
   pop hl
   pop hl

.error_znc

   ld hl,0
   scf
   ccf
   ret

PUBLIC error_lzc

   pop hl

.error_lzc

   ld de,0
   jp error_zc

PUBLIC error_lznc

   pop hl

.error_lznc

   ld de,0
   jp error_znc

PUBLIC error_lmc

   pop hl

.error_lmc
   
   ld de,-1
   jp error_mc

PUBLIC error_lmnc

   pop hl

.error_lmnc

   ld de,-1
   jp error_mnc

PUBLIC error_oc

   pop hl

.error_oc

   ld hl,1
   scf
   ret

PUBLIC error_onc

   pop hl
   pop hl
   pop hl

.error_onc

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

.l_readword_hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

   ret

; address = 0x100

   ALIGN 0x0100

section code_crt_start

ELSE

; address = 0x080

   ALIGN 0x0080

section code_crt_init

ENDIF

defc __page_zero_present = 1
