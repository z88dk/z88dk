
; TODO: Rewrite this for 8080
IF !__CPU_8080__
   MODULE   __printf_handle_f
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

__printf_handle_e:
        set   5,(ix-4)
__printf_handle_f:
        push    hl              ;save fmt
        bit   0,(ix+6)
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
        push    hl              ; save ap
        ld      h,b
        ld      l,a

        push  ix    ;save callers
        ld      a,CLIB_32BIT_FLOATS
        and     a
	jr	z,sdcc_48bit_floats
	push	hl	;padding
	push	hl	;padding
	push	hl	;MSW
	push	de	;LSW
	jr	rejoin
sdcc_48bit_floats:
        call  __convert_sdccf2reg  
	push  hl ;padding (need to go to 8 byte format)
        push  hl ;the float
        push  de
        ld    hl,0
        push  hl
        jr rejoin
; If we've got %f then lets assume we've got sccz80 rather than sdcc
is_sccz80:
	ld	a,CLIB_64BIT_FLOATS
	and	a
	jr	z,try_sccz80_32bit_float
        dec     de
        dec     de
        dec     de
        dec     de              ;long starts here
        dec     de
        dec     de
	dec	de
	dec	de
        push    de              ;save ap next
        inc     de
        inc     de

        push    ix              ;save ix - ftoa will corrupt it
        ld      hl,-8
        add     hl,sp
        ld      sp,hl
        ex      de,hl           ;hl=address of parameter, de=slot on stack
        ld      bc,8
        ldir                    ;stack parameter
	jr	rejoin
try_sccz80_32bit_float:
        ld      a,CLIB_32BIT_FLOATS
        and     a
        jr      z,is_sccz80_48bit_float
        ex      de,hl
        ld      e,(hl)          ;MSW
        inc     hl
        ld      d,(hl)
        dec     hl
        dec     hl
        ld      b,(hl)          ;LSW
        dec     hl
        ld      c,(hl)
        dec     hl
        dec     hl
        push    hl              ;Save ap for next time
        push    ix    ;save callers
        push    de		;(padding, unused)
        push    de		;(padding, unused)
        push    de		;MSW
        push    bc		;LSW
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

        push    ix              ;save ix - ftoa will corrupt it
        ld      hl,-8
        add     hl,sp
        ld      sp,hl
        ex      de,hl           ;hl=address of parameter, de=slot on stack
        ld      bc,6
        ldir                    ;stack parameter

rejoin:
        ld      c,(ix-8)
        ld      b,(ix-7)
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
        bit     5,(ix-4)
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
        pop     ix              ;get ix back
        call    __printf_get_buffer_address
        call    strlen          ;get the length of it
        ld      (ix-10),l
        jp      __printf_print_the_buffer
ENDIF
