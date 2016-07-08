
	MODULE	get_16bit_ap_parameter
	SECTION	code_clib
	PUBLIC	get_16bit_ap_parameter


; Change the arguments pointer, the delta is always 2, but is it +/-ve?
; Entry: de = ap
; Return: de = new ap
;         hl = value
; Uses:  ix
get_16bit_ap_parameter:
        ex      de,hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ex      de,hl           ;de=ap+1 hl=to print
        bit     0,(ix+6)        ;sccz80 flag
        jr      nz,change_ap_decrement
        inc     de
        ret
change_ap_decrement:
        dec     de
        dec     de
        dec     de
        ret
