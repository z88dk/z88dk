;
;       Keyboard routines for the Commodore 128 (Z80 mode)
;       By Stefano Bodrato - 27/08/2001
;
;       getk() Read key status
;
;       $Id: getk.asm,v 1.6 2016-06-12 17:07:43 dom Exp $
;


        SECTION code_clib
                PUBLIC    getk
                PUBLIC    _getk
                
                EXTERN	savecia
                EXTERN	restorecia

.getk
._getk
        call    savecia         ; save CIA registers

        ld      hl,keytab
        ld      de,8
        ld      a,@01111111
        ld      bc,$dc00
.kloop1
        out     (c),a
        ld      e,a
        inc     bc
        in      a,(c)
        dec     bc
        cp      255
        jr      nz,scanline
        ld      a,e
        rrca
        jr      nc,nokey
        ld      e,8
        add     hl,de
        jr      kloop1
.scanline
        rla
        jr      nc,readtab
        inc     hl
        jr      scanline
.readtab
        ld      a,(hl)
        jr      done

.nokey
        xor     a

.done
        push    af

        call    restorecia      ; restore CIA registers

        pop     af
        ld      h,0
        ld      l,a
        ret

.keytab
defb      3,'Q','c',' ','2','c','a','1'
defb    '/','^','=','r','h',';','*','_'
defb    ',','@',':','.','-','L','P','+'
defb    'N','O','K','M','0','J','I','9'
defb    'V','U','H','B','8','G','Y','7'
defb    'X','T','F','C','6','D','R','5'
defb    'l','E','S','Z','4','A','W','3'
defb    '_','5','3','1','7','_', 13, 12

