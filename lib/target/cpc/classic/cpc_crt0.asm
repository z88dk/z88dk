;       CRT0 for the Amstrad CPC family
;
;       Stefano Bodrato 8/6/2000
;
;       $Id: cpc_crt0.asm,v 1.37 2016-07-15 21:03:25 dom Exp $
;

    MODULE  cpc_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  __Exit         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


IF DEFINED_CLIB_DEFAULT_SCREEN_MODE
    IF CLIB_DEFAULT_SCREEN_MODE = 0
        defc    CONSOLE_COLUMNS = 20
    ELIF CLIB_DEFAULT_SCREEN_MODE = 1
        defc    CONSOLE_COLUMNS = 40
    ELIF CLIB_DEFAULT_SCREEN_MODE = 2
        defc    CONSOLE_COLUMNS = 80
    ENDIF
ELSE
    defc    CONSOLE_COLUMNS = 40
ENDIF
    defc    CONSOLE_ROWS = 25

IF !DEFINED_CRT_DISABLE_FIRMWARE_ISR
    defc CRT_DISABLE_FIRMWARE_ISR = 0
ENDIF

IF CRT_DISABLE_FIRMWARE_ISR = 0
    PUBLIC CRT_EVENT_BLOCKS
    PUBLIC CRT_EVENT_BLOCKS_NUM

    ; 8 slots of 16 bytes = 128
    defc CRT_EVENT_BLOCKS = 0xa600
    defc CRT_EVENT_BLOCKS_NUM = 8
ENDIF


IF !DEFINED_CRT_MAX_HEAP_ADDRESS
    defc    CRT_MAX_HEAP_ADDRESS = 0xa600
ENDIF

    ; Floating point accumulator needs to be in middle 32k
    PUBLIC  fa
    defc    fa = 0xa680


    PUBLIC  cpc_enable_fw_exx_set       ;needed by firmware interposer
    PUBLIC  cpc_enable_process_exx_set  ;needed by firmware interposer

    GLOBAL  __interposer_isr__

    defc    TAR__no_ansifont = 1
    defc    TAR__register_sp = -1
    defc    TAR__clib_exit_stack_size = 8
    defc    TAR__clib_banking_stack_size = 16
    defc    TAR__crt_enable_eidi = $02  ; ei on startup
    defc    CRT_KEY_DEL = 12
    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"

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
    ld      hl,($be7d)
    ld      a,(hl)
    ld      (drive+1),a

;;------------------------------------------------------------------------
    ld      c,$ff               ;; disable all roms
    ld      hl,start2           ;; execution address for program
    call    mc_start_program    ;; start it

;;------------------------------------------------------------------------

.start2
    call    kl_rom_walk         ;; enable all roms 

;;------------------------------------------------------------------------
;; when AMSDOS is enabled, the drive reverts back to drive 0!
;; This will restore the drive number to the drive the loader was run from
.drive
    ld      a,0
    ld      hl,($be7d)
    ld      (hl),a

IF !DEFINED_CRT_DISABLELOADER
    call    loadbanks
ENDIF

    di
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"


    ; enable process exx set
    ; install interrupt interposer
    call    cpc_enable_process_exx_set

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

IF DEFINED_CLIB_DEFAULT_SCREEN_MODE
    ld      a,CLIB_DEFAULT_SCREEN_MODE
    call    cpc_setmode
ENDIF

    call    _main

__Exit:
    call    crt0_exit
IF CLIB_EXIT_SCREEN_MODE != -1
    ld      a,CLIB_EXIT_SCREEN_MODE
    call    cpc_setmode
ENDIF

    di
    call    cpc_enable_fw_exx_set
__restore_sp_onexit:
    ld      sp,0
    ei
    ret

l_dcal: 
    jp      (hl)


; These subroutines make it possible to coexist with the firmware.
; Interrupts must be disabled while these routines run.

cpc_enable_fw_exx_set:

    exx
    ex      af,af'

    ld      (__process_exx_set_hl__),hl      ; save process exx set
    ld      (__process_exx_set_de__),de
    ld      (__process_exx_set_bc__),bc
    push    af
    pop     hl
    ld      (__process_exx_set_af__),hl
   
IF startup != 2
  IF CRT_DISABLE_FIRMWARE_ISR = 0
    ld      hl,(__fw_int_address__)
    ld      (0x0039),hl                      ; restore firmware isr
  ELSE
    ld      hl,$c9fb                         ; ei ret
    ld      (0x0038),hl
  ENDIF
ENDIF
   
    ld      bc,(__fw_exx_set_bc__)           ; restore firmware exx set
    or      a

    ex      af,af'
    exx

    ret

cpc_enable_process_exx_set:

    exx
    ex      af,af'

    ld      (__fw_exx_set_bc__),bc           ; save firmware exx set

IF startup != 2
  IF CRT_DISABLE_FIRMWARE_ISR = 0
    ld      hl,(0x0039)
    ld      (__fw_int_address__),hl          ; save firmware interrupt entry
  ELSE
    ld      a,195                            ; jp
    ld      (0x0038),a
  ENDIF
    ld      hl,__interposer_isr__
    ld      (0x0039),hl                      ; interposer receives interrupts
ENDIF

    ld      hl,(__process_exx_set_af__)      ; restore process exx set
    push    hl
    pop     af
    ld      bc,(__process_exx_set_bc__)
    ld      de,(__process_exx_set_de__)
    ld      hl,(__process_exx_set_hl__)

    ex      af,af'
    exx

    ret

IF startup != 2
   PUBLIC  cpc_add_vsync_isr
   PUBLIC  _cpc_add_vsync_isr
   PUBLIC  cpc_add_fast_isr
   PUBLIC  _cpc_add_fast_isr

__interposer_isr__:
IF CRT_DISABLE_FIRMWARE_ISR = 0
   EXTERN __fw_add_vsync_isr
   EXTERN __fw_del_vsync_isr
   EXTERN __fw_add_fast_isr
   EXTERN __fw_del_fast_isr
   
   defc cpc_add_vsync_isr = __fw_add_vsync_isr
   defc _cpc_add_vsync_isr = cpc_add_vsync_isr
   defc cpc_del_vsync_isr = __fw_del_vsync_isr
   defc _cpc_del_vsync_isr = cpc_del_vsync_isr

   defc cpc_add_fast_isr = __fw_add_fast_isr
   defc _cpc_add_fast_isr = cpc_add_fast_isr
   defc cpc_del_fast_isr = __fw_del_fast_isr
   defc _cpc_del_sfastisr = cpc_del_fast_isr

   call cpc_enable_fw_exx_set
   call 0x0038
   di
   call cpc_enable_process_exx_set
   ei
   ret
ELSE
   EXTERN im1_vectors
   EXTERN fast_vectors
   EXTERN im1_install_isr
   EXTERN im1_uninstall_isr
   EXTERN __add_fast_isr
   EXTERN __del_fast_isr
   EXTERN asm_interrupt_handler

   defc cpc_add_vsync_isr = im1_install_isr
   defc _cpc_add_vsync_isr = cpc_add_vsync_isr
   defc cpc_del_vsync_isr = im1_uninstall_isr
   defc _cpc_del_vsync_isr = cpc_del_vsync_isr

   defc cpc_add_fast_isr = __add_fast_isr
   defc _cpc_add_fast_isr = cpc_add_fast_isr
   defc cpc_del_fast_isr = __del_fast_isr
   defc _cpc_del_sfastisr = cpc_del_fast_isr

   push    af
   push    hl
   push    bc
   ld      hl,im1_vectors
   ; Test for VSYNC
   ld      b,$f5
   in      a,(c)
   rra
   ; Call the raster/VSYNC interrupts
   call    c,asm_interrupt_handler
   ; Call the fast handlers
   ld      hl,fast_vectors
   call    asm_interrupt_handler
no_int:
   pop     bc
   pop     hl
   pop     af
   ei
   ret
ENDIF

ENDIF

IF !DEFINED_CRT_DISABLELOADER
loadbanks:
    INCLUDE "target/cpc/classic/loader.asm"
ENDIF


    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE "crt/classic/crt_section.inc" 

    SECTION code_crt_init
    ld      hl,$c000
    ld      (base_graphics),hl

    SECTION	bss_crt
__fw_exx_set_bc__:        defs 2
__process_exx_set_af__:   defs 2
__process_exx_set_bc__:   defs 2
__process_exx_set_de__:   defs 2
__process_exx_set_hl__:   defs 2
__fw_int_address__:       defs 2

IF CRT_DISABLE_FIRMWARE_ISR = 0
    SECTION     data_crt
__im_counter:             defb 6
ENDIF


IF __MMAP != -1
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Define Memory Banks
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    IFNDEF CRT_ORG_BANK_0
        defc CRT_ORG_BANK_0 = 0x0000
    ENDIF

    IFNDEF CRT_ORG_BANK_1
        defc CRT_ORG_BANK_1 = 0x4000
    ENDIF

    IFNDEF CRT_ORG_BANK_2
        defc CRT_ORG_BANK_2 = 0x8000
    ENDIF

    IFNDEF CRT_ORG_BANK_3
        defc CRT_ORG_BANK_3 = 0xc000
    ENDIF

    IFNDEF CRT_ORG_BANK_4
        defc CRT_ORG_BANK_4 = 0x4000
    ENDIF

    IFNDEF CRT_ORG_BANK_5
        defc CRT_ORG_BANK_5 = 0x4000
    ENDIF

    IFNDEF CRT_ORG_BANK_6
        defc CRT_ORG_BANK_6 = 0x4000
    ENDIF

    IFNDEF CRT_ORG_BANK_7
        defc CRT_ORG_BANK_7 = 0x4000
    ENDIF

    SECTION BANK_0
    org 0xc00000 + CRT_ORG_BANK_0
    SECTION CODE_0
    SECTION RODATA_0
    SECTION DATA_0
    SECTION BSS_0
    SECTION BANK_0_END

    SECTION BANK_1
    org 0xc00000 + CRT_ORG_BANK_1
    SECTION CODE_1
    SECTION RODATA_1
    SECTION DATA_1
    SECTION BSS_1
    SECTION BANK_1_END

    SECTION BANK_2
    org 0xc00000 + CRT_ORG_BANK_2
    SECTION CODE_2
    SECTION RODATA_2
    SECTION DATA_2
    SECTION BSS_2
    SECTION BANK_2_END

    SECTION BANK_3
    org 0xc00000 + CRT_ORG_BANK_3
    SECTION CODE_3
    SECTION RODATA_3
    SECTION DATA_3
    SECTION BSS_3
    SECTION BANK_3_END

    SECTION BANK_4
    org 0xc40000 + CRT_ORG_BANK_4
    SECTION CODE_4
    SECTION RODATA_4
    SECTION DATA_4
    SECTION BSS_4
    SECTION BANK_4_END

    SECTION BANK_5
    org 0xc50000 + CRT_ORG_BANK_5
    SECTION CODE_5
    SECTION RODATA_5
    SECTION DATA_5
    SECTION BSS_5
    SECTION BANK_5_END

    SECTION BANK_6
    org 0xc60000 + CRT_ORG_BANK_6
    SECTION CODE_6
    SECTION RODATA_6
    SECTION DATA_6
    SECTION BSS_6
    SECTION BANK_6_END

    SECTION BANK_7
    org 0xc70000 + CRT_ORG_BANK_7
    SECTION CODE_7
    SECTION RODATA_7
    SECTION DATA_7
    SECTION BSS_7
    SECTION BANK_7_END
ENDIF
