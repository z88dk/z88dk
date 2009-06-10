;       Startup Code for Xircom Rex 6000
;
;	djm 6/3/2001
;
;       $Id: rxl_crt0.asm,v 1.4 2009-06-10 17:26:05 stefano Exp $
;

	MODULE rex_crt0

	INCLUDE "zcc_opt.def"

;--------
; Some scope declarations
;--------

	XREF	_main		;main() is always external to crt0
	XREF	_LibMain

	XDEF	_std_seed	;integer rand() seed
	XDEF	exitsp		;atexit() variables
	XDEF	exitcount
	XDEF	heapblocks	;malloc() variables
	XDEF	heaplast
	XDEF	l_dcal		;jp(hl) instruction
	XDEF	cleanup



;	defm	"ApplicationName:Addin"&10&13
;	defm	"[program name - 10 chars?]"&10&13
;	defb	0
;	defw	endprof-begprog
;	defb	0,0
; Prior to $8000 we have a 40x32 icon

;--------
; Main code starts here
;--------
        org    $8000

	jp	start		;addin signature jump
signature:
	defm	"XXX"
lib:
	ld	hl,farret
	push	hl
	jp	_LibMain
start:
; Make room for the atexit() stack
	ld	hl,65535-64	;Initialise sp
	ld	sp,hl
	ld	hl,$f033	;Clear static memory
	ld	de,$f034
	ld	bc,$ffff-$f033
	ld	(hl),0
	ldir
        ld      (exitsp),sp	;Store atexit() stack
        xor     a
        ld      (exitcount),a	;Setup number of atexit() routines

        ld      hl,$8080	;Initialise fp seed
        ld      (fp_seed),hl
; Entry to the user code
        call    _main		;Call the users code
cleanup:
	ld	de,$42	;DS_ADDIN_TERMINATE
	ld	($c000),de
	rst	$10		;Exit the addin
endloop:
	jr	endloop
l_dcal:	jp	(hl)		;Used for call by function pointer
farret:				;Used for farcall logic
	pop	bc
	ld	a,c
	jp	$26ea

;--------
; Static variables are kept in RAM in high memory
;--------

DEFVARS $f033
{
_std_seed	ds.w	1	;Integer seed
exitsp		ds.w	1	;Pointer to atexit() stack
exitcount	ds.b	1	;Number of atexit() routines registered
fp_seed		ds.w	3	;Floating point seed, unused ATM
extra		ds.w	3	;Floating point temp variable
fa		ds.w	3	;Floating point accumulator
fasign		ds.b	1	;Floating point temp store
heapblocks	ds.w	1	;Number of malloc blocks
heaplast	ds.w	1	;Pointer to linked list of free malloc blocks
}

;--------
; Now, include the math routines if needed..
;--------

IF NEED_floatpack
        INCLUDE "#float.asm"
ENDIF
