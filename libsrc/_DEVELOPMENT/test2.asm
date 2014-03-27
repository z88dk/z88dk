
; z80asm -b -i=zx_asm.lib test2.asm

LIB asm_zx_border, asm_memset, asm_zx_pattern_fill, l_inc_dehl
LIB asm_fzx_mode, asm_fzx_setat, asm_fzx_puts, asm_strcpy, asm_sprintf

LIB _ff_ao_Klausjahn, _ff_ao_SoixanteQuatre

XREF fzx_mode_or, fzx_mode_xor, fzx_mode_reset

   org 32768

main:

   di
   
   ; clear screen
   
   ld hl,1
   call asm_zx_border
   
   ld e,0
   ld hl,$4000
   ld bc,6144
   call asm_memset
   
   ld e,48                     ; black on yellow
   ld hl,$5800
   ld bc,768
   call asm_memset
   
   ; fill screen with pattern
   
   ld l,127                    ; x = 127
   ld h,10                     ; y = 10
   ld de,hash                  ; pattern
   ld bc,300                   ; allowed stack depth
   call asm_zx_pattern_fill
   
   ; clear bottom third of screen
   
   ld e,0
   ld hl,$4000+2048+2048
   ld bc,2048
   call asm_memset
   
   ; select font
   
   ld hl,_ff_ao_Klausjahn
   ld (_fzx+0),hl

   ; hello world OR mode
   
   ld hl,fzx_mode_or
   call asm_fzx_mode           ; or is also the default
   
   ld hl,5*256+10              ; x = 10, y = 5
   call asm_fzx_setat
   
   ld hl,hello_world
   call asm_fzx_puts

   ; hello world XOR mode
   
   ld hl,fzx_mode_xor
   call asm_fzx_mode
   
   ld hl,25*256+10             ; x = 10, y = 20
   call asm_fzx_setat
   
   ld hl,hello_world
   call asm_fzx_puts
   
   ; hello world RESET mode
   
   ld hl,fzx_mode_reset
   call asm_fzx_mode
   
   ld hl,45*256+10             ; x = 10, y = 35
   call asm_fzx_setat
   
   ld hl,hello_world
   call asm_fzx_puts
   
   ; hello world outlined
   
   ld hl,fzx_mode_reset        ; we're actually still in reset mode
   call asm_fzx_mode
   
   ld hl,65*256+9              ; x = 9, y = 50
   call asm_fzx_setat
   
   ld hl,hello_world
   call asm_fzx_puts
   
   ld hl,65*256+11             ; x = 11, y = 50
   call asm_fzx_setat
   
   ld hl,hello_world
   call asm_fzx_puts
   
   ld hl,fzx_mode_or
   call asm_fzx_mode
   
   ld hl,65*256+10             ; x = 10, y = 50
   call asm_fzx_setat
   
   ld hl,hello_world
   call asm_fzx_puts
   
   ; let's see how bad the flickering is in xor mode
   
   ld hl,_ff_ao_SoixanteQuatre
   ld (_fzx+0),hl

   ld hl,fzx_mode_xor
   call asm_fzx_mode

   ld de,0
   ld hl,0                     ; count = 0
   
loop:

   ; create next text string
   
   ld bc,buffer
   push bc
   
   ld bc,format
   push bc
   
   push de
   push hl
   
   push de
   push hl
   
   push de
   push hl
   
   push de
   push hl
      
   ld a,10                     ; number of pushes
   call asm_sprintf
   
   pop bc
   pop de                      ; debc = count
      
   ld hl,16
   add hl,sp
   ld sp,hl
   
   ld l,c
   ld h,b                      ; dehl = count
   
   call l_inc_dehl
   
   push de
   push hl
   
   ; erase old string
   
   ld de,buffer2
   call print_string
   
   ; print new string
   
   ld de,buffer
   call print_string
   
   ; copy new buffer to old buffer
   
   ld hl,buffer
   ld de,buffer2
   call asm_strcpy
   
   pop hl
   pop de
   
   jr loop

print_string:

   ld hl,17*8*256
   call asm_fzx_setat
   
   ex de,hl
   call asm_fzx_puts
   
   ret

XDEF _fzx

_fzx:

   defw 0
   defb 0,0,0,0

hello_world:

   defm "Hello World! 0123456789"
   defb 13,0

buffer:

   defs 200
   defb 0

buffer2:

   defb 0
   defs 200

XDEF __seed

__seed:

   defw 1,1

format:

   defm "I like to count in decimal %010ld, hex %08lx,"
   defb 13
   defm "octal %011lo and binary %032lB"
   defb 0

hash:

   defb $aa, $55, $aa, $55, $aa, $55, $aa, $55

XDEF _errno

_errno:

   defw 0
   
XDEF __EINVAL, __ERANGE, __EDOM, __EACCES, __ENOMEM
defgroup
{
   __EOK = 0,
   __EDOM,
   __EINVAL,
   __ENOMEM,
   __ERANGE,
   __EACCES,
   __ENOLCK,
   __EOVERFLOW,
   __ENOTSUP,
   __EFBIG,
   __EBADF,
   __EUNKWN
}

XDEF STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_SEEK, STDIO_MSG_FLSH
XDEF STDIO_SEEK_CUR

defc STDIO_MSG_PUTC = 1
defc STDIO_MSG_WRIT = 2
defc STDIO_MSG_SEEK = 3
defc STDIO_MSG_FLSH = 4
defc STDIO_SEEK_CUR = 0

XDEF asm__fflushall

asm__fflushall:

   ret
