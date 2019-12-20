;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; 11/3/99 Revised to allow input from stdin
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
; Is this better now garry?!?! djm 1/4/2000
;
; Now goes back to the correct print position
;
;
;	$Id: gets.asm,v 1.7 2016-07-02 13:52:45 dom Exp $
;

                INCLUDE "stdio.def"
                INCLUDE	"syspar.def"

		MODULE   gets_z88
		SECTION   code_clib

                PUBLIC    gets
                PUBLIC    _gets
                EXTERN    processcmd

;
; Read a string from the console - this is limited to 255 characters
;
.gets
._gets
	xor	a
	ld	bc,nq_wcur
	call_oz(os_nq)		;gives x in c, y in b, preserves ix
	push	bc		;keep it
        ld      hl,4
        add     hl,sp
        ld      e,(hl)          ;buffer
        inc     hl
        ld      d,(hl)
        ld      c,0             ;cursor position
        ld      a,8             ;allow return of ctrl chars
	ld	b,255		;max length we can read
.loopyloo
        push    de              ;preserve buffer
        call_oz(gn_sip)		;preserves ix
        pop     hl
        push    af
        cp      $80
        jr      nc,gets_gotcmd ; trapped a cmd
        pop     af
        jr      nc,gets_stripeol
        jr      gets_abort     ; return hl=0 - error

.gets_gotcmd
        pop     af
        call    processcmd
.gets_abort
	ld	hl,0
.gets_out
	pop	bc	;xy posn
	ret

.gets_stripeol
	cp	1		;escape
	jr	z,gets_abort
        cp      13              ;terminating char
	jr	z,gets_out	;exit (NULL set by gn_sip)
; Okay, unexpected thing, so go back in
; We've got ATP: hl=buffer
;		  b=line length (inputted)
;		  c=cursor position
	pop	de	;xy posn
	push	hl	;preserve stuff
	push	bc
	ld	hl,xystr
	call_oz(gn_sop)		;preserves ix
	ld	a,e
	add	a,32
	call_oz(os_out)		;preserves ix
	ld	a,d
	add	a,32
	call_oz(os_out)		;preserves ix
	pop	bc
	pop	hl
	push	de	;keep xy posn on the stack once more
	ex	de,hl	;de=buffer now
	ld	hl,4	;cos we now have xy posn on stack
	add	hl,sp
	ld	b,(hl)	;max length of buffer
	ld	a,8 | 1	;return ctrl + buffer got data
	jr	loopyloo

	SECTION	rodata_clib
.xystr
	defb	1,'3','@',0
