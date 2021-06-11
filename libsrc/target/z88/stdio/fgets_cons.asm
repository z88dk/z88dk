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
;	$Id: fgets_cons.asm,v 1.9 2016-07-02 13:52:45 dom Exp $
;

                INCLUDE "stdio.def"
                INCLUDE	"syspar.def"

		MODULE fgets_cons_z88
		SECTION	  code_clib

                PUBLIC    fgets_cons
                PUBLIC    _fgets_cons
                EXTERN    processcmd

;
; Read a string from the console
;
.fgets_cons
._fgets_cons
	xor	a
	ld	bc,nq_wcur
	call_oz(os_nq)		;gives x in c, y in b, preserves ix
	push	bc		;keep it
        ld      hl,4
        add     hl,sp
        ld      b,(hl)		;gn_sip needs length in b, maxes out at 255
        inc     hl
	ld	a,b
	or	(hl)		;high byte of to read
        jr      z,fgets_abort   ;length is zero
        inc     hl              ;step up to buffer
        ld      e,(hl)          ;buffer
        inc     hl
        ld      d,(hl)
        ld      c,0             ;cursor position
        ld      a,0             ;allow return of ctrl chars
	dec	b		;decrement count so we can put in a \n
.loopyloo
        push    de              ;preserve buffer
        call_oz(gn_sip)		;preserves ix
        pop     hl
        cp      $80
        call	nc,fgets_gotcmd ; trapped a cmd, and should restart
	cp	1
	jr	z,fgets_abort
	cp	13
	jr	z,fgets_stripeol
	jr	fgets_unknown

.fgets_gotcmd
	push	hl
	push	bc
        call    processcmd	;TODO: shouldn't this restart?
	pop	bc
	pop	hl
	ret

.fgets_abort
	ld	(hl),0
	ld	hl,0
.fgets_out
	pop	bc	;xy posn
	ret

.fgets_stripeol
	cp	1		;escape
	jr	z,fgets_abort
        cp      13              ;terminating char
	jr	nz,fgets_unknown	;exit (NULL set by gn_sip)
; We now have to insert a \n into the line
	push	hl		;save hl
	ld	c,b
	ld	b,0
	add	hl,bc		;points to one beyond terminating NULL
	ld	(hl),0		;terminating null
	dec	hl
IF STANDARDESCAPECHARS
	ld	(hl),10		;put in the \n
ELSE
	ld	(hl),13		;put in the \n
ENDIF
	pop	hl		;get start of string back
	jr	fgets_out

.fgets_unknown
; Okay, unexpected thing, so go back in
; We've got ATP: hl=buffer
;		  b=line length (inputted)
;		  c=cursor position
	pop	de	;xy posn
	ld	a,1
	call_oz(os_out)
	ld	a,'3'
	call_oz(os_out)
	ld	a,'@'
	call_oz(os_out)
	ld	a,e
	add	a,32
	call_oz(os_out)		;preserves ix
	ld	a,d
	add	a,32
	call_oz(os_out)
	push	de	;keep xy posn on the stack once more
	ex	de,hl	;de=buffer now
	ld	hl,4	;We have xy on the stack
	add	hl,sp
	ld	b,(hl)	;max length of buffer
	ld	a,0 | 1	;return ctrl + buffer got data
	jr	loopyloo
