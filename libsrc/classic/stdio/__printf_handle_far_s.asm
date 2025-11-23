IF !__CPU_INTEL__ && !__CPU_GBZ80__
    MODULE  __printf_handle_far_s
    SECTION code_clib
    PUBLIC  __printf_handle_far_s
    PUBLIC  __printf_pickup_far

    EXTERN  __printf_loop
    EXTERN  __printf_print_aligned
    EXTERN  get_32bit_ap_parameter
    EXTERN  asm_strlen
    EXTERN  l_uge

    EXTERN  __far_start
    EXTERN  __far_end
    EXTERN  strlenf

    EXTERN  __printf_get_precision
    EXTERN  __far_page
    EXTERN  l_far_incptrs


__printf_handle_far_s:
    push    hl              ;save format string
    call    get_32bit_ap_parameter  ;deba = parameter, hl = new ap
    push    hl              ;save ap
    ld      c,a
    or      b
    or      e
    jr      nz, printstr
    ld      bc,nullstr
printstr:
    set     7,(ix-4)        ;Indicate that we've got a far string to print
    push    de
    push    bc              ;save string
    call    strlenf         ;exits hl = length
    ex      de,hl           ;de=length
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_get_precision
ELSE
    ld      l,(ix-8)	;precision
    ld      h,(ix-7)
ENDIF
    push    hl
    call    l_uge		;disturbs hl, bc
    pop     hl
    jr      nc,use_strlen	;precision > asm_strlen, use asm_strlen
    ex      de,hl           ;de = precision
use_strlen:
    pop     bc
    pop     hl          ;lbc = far pointer
    push    de          ;length
    ld      e,l         ;ebc = far pointer
    exx
    pop     de          ;length
    call    __far_start
    push    af
    ex      af,af
    call    __printf_print_aligned
    pop     af
    call    __far_end
printstr_end:
    pop     de              ;ap
    pop     hl              ;fmt
    jp      __printf_loop

    SECTION code_far

    ; See the note in __printf_0_early_overrides.asm
__printf_pickup_far:
    exx
    call    __far_page
    ld      a,(hl)
    call    l_far_incptrs
    exx
    ret

    SECTION	rodata_clib
nullstr:
    defm    "(null)"	
    defb    0
ENDIF