;       MSX C stub
;
;       Stefano Bodrato - Apr. 2001
;
;	$Id: msx_crt0.asm,v 1.49 2016-07-15 21:38:08 dom Exp $
;

; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma output nostreams      - No stdio disc files
;	#pragma output nofileio       - No fileio at all, use in conjunction to "-lndos"
;	#pragma output noprotectmsdos - strip the MS-DOS protection header
;	#pragma output noredir        - do not insert the file redirection option while parsing the
;	                                command line arguments (useless if "nostreams" is set)
;
;	These can cut down the size of the resultant executable

                MODULE  msx_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

		defc    crt0 = 1
                INCLUDE "zcc_opt.def"


	EXTERN    _main

        PUBLIC    cleanup
        PUBLIC    l_dcal
        PUBLIC    msxbios
;===============================================================================
IF startup != 3
;===============================================================================


;--------
; Some scope definitions
;--------



; MSX platform specific stuff
;


; Now, getting to the real stuff now!

IF (!DEFINED_startup || (startup=1))
        IFNDEF CRT_ORG_CODE
                defc CRT_ORG_CODE  = 40000
        ENDIF
ELSE
        IFNDEF CRT_ORG_CODE
                defc CRT_ORG_CODE = $100   ; MSXDOS
        ENDIF
ENDIF

org CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:

IF (startup=2)
IF !DEFINED_noprotectmsdos
	; This protection takes little less than 50 bytes
	defb	$eb,$04		;MS DOS protection... JMPS to MS-DOS message if Intel
	ex	de,hl
	jp	begin		;First decent instruction for Z80, it survived up to here !
	defb	$b4,$09		;DOS protection... MOV AH,9 (Err msg for MS-DOS)
	defb	$ba
	defw	dosmessage	;DOS protection... MOV DX,OFFSET dosmessage
	defb	$cd,$21		;DOS protection... INT 21h.
	defb	$cd,$20		;DOS protection... INT 20h.

dosmessage:
	defm	"This program is for MSXDOS."
	defb	13,10,'$'

begin:
ENDIF
ENDIF

        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

; ** IF MSXDOS mode, handle argv, argc... **
IF (startup=2)
	;ld	c,25		;Save the default disc
	;call	5
	ld	a,($F306)
	ld	(defltdsk),a

	ld	hl,$80
        ld      a,(hl)
        ld      b,0
        and     a
        jr      z,argv_done
        ld      c,a
        add     hl,bc   ;now points to the end of the command line
	INCLUDE	"crt0_command_line.asm"

        push    hl      ;argv
        push    bc      ;argc
        call    _main		;Call user code
	pop	bc	;kill argv
	pop	bc	;kill argc

	ld	a,(defltdsk)	;Restore default disc
	ld	($F306),a
	;ld	e,a
	;ld	c,14
	;call	5
ELSE
;** If NOT MSXDOS mode, just get rid of BASIC screen behaviour **
	ld	ix,$CC	; Hide function key strings
	call	msxbios
        call    _main
ENDIF
	ld	ix,$d2	; TOTEXT - force text mode on exit
	call	msxbios
;**
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

start1:
        ld      sp,0
        ret

l_dcal:
        jp      (hl)





;===============================================================================
ELSE
;===============================================================================

; startup == 3
; msx cartridge rom

; April 2014
; submitted by Timmy

; For cartridge I am not sure what facilities are available from the MSX
; system, if any.  So this CRT only provides the bare minimum.

;
;  Declarations
;

	EXTERN _main		; main() entrance point
	PUBLIC	l_dcal	; jp(hl) instruction
	PUBLIC cleanup

;
;  Main Code Entrance Point
;
IFNDEF CRT_ORG_CODE
	defc  CRT_ORG_CODE  = $4000
ENDIF
	org   CRT_ORG_CODE

; ROM header

	defb $41,$42,$10,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	jp start

	defm  "wai's msx rom"

start:
	di
	ld sp, ($FC4A)
	ei

	call	crt0_init_bss

; port fixing; required for ROMs

	in a,($A8)
	and a, $CF
	ld d,a
	in a,($A8)
	and a, $0C
	add a,a
	add a,a
	or d
	out ($A8),a

        
IF (HEAPSIZE > 4)
        
        ld hl,_heap_area
        ld bc,HEAPSIZE
        ld de,_heap
        
        EXTERN HeapSbrk_callee
        EXTERN ASMDISP_HEAPSBRK_CALLEE
        
        call HeapSbrk_callee + ASMDISP_HEAPSBRK_CALLEE
ELSE
	defc HEAPSIZE = 4
ENDIF

; call main now

	call _main

; end program

cleanup:
endloop:
	di
	halt
	jr endloop


l_dcal:	jp	(hl)		;Used for call by function pointer


IFNDEF CRT_ORG_BSS
	defc CRT_ORG_BSS = $C000   ; Ram variables are kept in RAM in high memory
ENDIF
	defc	__crt_org_bss = CRT_ORG_BSS

        ; If we were given a model then use it
        IFDEF CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF


;===============================================================================
ENDIF
;===============================================================================



; Safe BIOS call
msxbios:
	ld	iy,($FCC0)	; slot address of BIOS ROM
	call	001Ch		; CALSLT
	ei			; make sure interrupts are enabled
	ret

	defm	"Small C+ MSX"
end:	defb	0

	INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"

; ---------------
; MSX specific stuff
; ---------------


	SECTION		bss_crt
; Keeping the BREAK status
	PUBLIC	brksave
	PUBLIC	dfltdsk
brksave:	defb	1
defltdsk:       defb    0	; Default disc
IF (startup=2)
IF !DEFINED_nofileio
	PUBLIC	__fcb
__fcb:		defs	420,0	;file control block (10 files) (MAXFILE)
ENDIF
ENDIF

        SECTION rodata_clib
IF (startup=2)
IF !DEFINED_noredir
IF !DEFINED_nostreams
redir_fopen_flag:	defb	'w',0
redir_fopen_flagr:	defb	'r',0
ENDIF
ENDIF
ENDIF 
