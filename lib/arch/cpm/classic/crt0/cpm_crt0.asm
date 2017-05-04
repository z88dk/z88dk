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
;	#pragma output noredir   - do not insert the file redirection option while parsing the
;	                           command line arguments (useless if "nostreams" is set)
;	#pragma output nogfxglobals - No global variables for graphics (required for GFX on the TIKI-100 and Spectrum +3)
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

	EXTERN    _main		;main() is always external to crt0

	PUBLIC    cleanup		;jp'd to by exit()
	PUBLIC    l_dcal		;jp(hl)


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

IF (startup=2)
	;EXTERN ASMTAIL
		ld	hl,$100
		ld  de,32768
		ld  bc,$4000	; max. code size = 16K
		ldir
IF !DEFINED_noprotectmsdos
		jp  32768+14
ELSE
		jp  32768+14-start+begin
ENDIF
ENDIF

        call    crt0_init_bss   ;Initialise any data setup by sdcc
	ld      (start1+1),sp	;Save entry stack
IF (startup=3)
	ld      hl,-64-18-18	;Add on space for atexit() stack and +3 MEM banking
ELSE
	ld      hl,-64		;Add on space for atexit() stack
ENDIF
	add     hl,sp
	ld      sp,hl
	ld      (exitsp),sp

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
    INCLUDE "amalloc.def"
ENDIF

        ld	hl,$80
        ld      a,(hl)
        ld      b,0
        and     a
        jr      z,argv_done
        ld      c,a
        add     hl,bc   ;now points to the end of the command line


	INCLUDE	"crt0_command_line.asm"
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
IF !DEFINED_nostreams
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

        defm  	"Small C+ CP/M"

        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"

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
IF !DEFINED_nogfxglobals
		PUBLIC	RG0SAV
		PUBLIC	pixelbyte
RG0SAV:		defb	1*8		; VDP graphics driver (Einstein)
							; Also used to remember the border color for the ZX Spectrum +3 
							; in CP/M mode (Blue is default)
pixelbyte:	defb	0		; temp byte storage for VDP driver
ENDIF


	SECTION  rodata_clib
IF !DEFINED_noredir
IF !DEFINED_nostreams
redir_fopen_flag:		defb	'w',0
redir_fopen_flagr:		defb	'r',0
ENDIF
ENDIF

