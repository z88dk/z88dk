;	Startup for dot commands
;

    INCLUDE	"target/zx/def/esxdos.def"

    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__register_sp = -1

IF !DEFINED_CRT_COMMANDLINE_REDIRECTION
    define  DEFINED_CRT_COMMANDLINE_REDIRECTION
    defc    CRT_COMMANDLINE_REDIRECTION = 0
ENDIF

    INCLUDE "crt/classic/crt_rules.inc"

IF      !DEFINED_CRT_ORG_CODE
    defc CRT_ORG_CODE = 0x2000
ENDIF

    SECTION CODE
    org     CRT_ORG_CODE

program:
    ld      l,c		;Get arguments
    ld      h,b
    push    iy
    exx
    push    hl
    ld      (__sp),sp

    ; Check for ESXDOS/NextOS
    rst     __ESX_RST_SYS
    defb    __ESX_M_DOSVERSION
IF __ESXDOS_VERSION
    ld      hl,error_msg_esxdos
    jp      nc, error_crt         ; if esxdos not present
ELSE
    ld      hl,error_msg_nextos
    jp      c,error_crt
    IF __NEXTOS_VERSION > 0
         ld hl,+(((__NEXTOS_VERSION / 1000) % 10) << 12) + (((__NEXTOS_VERSION / 100) % 10) << 8) + (((__NEXTOS_VERSION / 10) % 10
) << 4) + (__NEXTOS_VERSION % 10)

         ex de,hl
         sbc hl,de

         ld hl,error_msg_nextos
         jp c, error_crt       ; if nextos version not met
    ENDIF
ENDIF

    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss


IF DEFINED_USING_amalloc
;    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    exx
    ex      de,hl
    ld      hl,-128		;Copy argument to stack, max length is 128 characters
    add     hl,sp
    ld      sp,hl
    ex      de,hl
    ld      bc,128
    ldir
    ld      hl,0
    add     hl,sp
    ; (terminated by $00, $0d or ':').
    ld      bc,$7f00
find_argument_end:
    ld      a,(hl)
    and     a
    jr      z,found_end
    cp      $0d
    jr      z,found_end
    cp      ':'
    jr      z,found_end
    inc     hl
    inc     c
    djnz    find_argument_end
found_end:
    ld      (hl),0
    ld      b,0
    ; hl = argument ends
    ;  c = length, b = 0
    INCLUDE "crt/classic/crt_command_line.asm"

    push    hl	;argv
    push    bc	;argc
    call    _main
    pop     bc
    pop     bc
cleanup:
    push    hl
    call    crt0_exit
    pop     hl
error_crt:
    ld      sp,(__sp)
    exx
    pop     hl
    exx	
    pop     iy
   ; If you exit with carry set and A<>0, the corresponding error code will be printed in BASIC.
   ; If carry set and A=0, HL should be pointing to a custom error message (with last char +$80 as END marker).
   ; If carry reset, exit cleanly to BASIC

    ld      a,h
    or      l
    ret     z                       ; status == 0, no error
    scf
    ld      a,l

    inc     h
    dec     h
    ret     z                       ; status < 256, basic error code in status&0xff
    ld      a,0                      ; status = & custom error message
    ret

__sp:   defw	0

l_dcal: jp      (hl)            ;Used for function pointer calls

call_rom3:
    exx                      ; Use alternate registers
    ex      (sp),hl          ; get return address
    ld      c,(hl)
    inc     hl
    ld      b,(hl)           ; BC=BASIC address
    inc     hl
    ex      (sp),hl          ; restore return address
    ld	    (restart_address),bc
    exx                      ; Back to the regular set
    rst     $18
restart_address:
    defw    0
    ret

IF __ESXDOS_VERSION
error_msg_esxdos:
    defm "Requires ESXDO", 'S' + 0x80
ELSE
error_msg_nextos:
    IF __NEXTOS_VERSION > 0
         defm "Requires NextZXOS "

       IF ((__NEXTOS_VERSION / 1000) % 10)
         defb (__NEXTOS_VERSION / 1000) % 10 + '0'
       ENDIF

         defb (__NEXTOS_VERSION / 100) % 10 + '0'
         defb '.'
         defb (__NEXTOS_VERSION / 10) % 10 + '0'
         defb __NEXTOS_VERSION % 10 + '0' + 0x80

    ELSE
        defm "Requires NextZXO", 'S'+0x80
    ENDIF
ENDIF

    INCLUDE "target/zxn/classic/memory_map.asm"
    SECTION rodata_clib
end:            defb    0               ; null file name
