        
	SECTION	code_crt0_sccz80
        PUBLIC	dldpsh
	PUBLIC	dpush
	EXTERN	fa


;-----------------------------------------
; Load FA from (hl) and push FA onto stack
;-----------------------------------------
dldpsh: ld      de,fa
        ld      bc,6
        ldir
;------------------------------------------
; Push FA onto stack (under return address)
;------------------------------------------
dpush:  pop     de
        ld      hl,(fa+4)
        push    hl
        ld      hl,(fa+2)
        push    hl
        ld      hl,(fa)
        push    hl
        ex      de,hl
        jp      (hl)
