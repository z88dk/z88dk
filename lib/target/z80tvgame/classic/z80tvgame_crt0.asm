;
;   Z80 TV Game


    MODULE  z80tvgame_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit         ; jp'd to by exit()
    PUBLIC    l_dcal          ; jp(hl)




    defc    CRT_ORG_CODE = 0x0000
    defc    CRT_ORG_BSS = 0x8000

    defc    CONSOLE_ROWS = 26
    defc    CONSOLE_COLUMNS = 21

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xc000
    defc	__CPU_CLOCK = 4000000

    defc TAR__crt_enable_rst = $8080
    EXTERN asm_im1_handler
    defc _z80_rst_38h = asm_im1_handler

    defc    TAR__crt_on_exit = 0            ;Jump to 0 at finish
    defc    TAR__crt_enable_eidi = $02      ;Enable ei on startup 


    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif

    jp      start 
    INCLUDE	"crt/classic/crt_z80_rsts.inc"

start:
    di
    INCLUDE "crt/classic/crt_init_sp.inc"
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call	crt0_init
    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ld      a, $90              ; Does this system have an 8255 or a Z80 PIO?
    out     ($03), a            ; $90 to Port $03 - 8255 control register and PIO port.
                                ;   $02 control register.

    ; If this is an 8255-based system, the control register has now been properly
    ;   set.
    ;
    ;  1 - Mode Set Flag Active          (Bit 7)
    ;  0 - \__ Group A Mode = 0          (Bit 6)
    ;  0 - /                             (Bit 5)
    ;  1 - Port A = Input ($00)          (Bit 4)
    ;  0 - Port C (Upper) = Output ($02) (Bit 3)
    ;  0 - Group B Mode = 0              (Bit 2)
    ;  0 - Port B = Output ($01)         (Bit 1)
    ;  0 - Port C (Lower) = Output ($02) (Bit 0)

    ld      a, $aa              ; $AA to Port $01 - 8255 unused output port and PIO
    out     ($01), a            ;   port $00 ctrl. register.

    in      a, ($01)            ; Query for input from $01.
    cp      $aa                 ; An 8255 will return the value in its port $01
                                ;   register, while a Z80PIO will return some other
                                ;   value. Unfortunately there isn't much
                                ;   documentation on this particular functionality of
                                ;   the Z80PIO, so I don't know exactly what value it
                                ;   returns.
    jr      z, Test8255         ; If the returned value is not $AA, continue to the
                                ;   Z80PIO initialization routine. Otherwise, jump
                                ;   forward to a second test to make sure this is an
                                ;   8255-based system.

StartupPIO:                     ; Initialize Z80PIO. This code will only be run if the
                                ;   system is a Z80PIO-based Z80TVG or a Z80TVG2.
    ld      a, $4f              ;
    out     ($01), a            ; $4F to Port $01 - PIO control port for port $00.
    ld      a, $0f              ;
    out     ($03), a            ; $0F to Port $03 - PIO control port for port $00.
    jr      EndStartup          ; Jump to the end of this startup routine.

  ; If this is an PIO-based system, the control register has now been properly
  ;   set.
  ;
  ; Port $01 (control register for port $00):
  ;  0 - \__ Input Mode
  ;  1 - /
  ;  0 - (unused)
  ;  0 - (unused)
  ;  1 - \
  ;  1 -  \__ Signifies that the operating
  ;  1 -  /   mode is being set
  ;  1 - /
  ;
  ; Port $03 (control register for port $02):
  ;  0 - \__ Output Mode
  ;  0 - /
  ;  0 - (unused)
  ;  0 - (unused)
  ;  1 - \
  ;  1 -  \__ Signifies that the operating
  ;  1 -  /   mode is being set
  ;  1 - /

Test8255:
    ld      a, $55              ; Send some data to Port $01.
    out     ($01), a            ;
    in      a, ($01)            ; Try receiving data from the same port.
    cp      $55                 ; An 8255 will return the value in its port $01
                                ;   register, while a Z80PIO will return some other
                                ;   value. Unfortunately there isn't much
                                ;   documentation on this particular functionality of
                                ;   the Z80PIO, so I don't know exactly what value it
                                ;   returns.
    jr      nz, StartupPIO      ; If the returned value is not $55, jump to the Z80PIO
                                ;   initialization routine. Otherwise, continue
                                ;   onward.
EndStartup:





    call    _main           ; Call user program
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal: 
    jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.inc"

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE "crt/classic/crt_section.inc"



