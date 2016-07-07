
	MODULE	__printf_doprint
	SECTION code_clib
	PUBLIC	__printf_doprint

; Print a character
; Entry: a = character to print
__printf_doprint:
        push    hl              ;save fmt
        push    de              ;save ap
        push    bc
        push    ix
        inc     (ix-2)          ;increment characters written
        jr      nz,no_inc
        inc     (ix-1)
no_inc:
        ld      c,a
        ld      b,0
        push    bc              ;character to print
        ld      c,(ix+10)       ;FP
        ld      b,(ix+11)
        push    bc
        ld      bc,doprint_return       ;where we are going to come back to
        push    bc
        ld      l,(ix+8)        ;output function (this is callee)
        ld      h,(ix+9)
        jp      (hl)
doprint_return:
        pop     ix              ;restore registers
        pop     bc
        pop     de
        pop     hl
        ret

