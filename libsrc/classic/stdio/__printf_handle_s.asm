    MODULE  __printf_handle_s
    SECTION code_clib
    PUBLIC  __printf_handle_s
    EXTERN  __printf_loop
    EXTERN  __printf_print_aligned
    EXTERN  get_16bit_ap_parameter
    EXTERN  asm_strlen
    EXTERN  l_uge

    EXTERN  __printf_get_precision

__printf_handle_s:
    push    hl              ;save format string
    call    get_16bit_ap_parameter  ;de=new ap, hl=string to print
    push    de              ;save ap
    ld      a,h
    or      l
    jr      nz, printstr
    ld      hl,nullstr
printstr:
    push    hl              ;save string
    call    asm_strlen          ;exits hl=length
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
    ex      de,hl 		;de = precision
use_strlen:
    pop     bc              ;get string back
    call    __printf_print_aligned
printstr_end:
    pop     de              ;ap
    pop     hl              ;fmt
    jp      __printf_loop

    SECTION	rodata_clib
nullstr:
    defm    "(null)"	
    defb    0
