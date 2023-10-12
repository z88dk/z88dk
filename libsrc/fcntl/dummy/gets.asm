;
;	New stdio functions for Small C+
;
;	gets(char *s) - get string from console
;
;
;	$Id: gets.asm $
;

        MODULE  gets
        SECTION code_clib
        PUBLIC  gets
        PUBLIC  _gets
        PUBLIC  cgets
        PUBLIC  _cgets
        EXTERN  fgets_cons
        EXTERN  asm_strlen

        defc    cgets=gets
        defc    _cgets=gets

; gets(char *s)
gets:
_gets:
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    hl                      ;str
        ld      bc, 65535
        push    bc                      ;length
        call    fgets_cons
        pop     bc                      ;length
        pop     hl                      ;str
        push    hl
        call    asm_strlen
        pop     de                      ;str
        jr      z, just_return
        add     hl, de
        dec     hl
        ld      a, (hl)
        cp      10
        jr      z, kill_eol
        cp      13
        jr      nz, just_return
kill_eol:
        ld      (hl), 0
just_return:
        ex      de, hl
        ret

