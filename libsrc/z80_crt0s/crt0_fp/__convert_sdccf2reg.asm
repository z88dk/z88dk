;
; Convert an SDCC format float into the genmath/math48 format
;
; This format is used by most of the fp libraries so stick it in the crt0 - it
; can be overridden by libraries as necessary
;
; Keep in the same registers
;

		SECTION	code_clib
		PUBLIC	__convert_sdccf2reg


__convert_sdccf2reg:
	add	hl,hl	;shift right, sign into carry
	rr	l	;get sign into right place after shift
	inc	h	;fix exponent bias
	inc	h
        ; h = exponent
        ; l = sign + mantissa
        ; d, e = mantissa
	ret
