;       Startup for Sanyo PHC-25
;



    MODULE  phc25_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

    EXTERN      asm_im1_handler


IFNDEF CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $c009	 ; RAM
ENDIF

    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 16
    defc    CRT_KEY_DEL = 12
    defc    CLIB_FGETC_CONS_DELAY = 100
    defc    DEFINED_ansicolumns = 1
    defc    ansicolumns = 32

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xfdfd       ;Must be below interrupt table
    defc    TAR__crt_enable_eidi = 2        ;Enable interrupts
    defc	__CPU_CLOCK = 4000000
    INCLUDE	"crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    ; Undo the silly escaping we had to do in appmake
start:
    di
    INCLUDE	"crt/classic/crt_init_sp.inc"
    ld      hl,__phc25_program_entry_point
    ld      de,__phc25_program_entry_point
loop:
    ld      a,(hl)
    inc     hl
    and     a
    jr      z,decompress
    cp      0xff
    jr      nz,copy_byte
    ld      a,(hl)
    inc     hl
copy_byte:
    ld      (de),a
    inc     de
    jr      loop

decompress:

IFNDEF CRT_NO_COMPRESSION
    EXTERN  __tail
    ld      de, __tail + 10
__phc25_compressed_size: 
    ld      bc, 0           ;compressed length
    ld      hl,__phc25_program_entry_point
    push    hl
    add     hl,bc
    dec     hl
    lddr
    inc     de
    ex      de,hl   ;start of compressed data
    pop     de      ;__phc25_program_entry_point
    call    dzx0_standard
    jr      __phc25_program_entry_point

; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas
; "Standard" version (69 bytes only)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx0_standard:
        ld      bc, $ffff               ; preserve default offset 1
        push    bc
        inc     bc
        ld      a, $80
dzx0s_literals:
        call    dzx0s_elias             ; obtain length
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0s_new_offset
        call    dzx0s_elias             ; obtain length
dzx0s_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0s_literals
dzx0s_new_offset:
        call    dzx0s_elias             ; obtain offset MSB
        ex      af, af'
        pop     af                      ; discard last offset
        xor     a                       ; adjust for negative offset
        sub     c
        ret     z                       ; check end marker
        ld      b, a
        ex      af, af'
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        push    bc                      ; preserve new offset
        ld      bc, 1                   ; obtain length
        call    nc, dzx0s_elias_backtrack
        inc     bc
        jr      dzx0s_copy
dzx0s_elias:
        inc     c                       ; interlaced Elias gamma coding
dzx0s_elias_loop:
        add     a, a
        jr      nz, dzx0s_elias_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx0s_elias_skip:
        ret     c
dzx0s_elias_backtrack:
        add     a, a
        rl      c
        rl      b
        jr      dzx0s_elias_loop
; -----------------------------------------------------------------------------
ENDIF

__phc25_program_entry_point:
    call	crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

IF (__crt_enable_eidi & 0x02)
    ; Setup im2 since im1 is broken for our purposes
    ld      de,$fe00        ;im table
    ld      hl,$fdfd        ;jump address
    ld      a,d
    ld      i,a
    ld      a,h
imloop:
    ld      (de),a
    inc     e
    jr      nz,imloop
    inc     d
    ld      (de),a
    ld      (hl),0xc3
    inc     hl
    ld      de,asm_im1_handler
    ld      (hl),e
    inc     l
    ld      (hl),d
    im      2
ENDIF
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main
__Exit:
    call    crt0_exit

    ; We've probably broken all the basic variables, just restart if we get here
    rst 0
    
noop:
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE	"crt/classic/crt_section.inc"



    INCLUDE  "crt/classic/mc6847/mc6847_mode_disable.inc"
