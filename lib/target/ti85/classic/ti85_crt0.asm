;	Stub for the TI 85 calculator
;
;	Stefano Bodrato - Dec 2000
;
;	$Id: ti85_crt0.asm,v 1.32 2016-07-11 05:58:34 stefano Exp $
;
;-----------------------------------------------------
; Some general PUBLICs and EXTERNs needed by the assembler
;-----------------------------------------------------

	MODULE  Ti85_crt0

	EXTERN	_main		; No matter what set up we have, main is
				;  always, always external to this file.

	PUBLIC	cleanup		; used by exit()
	PUBLIC	l_dcal		; used by calculated calls = "call (hl)"


	PUBLIC	cpygraph	; TI calc specific stuff
	PUBLIC	tidi		;
	PUBLIC	tiei		;

;-------------------------
; Begin of (shell) headers
;-------------------------

	LSTOFF
	INCLUDE "Ti85.def"	; ROM / RAM adresses on Ti85
        defc    crt0 = 1
	INCLUDE	"zcc_opt.def"	; Receive all compiler-defines
	LSTON

	defc	CONSOLE_ROWS = 8
	defc    CONSOLE_COLUMNS = 21
        defc    TAR__clib_exit_stack_size = 3
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 6000000
        INCLUDE "crt/classic/crt_rules.inc"

;
;PROGRAMS:
;~~~~~~~~~
; 00 FD  - ZShell programs
; 00 FC  - Rigel program string
; 00 FB  - Usgard 1.0 programs
; 00 F9  - Usgard 1.1 programs
; 00 F8  - Usgard 1.5 programs
; 00 53  - Summit Shell Patch (BETA 1-3)
; 00 50  - PhatOS
; 02 50  - Peak BETA 2 Relocation Program
; 02 70  - Peak BETA 2 Non-Relocation Program
; 04 42  - Summit BETA 4 TI-BASIC ASM Subroutine
; 04 4E  - Summit BETA 4 Non-Relocation Program
; 04 52  - Summit BETA 4 Relocation Program
; 04 54  - Summit BETA 4 TSR
;
;LIST OF LIBRARY HEADERS:
;~~~~~~~~~~~~~~~~~~~~~~~~
; 00 FB  - Rigel library string
; 00 90  - fake library
;
;LIST OF FILE HEADERS:
;~~~~~~~~~~~~~~~~~~~~~
; 00 81  - GCP image (screenwide)
; 00 80  - ZCP image (screenwide)
; 00 7D  - 128 x 64 B/W image
; 00 7E  - 128 x 64 GR4 image
; 00 7F  - 128 x 64 GR8 image
;
;LIST OF LEVEL HEADERS:
;~~~~~~~~~~~~~~~~~~~~~~
;(first byte=game,second byte could be [save game,level,hiscore,...] 
; 01 00  - Plainjump II level file
; 02 00  - Sqrxz world (not compressed)
; 02 01  - Sqrxz compressed world
; 03 00  - Plainjump level file
; 04 00  - Balloon compressed level file


; Offset            Example                                       Description
;����������������������������������������������������������������������������?; 0000-0001          xx xx   -   A two-byte size of the string.  This is added
;                                by the TI-85.
; 0002-0003          00 xx   -   A signature word, where xx is either FD, FC,
;                                or FB.
;                                FD = ZShell 4.0 string.
;                                FC = Rigel program string.
;                                FB = Rigel library string.
; 0004               xx      -   The size of the description string.
; xxxx-xxxx                  -   The description string (null terminated).
; xxxx-xxxx          xx xx   -   A relative pointer to the fixup table. (not
;                                used in ZShell).
; 
;                 BELOW ARE DATA AREAS WITHIN THE FIXUP TABLE
;
; xxxx               xx      -   The number of location fixups.
; xxxx-xxxx                  -   The relative addresses within the string
;                                that need to be fixed up. 
; xxxx               xx      -   The number of libraries to be linked.
; xxxx-xxxx                  -   A length-indexed string of the first library
;                                to be linked.
; xxxx               xx      -   the number of fixups to be made to call
;                                functions within the preceding library or
;                                more clearly, the number of calls made to
;                                the preceding library.
; xxxx-xxxx                  -   The relative addresses within the string
;                                that need to be fixed up to make calls to the
;                                preceding library.
;
; (if more than one library is to be linked, the last three ranges described 
;  are repeated as necessary.  The "number of libraries" byte denotes this).
;����������������������������������������������������������������������������?

;--------
;2 - Peak
;--------
;IF (startup=2)
;DEFINE NOT_DEFAULT_SHELL
;DEFC ORIGIN = $906D
;	org	ORIGIN
;	defb	$02,$50
;ENDIF

;----------
;3 - PhatOS (doesn't work right)
;----------
IF (startup=3)
	DEFINE PhatOS
	DEFINE NOT_DEFAULT_SHELL
	org	$8E54		; 'real' origin to PhatOS programs
	defw	$5000		; This is a PhatOS program string
	defb	enddesc-description+1
	;org	$8E57		; Origin to PhatOS programs
description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"	; Get namestring from zcc_opt.def
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
enddesc:
	im	1
ENDIF

;-------------------
;1 - Rigel (default)
;-------------------
IF !NOT_DEFAULT_SHELL
	DEFINE Rigel
	
	org	$9293		; 'real' origin to Rigel programs
	defw	$FC00		; This is a Rigel program string
	defb	enddesc-description-1
description:			; = "official" origin adress
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"	; Get namestring from zcc_opt.def
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
enddesc:
	defw	fixuptable-description	; Relative ptr to the fixup table
	im	1
ENDIF

;-------------------------------------
; End of header, begin of startup part
;-------------------------------------
start:
	ld	(__restore_sp_onexit+1),sp
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
        call    crt0_init_bss
        ld      (exitsp),sp
IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


	EXTERN	fputc_cons
	ld	hl,12
	push	hl
	call	fputc_cons
	pop	hl

IF DEFINED_GRAYlib
	INCLUDE	"target/ti85/classic/gray85.asm"
	;im	2
ENDIF

	call	tidi
	call	_main
cleanup:
IF DEFINED_GRAYlib
        ld	a,$3c
        out	(0),a    ;Set screen back to normal
ENDIF
__restore_sp_onexit:
	ld	sp,0
	ld	iy,_IY_TABLE	; Restore flag-pointer
	im	2
	ei
cpygraph:
	ret

;----------------------------------------
; End of startup part, routines following
;----------------------------------------
l_dcal:
	jp	(hl)

tiei:

IF DEFINED_GRAYlib
	im	1
ELSE
	ei
ENDIF
	ret

tidi:
IF DEFINED_GRAYlib
	im	2
ELSE
	di
ENDIF
	ret

		defc ansipixels = 128
		IF !DEFINED_ansicolumns
			 defc DEFINED_ansicolumns = 1
			 defc ansicolumns = 32
		ENDIF

        INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE	"crt/classic/crt_section.asm"

	SECTION	code_crt_init
	ld	hl,VIDEO_MEM
	ld	(base_graphics),hl

	SECTION	bss_crt
IF Rigel
fixuptable:
	defb	0,0	; zero fixups, zero ZShell libs
ENDIF


