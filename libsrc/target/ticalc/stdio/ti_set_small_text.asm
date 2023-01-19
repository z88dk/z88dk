;
;	TI calc Routines
;
;	ti_set_small_text(unsigned char toggle) __FASTCALL__ Turn small text mode on or off
;
;	Empathic Qubit - Jan 2023
;
            SECTION code_clib
		PUBLIC	_ti_set_small_text
		PUBLIC	ti_set_small_text
		EXTERN	ti_usesmalltext

._ti_set_small_text
.ti_set_small_text
    ld a,l
    ld (ti_usesmalltext),a
    ret
