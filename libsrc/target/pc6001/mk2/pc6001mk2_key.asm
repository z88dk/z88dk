; PC-6001mkII keyboard without the ROM: the boot disc has all RAM, so the ROM's
; keyboard routine ($0FBC, which getk and fgetc_cons call on the PC-6001) is
; not there.  The keyboard is the sub-CPU's: it sends each key as an ASCII code
; (lower case, upper with SHIFT; the cursor keys $1C-$1F) to the 8255's port A
; ($90) with an interrupt whose vector is $02.  So the library runs the Z80 in
; interrupt mode 2 with the vector table the crt has (allrammk2.asm: at a page
; boundary, every entry "ei, reti"), puts its keyboard routine in the entry for
; vector $02, keeps the last code, and leaves interrupts on.  A cartridge
; (-subtype=rom -clib=mk2) keeps the ROM and its keyboard, and this does nothing
; for it.
; pc6001mk2_key_take() returns the code of the last key (0 for none) and forgets
; it; getk and fgetc_cons turn it into the codes the other targets return.
; A program that sets up its own interrupts leaves all of this out
; (-pragma-define:CRT_PC6001MK2_NO_KEYBOARD=1).

    SECTION     code_clib
    PUBLIC      pc6001mk2_key_init
    PUBLIC      _pc6001mk2_key_init
    PUBLIC      pc6001mk2_key_take
    PUBLIC      _pc6001mk2_key_take
    EXTERN      __pc6001mk2_disc
    EXTERN      __pc6001mk2_irq_table

; void pc6001mk2_key_init(void): the keyboard's vector, IM 2, interrupts on.  Run
; before main (code_crt_init below).
pc6001mk2_key_init:
_pc6001mk2_key_init:
    ld          a, __pc6001mk2_disc
    and         a
    ret         z
    di
    ld          hl, key_isr
    ld          (__pc6001mk2_irq_table + 2), hl
    ld          a, __pc6001mk2_irq_table / 256
    ld          i, a
    im          2
    xor         a
    ld          (key_last), a
    ei
    ret

key_isr:
    push        af
    in          a, ($90)
    ld          (key_last), a
    pop         af
    ei
    reti

; int pc6001mk2_key_take(void): the last key's code, 0 if none since the last
; call (z if none)
pc6001mk2_key_take:
_pc6001mk2_key_take:
    di
    ld          a, (key_last)
    ld          l, a
    ld          h, 0
    xor         a
    ld          (key_last), a
    ei
    ld          a, l
    and         a
    ret

    SECTION     code_crt_init
    call        pc6001mk2_key_init

    SECTION     bss_clib
key_last:
    defb        0
