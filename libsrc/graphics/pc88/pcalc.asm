; NEC PC8001 graphics library, by @Stosstruppe
; Adapted to z88dk by Stefano Bodrato, 2018

	SECTION code_clib
	PUBLIC	pcalc

	EXTERN	base_graphics


;
;	$Id: pcalc.asm $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; ******************************************************************
;
;
;
.pcalc
; point calc
; in : b=y c=x
; out: hl=addr a=bits
		
		push bc
		
		ld	b,l	; y
		ld	c,h	; x

        ld      a, b            ; de = y & $fc
        and     $fc
        ld      e, a
        ld      d, 0

        ld      h, d            ; hl = de * 30
        ld      l, e
        add     hl, hl
        add     hl, de
        add     hl, hl
        add     hl, de
        add     hl, hl
        add     hl, de
        add     hl, hl          ; %11110 = 30?

        ld      e, c            ; hl += x / 2
        srl     e
        add     hl, de
        ld      de, $f3c8		; TVRAM, text video memory
        add     hl, de
        push    hl

        ld      a, c
        and     $01
        add     a, a
        add     a, a
        ld      e, a
        ld      a, b
        and     $03
        or      e
        ld      e, a
        ld      d, 0
        ld      hl, PCALC_DATA
        add     hl, de
        ld      a, (hl)
        pop     hl
		
		;ld d,h
		;ld e,l
		pop bc

				;and	@00000111
				;xor	@00000111
				
				ret


SECTION rodata_clib
PCALC_DATA:  defb    $01,$02,$04,$08,$10,$20,$40,$80
