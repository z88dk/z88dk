
#define STDIO_ASM

#include <stdio.h>
#include <stdlib.h>

#asm
    SECTION code_clib
    PUBLIC    funopen
    PUBLIC    _funopen

; FILE  *funopen(const void    *cookie, int (*readfn)(void *, char *, int),
;     int (*writefn)(void *,    const char *, int),
;     fpos_t    (*seekfn)(void *, fpos_t, int),    int (*closefn)(void *));

DEFVARS 0 {
    fu_readfn        ds.w    1
    fu_writefn        ds.w    1
    fu_seekfn        ds.w    1
    fu_closefn        ds.w    1    
}


funopen:
_funopen:
IF __CPU_INTEL__ | __CPU_GBZ80__
    ld      hl,0
    ret
ELSE
    ; Allocate some memory first of all
    push    ix          ;save callers ix

    ld      ix,4
    add    ix,sp        ;points to closefn

    ld      hl, +(fp_extra + 2) + ( fu_closefn + 2)
    push    hl
    call    malloc
    pop     bc
    push    hl          ;Keep for later
    ld      de,(ix+8)   ;cookie
    ld      (hl),e      ;fp_desc
    inc     hl
    ld      (hl),d
    inc     hl
    ld      (hl),_IOEXTRA|_IOREAD|_IOWRITE
    inc     hl
    ld      (hl),0      ;ungetc
    inc     hl
    ld      de,funopen_trampoline
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      de,(ix + 6) ;readfn
    call    noop_becomes_dummy
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      de,(ix + 4) ;writefn
    call    noop_becomes_dummy
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      de,(ix + 2) ;seekfn
    call    noop_becomes_dummy
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      de,(ix + 0) ;closefn
    call    noop_becomes_dummy
IF __CPU_EZ80__
    ld      (hl),de
ELSE
    ld      (hl),e
    inc     hl
    ld      (hl),d
ENDIF
    pop     hl          ;get fp back
    pop     ix          ;restore callers
    ret
    
noop_becomes_dummy:
    ld      a,d
    or      e
    ret     nz
    ld      de,dummy_func
    ret

dummy_func:
    ld      hl,-1
    ld      d,h
    ld      e,l
    scf
    ret

funopen_trampoline:
    cp      __STDIO_MSG_GETC
    jr      z,handle_getc
    cp      __STDIO_MSG_PUTC
    jr      z,handle_putc
    cp      __STDIO_MSG_READ
    jr      z,handle_read
    cp      __STDIO_MSG_WRITE
    jr      z,handle_write
    cp      __STDIO_MSG_SEEK
    jr      z,handle_seek
    cp      __STDIO_MSG_CLOSE
    jr      z,handle_close
    ld      hl,-1
    ld      d,h
    ld      e,l
    ret



handle_getc:
    push    hl    ; storage space
    ld      hl,0
    add    hl,sp
    ex      de,hl    ;de = buf
    ld      bc,1
    call    handle_read
handle_returncodes:
    pop     bc    ; c = byte read (if any)
    ld      a,h
    or      l
    jr      z,eof
    inc     hl
    ld      a,h
    or      l
    jr      z,error
    ; Successful return, return new character
    ld      l,c
    ld      h,0
    ret
eof:
error:
    scf
    ld      hl,EOF
    ret
    
; Entry: ix = fp
;        bc = character
; Exit: hl = result
handle_putc:
    push    bc
    ld      hl,0
    add     hl,sp
    ex      de,hl
    ld      bc,1
    call    handle_write
    pop     bc    ; byte we wrote
    inc     hl
    ld      a,h
    or      l
    jr      z,eof
    ; Successful return, return character written
    ld      l,c
    ld      h,0
    ret

; ix = fp
; de = buf,
; bc = length
handle_read:
    ld      hl,(ix+fp_desc)
    push    hl
    push    de
    push    bc
    ld      hl,(ix + fp_extra + 2 + fu_readfn)
exec_3args:
    call    l_jphl
    pop     bc
    pop     bc
    pop     bc
    ret

; ix = fp
; de = buf,
; bc = length    
handle_write:
    ld      hl,(ix+fp_desc)
    push    hl
    push    de
    push    bc
    ld      hl,(ix + fp_extra + 2 + fu_writefn)
    jr      exec_3args

handle_close:
    ld      hl,(ix + fp_extra + 2 + fu_closefn)
    ld      bc,(ix + fp_desc)
    push    bc
    call    l_jphl        ; call users close function
    pop     bc
    push    ix
    pop     hl
    call    free        ; and free the descriptor
    pop     bc
    ret


; Entry: ix=fp
; debc=posn
; alt-a = whence
; Exit: dehl = current position or -1
handle_seek:
    ld      hl,(ix+fp_desc)
    push    hl        ;void *
    push    bc        ;posn
    push    de
    ex      af,af
    ld      c,a
    ld      b,0
    push    bc        ;whence
    ld      hl,(ix + fp_extra + 2 + fu_seekfn)
    call    l_jphl
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    ret
ENDIF


            
#endasm

