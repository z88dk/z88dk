;       Startup Code for Xircom Rex 6000
;
;	djm 6/3/2001
;
;       $Id: rex_crt0.asm,v 1.10 2001-09-04 13:53:48 dom Exp $
;

	MODULE rex_crt0

	INCLUDE "zcc_opt.def"

; Main is always external
	XREF	_main

; Variables in this file that other modules need

	XDEF	l_erraddr
	XDEF	l_errlevel
	XDEF	int_seed
	XDEF	exitsp
	XDEF	exitcount
	XDEF	heapblocks
	XDEF	heaplast
	XDEF	l_dcal
	XDEF	far_ret
	XDEF	far_ret_p
	XDEF	far_ret_sp
	XDEF	far_par1
	XDEF	far_par2


;	defm	"ApplicationName:Addin"&10&13
;	defm	"[program name - 10 chars?]"&10&13
;	defb	0
;	defw	endprof-begprog
;	defb	0,0
; Prior to $8000 we have a 40x32 icon
        org    $8000

	jp	start
.start
; Make room for the atexit() stack
	ld	hl,65535-64
	ld	sp,hl
; Clear static memory
	ld	hl,$f033
	ld	de,$f034
	ld	bc,$ffff-$f033
	ld	(hl),0
	ldir
        ld      (exitsp),sp

        ld      hl,$8080
        ld      (fp_seed),hl
        xor     a
        ld      (exitcount),a
; Entry to the user code
        call    _main
.cleanup
; Should call application exit here
	ld	de,$42	;DS_ADDIN_TERMINATE
	ld	($c000),de
	rst	$10

.endloop
	jr	endloop
.l_dcal
        jp      (hl)

; Static variables kept in safe workspace

DEFVARS $f033
{
l_erraddr
        ds.w    1
l_errlevel
        ds.w    1
int_seed
        ds.w    1
exitsp
        ds.w    1
exitcount
        ds.b    1
fp_seed
        ds.w    3       ;not used ATM
extra
        ds.w    3
fa
        ds.w    3
fasign
        ds.b    1
heapblocks
	ds.w	1
heaplast
	ds.w	1
far_ret
	ds.w	1
far_ret_p
	ds.b	1
far_ret_sp
	ds.w	1
far_par1
	ds.w	1
far_par2
	ds.w	1
}

;
; Now, include the math routines if needed..
;

IF NEED_floatpack
        INCLUDE "#float.asm"
ENDIF
