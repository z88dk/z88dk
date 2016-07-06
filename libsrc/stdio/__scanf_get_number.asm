

        MODULE  __scanf_get_number
        SECTION code_clib
        PUBLIC	__scanf_get_number

        EXTERN  scanf_exit
        EXTERN  __scanf_ungetchar
        EXTERN  __scanf_getchar

	EXTERN	l_long_neg
	EXTERN	l_long_mult
        EXTERN  asm_toupper

; hl = fmt
; de = destination
;  b = radix
__scanf_get_number:
        push    hl              ;save fmt
        push    de              ;save destination
        call    scanf_atoul
        and     a               ;clear carry
        bit     3,(ix-3)        ;assignment suppressed?
        jr      nz,scanf_getnumber_suppressed
        ex      de,hl           ;long is hlde (i.e. reversed)
        ex      (sp),hl         ;*sp =top16, hl=destination
        ld      (hl),e
        inc     hl
        ld      (hl),d
        pop     de              ;de= most sig word of long

        bit     1,(ix-3)
        jr      z,scanf_getnumber_notlong
        inc     hl
        ld      (hl),e
        inc     hl
        ld      (hl),d
scanf_getnumber_notlong:
        pop     hl              ;fmt
        inc     (ix-1)          ;number of conversions done
        ret
scanf_getnumber_suppressed:
        pop     hl              ;rubbish
        pop     hl              ;fmt
        ret

scanf_atoul:
        ld      de,0            ;dehl = result = 0
        ld      l,e
        ld      h,d

scanf_atoul_loop:
        call    __scanf_getchar
        jr      c,scanf_atoul_exit2
        ld      c,a
        sub     '0'
        jr      c,scanf_atoul_exit
        cp      10
        jr      c,scanf_atoul_isdigit
        ld      a,c
        call    asm_toupper
        sub     'A'
        jr      c,scanf_atoul_exit
        add     10
scanf_atoul_isdigit:
        cp      b               ;no good if digit exceeds radix
        jr      nc,scanf_atoul_exit
        ld      c,a
        push    bc              ;save digit and radix
        push    de              ; result on stack
        push    hl
        ld      de,0            ; arg2 = radix
        ld      h,d
        ld      l,b             ; radix
        call    l_long_mult     ; dehl = result * radix
        pop     bc              ; b = radix, c = digit
        ld      a,c             ; and add on our digit
        add     l
        ld      l,a
        jr      nc,scanf_atoul_loop
        inc     h
        jr      nz,scanf_atoul_loop
        inc     de
        jr      scanf_atoul_loop
scanf_atoul_exit:
        ld      a,c
        call    __scanf_ungetchar
scanf_atoul_exit2:
        bit     0,(ix-3)        ;sign flag
        call    nz,l_long_neg
        ret
	
