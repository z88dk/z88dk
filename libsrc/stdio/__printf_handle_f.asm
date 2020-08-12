   MODULE   __printf_handle_f
   SECTION  code_clib
   PUBLIC   __printf_handle_f
   PUBLIC   __printf_handle_e

   EXTERN   fa
   EXTERN   l_jphl
   EXTERN   dldpsh
   EXTERN   __printf_get_buffer_address
   EXTERN   __printf_print_the_buffer
   EXTERN   ftoa
   EXTERN   ftoe
   EXTERN   strlen
   EXTERN   __convert_sdccf2reg
   EXTERN   CLIB_32BIT_FLOATS
   EXTERN   CLIB_64BIT_FLOATS

   EXTERN   __printf_issccz80
   EXTERN   __printf_get_precision
   EXTERN   __printf_set_buffer_length
   EXTERN   __printf_set_ftoe
   EXTERN   __printf_check_ftoe

__printf_handle_e:
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_set_ftoe
ELSE
    set   5,(ix-4)
ENDIF
__printf_handle_f:
    push    hl              ;save fmt
IF __CPU_INTEL__ | __CPU_GBZ80__
	call	__printf_issccz80
ELSE
    bit   0,(ix+6)
ENDIF
    jr nz,is_sccz80

    ex      de,hl           ;hl=where tp pick up from
    ld      e,(hl)          ;mantissa
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)
    inc     hl
    ld      b,(hl)     ;exponent
    inc     hl
    push    hl         ; save ap
    ld      h,b
    ld      l,a

IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push  ix    ;save callers
ENDIF
    ld      a,CLIB_32BIT_FLOATS
    and     a
    jr      z,sdcc_48bit_floats
    push    hl  ;padding
    push    hl  ;padding
    push    hl  ;MSW
    push    de  ;LSW
    jr      rejoin
sdcc_48bit_floats:
    call    __convert_sdccf2reg  
    push    hl ;padding (need to go to 8 byte format)
    push    hl ;the float
    push    de
    ld       hl,0
    push    hl
    jr      rejoin
    ; If we've got %f then lets assume we've got sccz80 rather than sdcc
is_sccz80:
    ld      a,CLIB_64BIT_FLOATS
    and     a
    jr      z,try_sccz80_32bit_float
    dec     de
    dec     de
    dec     de
    dec     de              ;long starts here
    dec     de
    dec     de
    dec     de
    dec     de
    push    de              ;save ap next
    inc     de
    inc     de

IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix              ;save ix - ftoa will corrupt it
ENDIF
    ld      hl,-8
    add     hl,sp
    ld      sp,hl
    ex      de,hl           ;hl=address of parameter, de=slot on stack
IF __CPU_INTEL__ || __CPU_GBZ80__
    ld      b,8
copy_float:
IF __CPU_GBZ80__
    ld      a,(hl+)
ELSE
    ld      a,(hl)
    inc     hl
ENDIF
    ld      (de),a
    inc     de
    dec     b
    jp  nz,copy_float
ELSE
    ld      bc,8
    ldir                    ;stack parameter
ENDIF
	jr	rejoin
try_sccz80_32bit_float:
    ld      a,CLIB_32BIT_FLOATS
    and     a
    jr      z,is_sccz80_48bit_float
    ex      de,hl
    ld      e,(hl)  ;MSW
    inc     hl
    ld      d,(hl)
    dec     hl
    dec     hl
    ld      b,(hl)  ;LSW
    dec     hl
    ld      c,(hl)
    dec     hl
    dec     hl
    push    hl      ;Save ap for next time
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix      ;save callers
ENDIF
    push    de      ;(padding, unused)
    push    de      ;(padding, unused)
    push    de      ;MSW
    push    bc      ;LSW
    jr      rejoin
is_sccz80_48bit_float:
    dec     de
    dec     de
    dec     de
    dec     de              ;long starts here
    dec     de
    dec     de
    push    de              ;save ap next
    inc     de
    inc     de

IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix              ;save ix - ftoa will corrupt it
ENDIF
    ld      hl,-8
    add     hl,sp
    ld      sp,hl
    ex      de,hl           ;hl=address of parameter, de=slot on stack
IF __CPU_INTEL__ || __CPU_GBZ80__
    ld      b,6
copy_float2:
  IF __CPU_GBZ80__
    ld      a,(hl+)
  ELSE
    ld      a,(hl)
    inc     hl
  ENDIF
    ld      (de),a
    inc     de
    dec     b
    jp      nz,copy_float2
ELSE
    ld      bc,6
    ldir                    ;stack parameter
ENDIF

rejoin:
IF __CPU_INTEL__ | __CPU_GBZ80__
    push    hl
    call    __printf_get_precision
    ld      c,l
    ld      b,h
    pop     hl
ELSE
    ld      c,(ix-8)
    ld      b,(ix-7)
ENDIF
    ld      a,b
    and     c
    inc     a
    jr      nz,set_prec
    ld      bc,6
set_prec:
    push    bc
    call    __printf_get_buffer_address
    push    hl
    ;ftoa(double number, int prec, char *buf)
    ld      hl,ftoa
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_check_ftoe
ELSE
    bit     5,(ix-4)
ENDIF
    jr      z,call_fp_converter
    ld      hl,ftoe
call_fp_converter:
    call    l_jphl
    pop     bc              ;the buffer
    pop     bc      ;prec
    pop     bc      ;flt
    pop     bc      ;flt
    pop     bc      ;flt
    pop     bc      ;flt
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    pop     ix              ;get ix back
ENDIF
    call    __printf_get_buffer_address
    call    strlen          ;get the length of it
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_set_buffer_length
ELSE
    ld      (ix-10),l
ENDIF
    jp      __printf_print_the_buffer
