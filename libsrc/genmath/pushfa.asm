;
;       Z88dk Generic Floating Point Math Library
;
;       Push FA onto the stack
;
;       $Id: pushfa.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:


		XLIB	pushfa

		XDEF	pushf2

		XREF	fa

.pushfa
	ex	de,hl
.pushf2
	ld	hl,(fa)
        ex      (sp),hl
        push    hl
        ld      hl,(fa+2)
        ex      (sp),hl
        push    hl
        ld      hl,(fa+4)
        ex      (sp),hl
        push    hl
        ex      de,hl
        ret


