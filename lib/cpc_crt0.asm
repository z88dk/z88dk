;       CRT0 for the Amstrad CPC family
;
;       Stefano Bodrato 8/6/2000
;
;       $Id: cpc_crt0.asm,v 1.37 2016-07-15 21:03:25 dom Exp $
;

        MODULE  cpc_crt0


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

        PUBLIC    cpc_enable_fw_exx_set       ;needed by firmware interposer
        PUBLIC    cpc_enable_process_exx_set  ;needed by firmware interposer
		
	GLOBAL    __interposer_isr__

;--------
; Set an origin for the application (-zorg=) default to $1200
;--------

IF      !DEFINED_CRT_ORG_CODE
		defc    CRT_ORG_CODE  = $1200
ENDIF   
                org     CRT_ORG_CODE


;--------
; REAL CODE
;--------

start:

        di
        ld      (start1+1),sp
IFNDEF STACKPTR
	ld sp,(0xae60)               ; set stack location to last byte of udg area
ELSE
    IF STACKPTR > -1
	ld sp,STACKPTR          ; user supplied stack location
    ENDIF
ENDIF
		
	; make room for exit stack
	ld      hl,-64                  ; reserve space for 32 entries on the exit stack
	add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp


	; enable process exx set
	; install interrupt interposer
	call    cpc_enable_process_exx_set
	ei

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	INCLUDE "amalloc.def"
ENDIF


        call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
        EXTERN     closeall
        call    closeall
ENDIF

        di
	call    cpc_enable_fw_exx_set
start1: ld      sp,0
        ei
        ret

l_dcal: jp      (hl)


; These subroutines make it possible to coexist with the firmware.
; Interrupts must be disabled while these routines run.

cpc_enable_fw_exx_set:

   exx
   ex af,af'

   ld (__process_exx_set_hl__),hl      ; save process exx set
   ld (__process_exx_set_de__),de
   ld (__process_exx_set_bc__),bc
   push af
   pop hl
   ld (__process_exx_set_af__),hl
   
IF startup != 2
   ld hl,(__fw_int_address__)
   ld (0x0039),hl                      ; restore firmware isr
ENDIF
   
   ld bc,(__fw_exx_set_bc__)           ; restore firmware exx set
   or a
   
   ex af,af'
   exx
   
   ret

cpc_enable_process_exx_set:
   
   exx
   ex af,af'

   ld (__fw_exx_set_bc__),bc           ; save firmware exx set
   
IF startup != 2
   ld hl,(0x0039)
   ld (__fw_int_address__),hl          ; save firmware interrupt entry
   
   ld hl,__interposer_isr__
   ld (0x0039),hl                      ; interposer receives interrupts
ENDIF
   
   ld hl,(__process_exx_set_af__)      ; restore process exx set
   push hl
   pop af
   ld bc,(__process_exx_set_bc__)
   ld de,(__process_exx_set_de__)
   ld hl,(__process_exx_set_hl__)
   
   ex af,af'
   exx

   ret

IF startup != 2

__interposer_isr__:

   call cpc_enable_fw_exx_set
   call 0x0038
   di
   call cpc_enable_process_exx_set
   ei
   ret

ENDIF




                defm    "Small C+ CPC"
                defb    0

		INCLUDE "crt0_runtime_selection.asm"

		INCLUDE "crt0_section.asm" 

		SECTION	code_crt_init
	ld	hl,$c000
	ld	(base_graphics),hl

		SECTION	bss_crt
__fw_exx_set_bc__:        defs 2
__process_exx_set_af__:   defs 2
__process_exx_set_bc__:   defs 2
__process_exx_set_de__:   defs 2
__process_exx_set_hl__:   defs 2
__fw_int_address__:       defs 2

