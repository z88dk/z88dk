;
;       Amstrad CPC library
;       creates a copy of a string in CPC format
;
;       char __LIB__ __FASTCALL__ *cpc_rsx_str(char *str)
;
;       $Id: cpc_rsx_str.asm,v 1.3 2016-06-10 21:12:36 dom Exp $
;

        SECTION   code_clib
        PUBLIC    cpc_rsx_str
        PUBLIC    _cpc_rsx_str
        EXTERN	strlen
        EXTERN	malloc

.cpc_rsx_str
._cpc_rsx_str

        push	hl	; str ptr
        call	strlen
        push	hl	; str len
        
        inc	hl
        inc	hl
        inc	hl
        call	malloc	; malloc (strlen + 3)
        
        pop	bc	; str len
        pop	de	; str ptr
        push	hl	; cpc_rsx_str
        push	de	; str ptr
        
        ld	a,c
        ld	(hl),a	; cpc_rsx_str begins with 1 byte for string length
        inc	hl
        ld	d,h
        ld	e,l
        inc	de
        inc	de	; DE now points to cpc_rsx_str+3
        ld	(hl),e	; string location (cpc_rsx_str+1)
        inc	hl
        ld	(hl),d
        
        pop	hl	; str ptr
        
        ldir		; copy string

        pop	hl	; cpc_rsx_str
        ret
