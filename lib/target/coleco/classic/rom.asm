;
;        Startup for Colecovision
;
;        1k of memory 

    EXTERN    vdp_set_mode
    EXTERN    asm_im1_handler
    EXTERN    nmi_vectors
    EXTERN    asm_interrupt_handler

IF !DEFINED_CRT_ORG_BSS
    defc    CRT_ORG_BSS = 0x7000        
ENDIF
    defc    CRT_ORG_CODE = 0x8000

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0x7400
    defc        CRT_KEY_DEL = 127

    ;; RAM trimming
IF !DEFINED_CLIB_FOPEN_MAX
    defc    DEFINED_CLIB_FOPEN_MAX = 1
    defc    CLIB_FOPEN_MAX = 3
ENDIF
    defc    DEFINED_basegraphics = 1
IF !DEFINED_CLIB_DEFAULT_SCREEN_MODE
    defc    CLIB_DEFAULT_SCREEN_MODE = 2
ENDIF


    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

    defb    0x55, 0xaa        ;Title screen + 12 second delay, swap to not skip it
IF CRT_COLECO_SPRITE_NAME_SIZE > 0
   defw     _os7_sprite_order_table
ELSE
    defw    0                ;Sprite name table for BIOS
ENDIF
IF CRT_COLECO_SPRITE_ORDER_SIZE > 0
   defw     _os7_sprite_order_table
ELSE
    defw    0                ;Sprite order table for BIOS
ENDIF
IF CRT_COLECO_BIOS_BUFFER_SIZE > 0
   defw     _os7_bios_buffer
ELSE
    defw    0                ;Buffer for BIOS
ENDIF
IF CRT_COLECO_BIOS_CONTROLLER_SIZE > 0
   defw     _os7_bios_controller
ELSE
    defw    0                ;Controller map for bios
ENDIF
    defw    program                ;Where to start execution from
IF ((__crt_enable_rst & $0202) = $0002)
    EXTERN  _z80_rst_08h
    jp      _z80_rst_08h
ELSE
    jp        restart_ret
ENDIF
IF ((__crt_enable_rst & $0404) = $0004)
    EXTERN  _z80_rst_10h
    jp      _z80_rst_10h
ELSE
    jp        restart_ret
ENDIF
IF ((__crt_enable_rst & $0808) = $0008)
    EXTERN  _z80_rst_18h
    jp      _z80_rst_18h
ELSE
    jp        restart_ret
ENDIF
IF ((__crt_enable_rst & $1010) = $0010)
    EXTERN  _z80_rst_20h
    jp      _z80_rst_20h
ELSE
    jp        restart_ret
ENDIF
IF ((__crt_enable_rst & $2020) = $0020)
    EXTERN  _z80_rst_28h
    jp      _z80_rst_28h
ELSE
    jp        restart_ret
ENDIF
IF ((__crt_enable_rst & $4040) = $0040)
    EXTERN  _z80_rst_30h
    jp      _z80_rst_30h
ELSE
    jp        restart_ret
ENDIF
IF ((__crt_enable_rst & $8080) = $0080)
    EXTERN        _z80_rst_38h
    jp      _z80_rst_38h
ELSE
    jp        asm_im1_handler        ;Maskable interrupt
ENDIF
IF (__crt_enable_nmi > 1)
    EXTERN        _z80_nmi
    jp        _z80_nmi
ELSE
    jp        nmi_int                ;NMI
ENDIF
    defm        " / / "                ;TODO: Make it customisable
        

; Restart routines, nothing sorted yet
restart_ret:
    ret

program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp
IF CLIB_DEFAULT_SCREEN_MODE != -1
    ld      hl,CLIB_DEFAULT_SCREEN_MODE
    call    vdp_set_mode
ENDIF
    im      1
    ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    call     _main
cleanup:
    rst     0                ;Restart when main finishes



IF (__crt_enable_nmi <= 1)
nmi_int:
    push    af
    push    hl
    ld      a,(__vdp_enable_status)
    rlca
    jr      c,no_vbl
    in      a,(VDP_STATUS)
    ld      (__tms9918_status_register),a
no_vbl:
    ld      hl,nmi_vectors
    call    asm_interrupt_handler
    pop     hl
    pop     af
    retn
ENDIF


; Safe BIOS call
msxbios:
    push    ix
    ret


l_dcal: 
    jp      (hl)            ;Used for function pointer calls

    ; Point the font to the ROM if not overriden
IFNDEF DEFINED_CRT_FONT
    PUBLIC CRT_FONT
    defc CRT_FONT = 5539
ENDIF


    INCLUDE "crt/classic/crt_runtime_selection.asm" 
    
    defc        __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE        "crt/classic/crt_section.asm"


    SECTION bss_crt

IF CRT_COLECO_SPRITE_NAME_SIZE > 0
    PUBLIC  _os7_sprite_name_table
_os7_sprite_name_table:
    defs    CRT_COLECO_SPRITE_NAME_SIZE
ENDIF
IF CRT_COLECO_SPRITE_ORDER_SIZE > 0
   PUBLIC _os7_sprite_order_table
_os7_sprite_order_table:
   defs     CRT_COLECO_SPRITE_ORDER_SIZE
ENDIF
IF CRT_COLECO_BIOS_BUFFER_SIZE > 0
   PUBLIC _os7_bios_buffer
_os7_bios_buffer:
   defs    CRT_COLECO_BIOS_BUFFER_SIZE
ENDIF
IF CRT_COLECO_BIOS_CONTROLLER_SIZE > 0
   PUBLIC  _os7_bios_controller
_os7_bios_controller:
   defs    CRT_COLECO_BIOS_CONTROLLER_SIZE
ENDIF
