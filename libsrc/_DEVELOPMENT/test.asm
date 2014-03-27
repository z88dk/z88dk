
; z80asm -b -i=zx_asm.lib test.asm

LIB asm_memset, asm_fzx_puts, asm_rand, asm_sprintf
LIB _ff_ao_KlausJahn, _ff_ao_SoixanteQuatre

   org 32768

main:

   di
   
   ; clear screen
   
   ld e,0
   ld hl,$4000
   ld bc,6144
   call asm_memset
   
   ld e,14                     ; yellow ink on blue paper
   ld hl,$5800
   ld bc,768
   call asm_memset
   
   ; select font
   
   ld hl,_ff_ao_Klausjahn
   ld (_fzx+0),hl
   
   ; hello world

   ld hl,hello_world
   call asm_fzx_puts

   ; random numbers
   
   ld hl,_ff_ao_SoixanteQuatre
   ld (_fzx+0),hl
   
loop:

   ld hl,buffer
   push hl
   ld hl,format
   push hl
   call asm_rand
   push hl
   call asm_rand
   pop de
   push de
   push hl
   push de
   push hl
   push de
   push hl
   push de
   push hl
   push de
   push hl
   
   ld a,12                     ; number of pushes
   call asm_sprintf            ; sprintf(buffer, format, l = rand_32bit(), l, l, l)
   
   ld hl,24
   add hl,sp
   ld sp,hl
   
   ld hl,buffer
   call asm_fzx_puts
   
   jr loop
   
XDEF _fzx

_fzx:

   defw 0
   defb 0,0,0,0

hello_world:

   defm "Hello World!"
   defb 13,0

buffer:

   defs 200
   defb 0

XDEF __seed

__seed:

   defw 1,1

format:

   defm "My IP is '%15I' in hex %#010lX"
   defb 13
   defm "in decimal %ld in octal %#lo"
   defb 13
   defm "in binary %lB"
   defb 13, 13, 0

XDEF _errno

_errno:

   defw 0
   
XDEF __EINVAL, __ERANGE, __EDOM, __EACCES
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

