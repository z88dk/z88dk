;       Startup stub for z88 BBC BASIC programs
;
;       Created 1/4/99 djm
;
;	$Id: bas_crt0.asm,v 1.21 2016-06-21 20:49:06 dom Exp $


;-----------
; The .def files that we need here
;-----------
	INCLUDE "bastoken.def"
	INCLUDE "ctrlchar.def"
	INCLUDE "error.def"
	INCLUDE "stdio.def"

;--------
; Define the graphics map and segment for basic
;--------
        EXTERN  z88_map_bank
        EXTERN  z88_map_segment
        defc    z88_map_bank = $4D3
        defc    z88_map_segment = 192

        org $2300

;-----------
; Dennis Groning's BASIC file header
;-----------
bas_first:
        DEFB    bas_last - bas_first    ;Line Length
;       DEFW    0                       ;Row Number 0 can not be listed
        DEFW    1
        DEFM    BAS_IF , BAS_PAGE_G , "<>&2300" , BAS_THEN , BAS_NEW
        DEFM    BAS_ELSE , BAS_LOMEM_P , "=&AFFF" , BAS_CALL , BAS_TO , "P" , CR
bas_last:
        DEFB    0
        DEFW    $FFFF           ;End of BASIC program. Next address is TOP.


;-----------
; Code starts executing from here
;-----------
start:
	ld	(start1+1),sp	;Save starting stack
        ld      sp,($1ffe)	;Pick up stack from OZ safe place
        call    crt0_init_bss
        ld      hl,-64		;Make room for the atexit() table
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	ld	hl,(start1+1)
	INCLUDE "amalloc.def"
ENDIF

        call    doerrhan	;Initialise a laughable error handler

        call    _main		;Run the program
cleanup:			;Jump back here from exit() if needed
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall	;Close any open files (fopen)
ENDIF
        call_oz(gn_nln)		;Print a new line
        call    resterrhan	;Restore the original error handler
start1:	ld	sp,0		;Restore stack to entry value
        ret			;Out we go

;-----------
; Install the error handler
;-----------
doerrhan:
        xor     a
        ld      (exitcount),a
        ld      b,0
        ld      hl,errhand
        call_oz(os_erh)
        ld      (l_erraddr),hl
        ld      (l_errlevel),a
        ret

;-----------
; Restore BASICs error handler
;-----------
resterrhan:
        ld      hl,(l_erraddr)
        ld      a,(l_errlevel)
        ld      b,0
        call_oz(os_erh)
processcmd:			;processcmd is called after os_tin
        ld      hl,0
        ret


;-----------
; The error handler
;-----------
errhand:
        ret     z   		;Fatal error
        cp      RC_Esc
        jr     z,errescpressed
        ld      hl,(l_erraddr)	;Pass everything to BASIC's handler
        scf
l_dcal:	jp	(hl)		;Used for function pointer calls also

errescpressed:
        call_oz(Os_Esc)		;Acknowledge escape pressed
        jr      cleanup		;Exit the program



        INCLUDE "crt0_runtime_selection.asm"

; We can't use far stuff with BASIC cos of paging issues so
; We assume all data is in fact near, so this is a dummy fn
; really

;-----------
; Far stuff can't be used with BASIC because of paging issues, so we assume
; that all data is near - this function is in fact a dummy and just adjusts
; the stack as required
;-----------
_cpfar2near:
	pop	bc
	pop	hl
	pop	de
	push	bc
	ret


        INCLUDE "crt0_section.asm"

        SECTION  bss_crt
l_erraddr:       defw    0       ;Not sure if these are used...
l_errlevel:      defb    0
