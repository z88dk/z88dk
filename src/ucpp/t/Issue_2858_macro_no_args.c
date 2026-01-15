#define STDIO_ASM
#define malloc(a) mymalloc(a)

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

#endasm
