; void __FASTCALL__ t_delay(unsigned int tstates)

SECTION code_clib
PUBLIC t_delay
PUBLIC _t_delay

; Z80 delay routine
; by Jan Bobrowski, license GPL
; wait hl T (including call; hl>=141)
; destroys: af, bc, hl

.t_delay
._t_delay

        ld      bc,-141
        add     hl,bc
        ld      bc,-23
        
.loop

        add     hl,bc
        jr      c, loop
        
        ld      a,l
        add     a,15
        jr      nc, g0
        
        cp      8
        jr      c, g1
        
        or      0
        
.g0

        inc     hl

.g1

        rra
        jr      c, b0
        nop

.b0

        rra
        jr      nc, b1
        or      0
        
.b1

        rra
        ret     nc
        ret
