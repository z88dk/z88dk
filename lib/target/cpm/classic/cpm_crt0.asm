;
;       Startup for CP/M
;
;       Stefano Bodrato - Apr. 2000
;                         Apr. 2001: Added MS-DOS protection
;
;	Dominic Morris  - Jan. 2001: Added argc/argv support
;			- Jan. 2001: Added in malloc routines
;			- Jan. 2001: File support added
;
;       $Id: cpm_crt0.asm,v 1.43 2016-10-31 16:16:33 stefano Exp $
;
; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma output nostreams - No stdio disc files
;	#pragma output nofileio  - No fileio at all, use in conjunction to "-lndos"
;	#pragma output noprotectmsdos - strip the MS-DOS protection header
;	#pragma output protect8080 - add a check to block the program when on an 8080 CPU (not compatible)
;	#pragma output noredir   - do not insert the file redirection option while parsing the
;	                           command line arguments (useless if "nostreams" is set)
;	#pragma output nogfxglobals - No global variables for graphics (required for GFX on TIKI-100, Einstein, and Spectrum +3)
;
;	These can cut down the size of the resultant executable

	MODULE  cpm_crt0

;-------------------------------------------------
; Include zcc_opt.def to find out some information
;-------------------------------------------------

        defc    crt0 = 1
	INCLUDE "zcc_opt.def"

;-----------------------
; Some scope definitions
;-----------------------

	EXTERN	cpm_platform_init
	EXTERN    _main		;main() is always external to crt0

	PUBLIC    cleanup		;jp'd to by exit()
	PUBLIC    l_dcal		;jp(hl)

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"

IF (startup=2)
        org     32768
ELSE
        org     $100
ENDIF

;----------------------
; Execution starts here
;----------------------
start:
IF !DEFINED_noprotectmsdos
	defb	$eb,$04		;DOS protection... JMPS LABE
	ex	de,hl
	jp	begin-start+$100
	defb	$b4,$09		;DOS protection... MOV AH,9
	defb	$ba
	defw	dosmessage	;DOS protection... MOV DX,OFFSET dosmessage
	defb	$cd,$21		;DOS protection... INT 21h.
	defb	$cd,$20		;DOS protection... INT 20h.

dosmessage:
	defm	"This program is for a CP/M system."
	defb	13,10,'$'

begin:
ENDIF

IF DEFINED_protect8080

	ld	a,$7F			; 01111111 into accumulator
	inc	a			; make it overflow ie. 10000000
	jp	pe,isz80	; only 8080 resets for odd parity here

	ld	c,9		; print string
	ld	de,err8080
	call	5	; BDOS
	jp	0
	
err8080:
	defm	"This program requires a Z80 CPU."
	defb	13,10,'$'
isz80:
ENDIF

IF (startup=2)
	;EXTERN ASMTAIL
		ld	hl,$100
		ld  de,32768
		ld  bc,$4000-$100	; max. code size is about 16K
		ldir
IF !DEFINED_noprotectmsdos
		jp  32768+14
ELSE
		jp  32768+14-start+begin
ENDIF
ENDIF

	nop	 ;   Those extra bytes fix the Amstrad NC's ZCN support !!?!
	nop

        ld	hl,0
	add	hl,sp
	ld      (start1+1),hl	;Save entry stack
IF (startup=3)
	; Increase to cover +3 MEM banking
	defc	__clib_exit_stack_size_t  = __clib_exit_stack_size + 18 + 18
	UNDEFINE __clib_exit_stack_size
	defc	__clib_exit_stack_size = __clib_exit_stack_size_t
ENDIF
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
        call    crt0_init_bss   
	call	cpm_platform_init	;Any platform specific init
	ld	hl,0
	add	hl,sp
	ld      (exitsp),hl

; Memory banking for Spectrum +3
IF (startup=3)
	PUBLIC    p3_poke
	PUBLIC    p3_peek
	
	push hl
	ld de,64
	add hl,de
	ld (p3_poke+1),hl
	push hl
	ld de,18
	add hl,de
	ld (p3_peek+1),hl
	pop hl
	ld d,h
	ld e,l
	ld hl,pokebyte_code
	ld bc,18+18
	ldir
	pop hl
ENDIF

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

        ld	hl,$80
        ld      a,(hl)
        ld      b,0
        and     a
        jr      z,argv_done
        ld      c,a
        add     hl,bc   ;now points to the end of the command line


	INCLUDE	"crt/classic/crt_command_line.asm"
	push	hl	;argv
	push	bc	;argc
        call    _main		;Call user code
	pop	bc	;kill argv
	pop	bc	;kill argc

	ld	a,(defltdsk)	;Restore default disc
	ld	e,a
	ld	c,14
	call	5

cleanup:
	push	hl		;Save return value
IF CRT_ENABLE_STDIO = 1
	EXTERN	closeall	;Close any opened files
	call	closeall
ENDIF
	pop	bc		;Get exit() value into bc
start1:	ld      sp,0		;Pick up entry sp
        jp	0
		;ret

l_dcal:	jp	(hl)		;Used for call by function ptr

; Memory banking for Spectrum +3
IF (startup=3)
		PUBLIC	pixelbyte
pixelbyte:	defb	0		; temp byte storage for VDP driver

p3_poke:
		jp 0

p3_peek:
		jp 0

pokebyte_code:
		di
		; ..$15 00010101 -> banks 4,5,6,3
		; ..$11 00010001 -> banks 0,1,2,3 (TPA)
		ex  af,af
		ld	a,$15
		;ld	a,$0D
		;ld	a,$05
		ld bc,$1ffd
		out(c),a
		ex af,af
		ld (hl),a
		ld	a,$11		; avoid using ($FF01) to be compatible with CP/M 2.2 
		;ld	a,$09
		;ld	a,$01
		;ld	a,($FF01)	; saved value
		out(c),a
		ei
		ret
		; adjust code size
		nop
peekbyte_code:
		di
		; ..$15 00010101 -> banks 4,5,6,3
		; ..$11 00010001 -> banks 0,1,2,3 (TPA)
		ld	a,$15
		;ld	a,$0D
		;ld	a,$05
		ld bc,$1ffd
		out(c),a
		ld a,(hl)
		ex  af,af
		ld	a,$11		; avoid using ($FF01) to be compatible with CP/M 2.2 
		;ld	a,$09
		;ld	a,$01
		;ld	a,($FF01)	; saved value
		out(c),a
		ex  af,af
		ei
		ret
		; adjust code size
		nop
ENDIF


        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE	"crt/classic/crt_section.asm"


	SECTION code_crt_init
	ld	c,25
	call	5
	ld	(defltdsk),a

	
	SECTION bss_crt

;-----------------------
; Some startup variables
;-----------------------
		PUBLIC	defltdsk
defltdsk:       defb    0	;Default disc

IF !DEFINED_nofileio
		PUBLIC	__fcb
__fcb:		defs	420,0	;file control block (10 files) (MAXFILE)
ENDIF


;-----------------------------------------------------
; Unneccessary file signature + target specific stuff
;-----------------------------------------------------
		PUBLIC	_vdcDispMem
_vdcDispMem:				; Label used by "c128cpm.lib" only
end:		defb	0		; null file name


	SECTION  rodata_clib
IF !DEFINED_noredir
IF CRT_ENABLE_STDIO = 1
redir_fopen_flag:		defb	'w',0
redir_fopen_flagr:		defb	'r',0
ENDIF
ENDIF

