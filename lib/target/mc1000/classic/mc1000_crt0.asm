;
;       Startup for the CCE MC-1000
;
;       Stefano Bodrato - Feb. 2013
;
;       $Id: mc1000_crt0.asm,v 1.22 2016-07-15 21:03:25 dom Exp $
;

; 	There are a couple of #pragma optimization directives 
;	this file:
;
;	#pragma output nostreams      - No stdio disc files




                MODULE  mc1000_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


	; Force the interrupt handler to be registered
	EXTERN	asm_im1_handler
	defc	IMPORT_asm_im1_handler = asm_im1_handler


        defc    CONSOLE_COLUMNS = 32
IF NEED_ansiterminal
	defc	CONSOLE_ROWS = 24
ELSE
        defc    CONSOLE_ROWS = 16
ENDIF

        IF      !DEFINED_CRT_ORG_CODE
	   IF (startup=2)
		defc    CRT_ORG_CODE  = $100  ; Direct M/C mode, including system variables on top 100h bytes
 	   ELSE
		defc    CRT_ORG_CODE  = 981	; BASIC startup mode (correct location TBD)
	   ENDIF
        ENDIF


        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = 0	; 0 = autodetect
	defc	__CPU_CLOCK = 3579545
        INCLUDE "crt/classic/crt_rules.inc"

	INCLUDE	"target/mc1000/def/maths_mbf.def"

	org     CRT_ORG_CODE


IF (startup=2)

  ; native M/C startup mode
  ; "TLOAD" mode

;
    defb  $ff,$ff,$ff
MC_PGM:
MC_PGN:
MC_MUSIC:
    defb  $ff
MC_PLAY:
    defb  $01
MC_PLAYMX:
    defb  $01
MC_HEAD:
    defb  $00
MC_RANDOM:
    defw  $ffff
MC_RCRDPT:
    defw  MC_RECORD
MC_RECORD:
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
MC_KEY0:
    defb  $ff,$ff,$ff,$ff
;
    defb  $ff
MC_JOB:
    ret
    defb  $ff,$ff
MC_SCOREA:
    defb  $00
MC_SCOREB:
    defb  $00
MC_SHAPE0:
    defb  $ff
;
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff
MC_JOBM:
    ret
    defb  $ff,$ff
;
    defb  $ff,$ff
MC_TABLE:
MC_NSA:
    defw  $ffff
MC_NAA:
    defw  $ffff
MC_AVALUE:
    defb  $00
VOICEA:
    defb  $ff
MC_INTRPA:
    defb  $ff
MC_TEMPA:
    defb  $ff
MC_INTA:
    defb  $ff
MC_NSB:
    defw  $ffff
MC_NBB:
    defw  $ffff
MC_BVALUE:
    defb  $00
MC_VOICEB:
    defb  $ff
MC_INTRPB:
    defb  $ff
MC_TEMPB:
    defb  $ff
MC_INTB:
    defb  $ff
MC_NSC:
    defw  $ffff
MC_NCC:
    defw  $ffff
MC_CVALUE:
    defb  $00
MC_VOICEC:
    defb  $ff
MC_INTRPC:
    defb  $ff
MC_TEMPC:
    defb  $ff
MC_INTC:
    defb  $ff
MC_ENABLE:
    defb  $ff
MC_AMPLIT:
    defb  $ff
MC_REGIST:
    defw  $ffff
MC_DEFIN:
    defb  $ff
MC_ONAMP:
    defw  $ffff
MC_LPLAY:
    defb  $ff
;
    defb  $ff,$ff,$ff,$ff,$ff,$ff
MC_CHECK:
    defb  $00
;
    defb  $ff,$ff,$ff,$ff
MC_DSNAM:
    defw  $8000
MC_DENAM:
    defw  $8200
MC_HISCOR:
    defw  $ffff
MC_TEMP:
    defb  $ff
;
    defb  $ff,$ff
MC_RIGHTJ:
    defb  $ff
MC_CHANA:
    defw  $ffff
;
    defb  $ff,$ff,$ff
MC_TONEA:
    defb  $ff
MC_CHANB:
    defw  $ffff
;
    defb  $ff,$ff,$ff
MC_TONEB:
    defb  $ff
MC_CHANC:
    defw  $ffff
;
    defb  $ff,$ff,$ff
MC_TONEC:
    defb  $ff
MC_OBUF:
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff
MC_FILNAM:
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff
;
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff

;		; At position 200h different 'topics' (entries)
;		; can be defined; user can choose the topic CTRL-H
;		jp		start

		;..on the other side the first topic can be directly
		; the main program entry point, so no need for a jump table  :P


ELSE

  ; BASIC startup mode

    defw  nxt_basic_line
    defw  0       ; BASIC Line number
    defb  $a2     ; Token for CALL.
    defm  "992"   ; this BASIC caller stub is 11 bytes long
    defb  0       ; End of line
nxt_basic_line:
    defw  0


ENDIF


start:
	
	;CALL $CEBA
	;LD ($0128),A
	;LD ($0357),A
	;LD ($0360),A
	;LD ($0358),A
	;LD ($0352),A
	;LD ($0361),A
	;DEC A
	;LD ($0106),A
	;LD ($0353),A
	;LD ($106),a
		;ld		hl,$106
		;ld		(hl),255	; disable gaming mode (shouldn't this work by putting 255??)
    ld      (__restore_sp_onexit+1),sp
IF __register_sp == 0
    ld      hl,$bfff	; 48K ?
    ld      a,$55
    ld      (hl),a
    cp      (hl)
    jr      z,has48k
    ld      hl,$3fff	; 48K.
has48k:
    ld      sp,hl
    UNDEFINE  __register_sp
    defc    __register_sp = -1
ENDIF
        
        ;ei
        ;xor     a
        ;out     ($80),a
        ;call    $c021      ; setup text page (ptr in HL)
       
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm" 
	call	crt0_init_bss
	ld	(exitsp),sp
		
IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
		
        call    _main
cleanup:
        push    hl
        call    crt0_exit

        pop     bc
__restore_sp_onexit:
        ld      sp,0

IF (startup=2)
        ;jp      $C000  ; BASIC entry (COLD RESET)
        jp      $C003  ; BASIC entry (WARM RESET)
ELSE
	ret
ENDIF

l_dcal:
        jp      (hl)

		
; If we were given an address for the BSS then use it
IF DEFINED_CRT_ORG_BSS
	defc	__crt_org_bss = CRT_ORG_BSS
ENDIF


	INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE	"crt/classic/crt_section.asm"

