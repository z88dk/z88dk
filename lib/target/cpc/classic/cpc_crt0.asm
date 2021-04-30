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

        defc    CONSOLE_COLUMNS = 40
        defc    CONSOLE_ROWS = 25

        PUBLIC    cpc_enable_fw_exx_set       ;needed by firmware interposer
        PUBLIC    cpc_enable_process_exx_set  ;needed by firmware interposer
		
	GLOBAL    __interposer_isr__

	defc	TAR__no_ansifont = 1
	defc	TAR__register_sp = -1
        defc	TAR__clib_exit_stack_size = 8
	defc	CRT_KEY_DEL = 12
	defc __CPU_CLOCK = 4000000
	INCLUDE	"crt/classic/crt_rules.inc"

	INCLUDE "target/cpc/def/cpcfirm.def"

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
;;------------------------------------------------------------------------
;; store the drive number the loader was run from
	ld hl,($be7d)
	ld a,(hl)                  
	ld (drive+1),a

;;------------------------------------------------------------------------
	ld c,$ff					;; disable all roms
	ld hl,start2					;; execution address for program
	call mc_start_program		;; start it

;;------------------------------------------------------------------------

.start2
	call kl_rom_walk			;; enable all roms 

;;------------------------------------------------------------------------
;; when AMSDOS is enabled, the drive reverts back to drive 0!
;; This will restore the drive number to the drive the loader was run from
.drive  ld a,0
	ld hl,($be7d)
	ld (hl),a


        di
        ld      (start1+1),sp
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"
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
	defc	CRT_MAX_HEAP_ADDRESS = 0xa600
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


        call    _main

cleanup:
    call    crt0_exit


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




		INCLUDE "crt/classic/crt_runtime_selection.asm"

		INCLUDE "crt/classic/crt_section.asm" 

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

