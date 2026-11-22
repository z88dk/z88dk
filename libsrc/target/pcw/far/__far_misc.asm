

SECTION code_l_sccz80_far
PUBLIC __far_start
PUBLIC __far_end

PUBLIC __pcw_page2

EXTERN sbrk_far
EXTERN CLIB_PCW_DEFAULT_BANK
EXTERN CLIB_FARHEAP_BANKS

; Get the initial banking setting
; Exit: a = current bank (or entry value for __far_end)
; Uses; none
__far_start:
    ld a,(__pcw_page2)
    ret

; Get the initial banking setting
; Entry: a = bank to page in
; Uses: none
__far_end:
    ld (__pcw_page2),a
    out ($f2),a
    ret

; Allocate some memory for the farheap
__pcw_setup_far_memory:
    ld      a,+(CLIB_FARHEAP_BANKS / 4)
    ld      e,0x0001
    ld      hl,0x0000
    and     a
    jr      z,handle_residual
    ld      b,a
sbrk_loop:
    push    bc
    push    de
    push    hl
    ld      bc,$ffff
    push    bc
    call    sbrk_far
    pop     bc
    pop     hl
    pop     de
    inc     e
    pop     bc      ;Loop count
    djnz    sbrk_loop
handle_residual:
    ld      a,+(CLIB_FARHEAP_BANKS % 4)
    and     a
    ret     z
    ld      bc,$3fff
    cp      1
    jr      z,sbrk_residual
    ld      bc,$7fff
    cp      2
    jr      z,sbrk_residual
    ld      bc,$bfff
sbrk_residual:
    push    de
    push    hl
    push    bc
    call    sbrk_far
    pop     af
    pop     af
    pop     af
    ret


SECTION bss_far

__pcw_page2:
     defb CLIB_PCW_DEFAULT_BANK

SECTION code_crt_init
     call __pcw_setup_far_memory
