;       CRT0 for the ZX81
;
;       Stefano Bodrato Apr. 2000
;
;       If an error occurs (eg. out if screen) we just drop back to BASIC
;
;       ZX81 will be thrown in FAST mode by default.
;       The "startup=2" parameter forces the SLOW mode.
;       Values for "startup" from 3 to 6 activate the WRX HRG modes
;       Values between 13 and 17 activate the ARX HRG modes
;		LAMBDA 8300/POWER 3000 modes: startup=101 and startup=102
;		LAMBDA 8300 monochrome ROM: startup=201 and startup=202
;		LAMBDA 8300 CAC-3 and NF300 ROM: startup=301 and startup=302
;
;       OPTIMIZATIONS:
;
;       If in HRG mode it is possible to exclude the SLOW mode text with the
;       '-DDEFINED_noslowfix' parameter it helps to save some memory.
;       "#pragma output noslowfix = 1" in the source program has the same effect.
;
;       If in WRX HRG mode a static position for HRGPAGE cam be defined in 
;       program (i.e. "#pragma output hrgpage=32768"), moving the video frame
;       over the stack instead than lowering it.  The automatic HRG page locator
;       is also disabled too, ripping off about 13 bytes.
;       In any case by POKEing at address 16518/16519 of the compiled program 
;       the HRG page position can be still changed by the user for custom needs.
;
; - - - - - - -
;
;       $Id: zx81_crt0.asm $
;
; - - - - - - -


        MODULE  zx81_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    __Exit         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)



IF (startup>100)
		; LAMBDA specific definitions (if any)
ENDIF


        PUBLIC    save81          ;Save ZX81 critical registers
        PUBLIC    restore81       ;Restore ZX81 critical registers

        ;; PUBLIC    frames         ;Frame counter for time()
        PUBLIC    _FRAMES
        defc    _FRAMES = 16436	; Timer

	defc	CONSOLE_ROWS = 24
	defc	CONSOLE_COLUMNS = 32

        IF      !DEFINED_CRT_ORG_CODE
	    IF (startup>100)
		; ORG position for LAMBDA
                defc    CRT_ORG_CODE  = 17307
 	    ELSE
                defc    CRT_ORG_CODE  = 16514
	    ENDIF
        ENDIF

	defc	TAR__register_sp = -1
        defc    TAR__clib_exit_stack_size = 4
        defc    CRT_KEY_DEL = 12
	defc	__CPU_CLOCK = 3250000
	INCLUDE	"crt/classic/crt_rules.inc"


        PUBLIC  __CLIB_ZX_LOWER_CASE_TRANSFORM
        PUBLIC  __CLIB_ZX_UPPER_CASE_TRANSFORM
        PUBLIC  __CLIB_ZX_CAPITAL_TRANSFORM
        PUBLIC  __CLIB_ZX_INVERSE_TRANSFORM

        IF !DEFINED_ZX_CHAR_XLATE_MODE
            defc ZX_CHAR_XLATE_MODE = 0
        ENDIF

        ;ASCII A = 65
        ;      a = 97
        ;ZX81  A = $26
        ;     _A_= $A6

        IF ZX_CHAR_XLATE_MODE = 0
            ; Transforms lower case to upper case - is added ascii -> zx81
            defc __CLIB_ZX_LOWER_CASE_TRANSFORM = $26 - 'a'
            defc __CLIB_ZX_CAPITAL_TRANSFORM = $26 - 'a'
            ; Transforms upper case to inverse upper case is added ascii -> zx81
            defc __CLIB_ZX_UPPER_CASE_TRANSFORM = $A6 - 'A'
            defc __CLIB_ZX_INVERSE_TRANSFORM = $A6 - 'A'
        ELIF ZX_CHAR_XLATE_MODE = 1
            ; Transforms lower case to inverse upper case
            defc __CLIB_ZX_LOWER_CASE_TRANSFORM = $A6 - 'a'
            defc __CLIB_ZX_INVERSE_TRANSFORM = $A6 - 'a'
            ; Transforms upper case to upper case
            defc __CLIB_ZX_UPPER_CASE_TRANSFORM = $26 - 'A'
            defc __CLIB_ZX_CAPITAL_TRANSFORM = $26 - 'A'
        ELIF ZX_CHAR_XLATE_MODE = 2
            ; Transforms lower case to upper case
            defc __CLIB_ZX_LOWER_CASE_TRANSFORM = $26 - 'a'
            defc __CLIB_ZX_INVERSE_TRANSFORM = $A6 - 'A'
            ; Transforms upper case to upper case
            defc __CLIB_ZX_UPPER_CASE_TRANSFORM = $26 - 'A'
            defc __CLIB_ZX_CAPITAL_TRANSFORM = $26 - 'A'
        ENDIF

        org     CRT_ORG_CODE


; Hide the mess in the REM line from BASIC program listing

;       jr      start
;       defb    118,255         ; block further listing

; As above, but more elegant

        ld      a,(hl)          ; hide the first 6 bytes of REM line
        jp      start           ; invisible
	defc	DEFINED_basegraphics = 1
	PUBLIC	base_graphics
_base_graphics:                 ; Address of the Graphics map..
base_graphics:			; it is POKEable at address 16518/16519
IF DEFINED_hrgpage
		defw	hrgpage
ELSE
		defw    0
ENDIF
        defb    'Z'-27          ; Change this with your own signature
        defb    '8'-20
        defb    '8'-20
        defb    'D'-27
        defb    'K'-27
        defb    0
        defb    'C'+101
        defb    149     ; '+'
        defb    118,255         ; block further listing

start:
		ld		ix, 16384	; (IXIY swap) when self-relocating IY is corrupt
        call    save81

IF (!DEFINED_startup | (startup=1))
        ; FAST mode, safest way to use the special registers
        call    $F23    ; FAST mode
        ;call   $2E7    ;setfast
        ;out ($fd),a  ; nmi off        
ENDIF

; LAMBDA 8300
IF (startup>100)
	IF (startup=101)
		; FAST mode, safest way to use the special registers
		call	$D5E
	ENDIF
	IF (startup=201)
		; FAST mode in monochrome ROM
		call	$36C
	ENDIF
	IF (startup=301)
		; FAST mode on CAC-3 and NF300
		call	$E06
	ENDIF
	IF ((startup=102) | (startup=202) | (startup=302))
      call    altint_on
	ENDIF
ELSE

IF (startup>=2)
 IF ((startup=3)|(startup=5)|(startup=8)|(startup=13)|(startup=15)|(startup=18)|(startup=20)|(startup=23)|(startup=25))
        ld	a,1
        ld      (hrgbrkflag),a
 ENDIF
 IF (startup=2)
        call    altint_on
	; Trick to get the HRG mode with a #pragma definition
	; perhaps useful with the MemoTech or the G007 HRG boards
	IF DEFINED_ANSIHRG
			call    hrg_on
	ENDIF
 ELSE
        call    hrg_on
 ENDIF
ENDIF
ENDIF

IF (startup>100)
		; LAMBDA specific startup code (if any)
ELSE
IF (startup>=23)	; CHROMA 81
	ld	a,32+16+7	; 32=colour enabled,  16="attribute file" mode, 7=white border
	ld	bc,7FEFh
	out	(c),a

	ld	a,7*16		; white paper, black ink
	ld	hl,HRG_LineStart+2+32768
	ld	de,(16396)
	set	7,d
	inc	de
	ld	c,24
.rowloop
	ld	b,32
.rowattr
	ld	(hl),a
	ld	(de),a
	inc	hl
	inc	de
	djnz rowattr
	inc	hl
	inc	hl
	inc	hl
	inc	de
	dec	c
	jr	nz,rowloop
ENDIF
ENDIF

	; this must be after 'hrg_on', sometimes
	; the stack will be moved to make room
	; for high-resolution graphics.
	
    ld      (__restore_sp_onexit+1),sp   ;Save entry stack

    INCLUDE	"crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

        call    _main   ;Call user program
        
__Exit:
        push    hl		; keep return code

        call    crt0_exit

		; The BASIC USR call would restore IY on return, but it could not be enough
        call    restore81

IF (startup>100)
	; LAMBDA specific exit resume code (if any)
    IF (startup=101)
	call	 $12A5	; SLOW
    ENDIF
    IF (startup=201)
	call	 $281	; SLOW (Monochrome ROM)
    ENDIF
    IF (startup=301)
	call	 $13BE	; SLOW (CAC-3 amd NF300)
    ENDIF
    IF ((startup=102) | (startup=202) | (startup=302))
        call    altint_off
    ENDIF
ELSE
IF (startup>=2)
 IF ((startup=3)|(startup=5)|(startup=8)|(startup=13)|(startup=15)|(startup=18)|(startup=20)|(startup=23)|(startup=25))
        xor	a
        ld      (hrgbrkflag),a
 ELSE
  IF (startup=2)
        call    altint_off
  ELSE
        call    hrg_off		; this is valid for mode 2, too !
  ENDIF
 ENDIF
ELSE
 IF (!DEFINED_startup | (startup=1))
        call    $F2B            ; SLOW mode
        ;call   $207    ;slowfast
 ENDIF
ENDIF
ENDIF

        pop     bc		; return code (for BASIC)
__restore_sp_onexit:ld      sp,0            ;Restore stack to entry value
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls


restore81:
IF (!DEFINED_startup | (startup=1))
        ex      af,af
a1save:
        ld      a,0
        ex      af,af
ENDIF
        exx
hl1save:
        ld	hl,0
        ;ld	bc,(bc1save)
        ;ld	de,(de1save)
        exx
        ld      ix,16384	; IT WILL BECOME IY  !!
        ret
        
save81:
IF (!DEFINED_startup | (startup=1))
        ex      af,af
        ld      (a1save+1),a
        ex      af,af
ENDIF
        exx
        ld	(hl1save + 1),hl
        ;ld	(de1save),de
        exx
        ret


;---------------------------------------
; Modified IRQ handler
;---------------------------------------

IF (startup>100)
	; LAMBDA modes
     IF ((startup=102) | (startup=202) | (startup=302))
        INCLUDE "target/lambda/classic/lambda_altint.asm"
     ENDIF
ELSE

; +++++ non-LAMBDA section begin +++++

    IF (startup=2)
        INCLUDE "target/zx81/classic/zx81_altint.asm"
    ENDIF

;-------------------------------------------------
; High Resolution Graphics (Wilf Rigter WRX mode)
; Code my Matthias Swatosch
;-------------------------------------------------

    IF (startup>=3)
	IF ((startup<=9)|(startup=20)|(startup>=23))
            INCLUDE "target/zx81/classic/zx81_hrg.asm"
        ENDIF
    ENDIF

;-------------------------------------------------
; High Resolution Graphics (Andy Rea ARX816 mode)
;-------------------------------------------------

    IF (startup>=13)
	IF (startup>=23)
	;
	ELSE
	    IF (startup<=19)
		INCLUDE "target/zx81/classic/zx81_hrg_arx.asm"
	    ENDIF
	ENDIF
    ENDIF
; +++++ non-LAMBDA section end +++++
ENDIF

;-------------------------------------------------
; FAST mode workaround for those functions trying
; to use zx_fast and zx_slow
;-------------------------------------------------
IF (!DEFINED_startup | (startup=1))
	PUBLIC zx_fast
	PUBLIC zx_slow
	PUBLIC _zx_fast
	PUBLIC _zx_slow
zx_fast:
zx_slow:
_zx_fast:
_zx_slow:
	ret
ENDIF

IF (startup>100)

    ; LAMBDA JP tables
	
	PUBLIC __lambda_keyboard
	PUBLIC __lambda_decode
	PUBLIC __lambda_cls
	PUBLIC __lambda_next_one
	PUBLIC __lambda_make_room
	PUBLIC __lambda_stk_store
	PUBLIC __lambda_stk_fetch
	PUBLIC __lambda_stack_bc
	PUBLIC __lambda_fp_to_bc
	PUBLIC __lambda_reclaim_space
	PUBLIC __lambda_line_addr
	PUBLIC __lambda_line_run
	PUBLIC __lambda_class_6
	PUBLIC __lambda_find_int
	PUBLIC __lambda_scanning
	PUBLIC __lambda_strs_add
	PUBLIC __lambda_syncvideo	; entry for fgetc_cons_fast

; Color Lambda ROM
IF ((startup=101) | (startup=102))
    defc __lambda_keyboard       =  $0D74
    defc __lambda_decode         =  $1877
    defc __lambda_cls            =  $1C7D
    defc __lambda_next_one       =  $1A13
    defc __lambda_clear_one      =  $0174
    defc __lambda_make_room      =  $1CB5
    defc __lambda_stk_store      =  $13BC
    defc __lambda_stk_fetch      =  $0020
    defc __lambda_stack_bc       =  $077E
    defc __lambda_fp_to_bc       =  $0555
    defc __lambda_reclaim_space  =  $0177
    defc __lambda_line_addr      =  $0B36
    defc __lambda_line_run       =  $0088
    defc __lambda_class_6        =  $0A11
    defc __lambda_find_int       =  $1509
    defc __lambda_scanning       =  $0806
    defc __lambda_strs_add       =  $189B
    defc __lambda_syncvideo      =  $131B
ENDIF

; Monochrome Lambda ROM (earlier version)
IF ((startup=201) | (startup=202))
    defc __lambda_keyboard       =  $033D
    defc __lambda_decode         =  $095E
    defc __lambda_cls            =  $0BD0
    defc __lambda_next_one       =  $0B84
    defc __lambda_clear_one      =  $0612
    defc __lambda_make_room      =  $0B30
    defc __lambda_stk_store      =  $14B8
    defc __lambda_stk_fetch      =  $15ED
    defc __lambda_stack_bc       =  $1718
    defc __lambda_fp_to_bc       =  $1782
    defc __lambda_reclaim_space  =  $0BF5
    defc __lambda_line_addr      =  $0B36
    defc __lambda_line_run       =  $0E45
    defc __lambda_class_6        =  $0F0F
    defc __lambda_find_int       =  $1088
    defc __lambda_scanning       =  $114A
    defc __lambda_strs_add       =  $1D57
    defc __lambda_syncvideo      =  $02F8
ENDIF

; CAC-3 and NF300
IF ((startup=301) | (startup=302))
    defc __lambda_keyboard       =  $0E1C
    defc __lambda_decode         =  $1A40
    defc __lambda_cls            =  $1602
    defc __lambda_next_one       =  $1BE0
    defc __lambda_clear_one      =  $01CF
    defc __lambda_make_room      =  $1E39
    defc __lambda_stk_store      =  $14D5
    defc __lambda_stk_fetch      =  $153F
    defc __lambda_stack_bc       =  $0821
    defc __lambda_fp_to_bc       =  $05DE
    defc __lambda_reclaim_space  =  $01D2
    defc __lambda_line_addr      =  $0BDA
    defc __lambda_line_run       =  $00A6
    defc __lambda_class_6        =  $0AB2
    defc __lambda_find_int       =  $167C
    defc __lambda_scanning       =  $08AB
    defc __lambda_strs_add       =  $1A68
    defc __lambda_syncvideo      =  $1434
ENDIF

ENDIF


;-----------
; Now some variables
;-----------
IF (startup>=3)
 IF (startup>100)
		; LAMBDA specific definitions (if any)
 ELSE
	PUBLIC text_rows
	PUBLIC hr_rows
	PUBLIC _hr_rows
text_rows:
hr_rows:
_hr_rows:
  IF (startup=20)
		defw	48	; Current number of text rows in graphics mode
  ELSE
    IF ((startup=5)|(startup=6)|(startup=7)|(startup=15)|(startup=16)|(startup=17)|(startup=25)|(startup=26)|(startup=27))
		defw	8	; Current number of text rows in graphics mode
    ELSE
     IF ((startup=8)|(startup=9)|(startup=18)|(startup=19))
		defw	16
     ELSE
		defw	24	; Current number of text rows in graphics mode
     ENDIF
    ENDIF
  ENDIF
 ENDIF
ENDIF


        INCLUDE "crt/classic/crt_runtime_selection.inc"
	INCLUDE "crt/classic/crt_section.inc"

