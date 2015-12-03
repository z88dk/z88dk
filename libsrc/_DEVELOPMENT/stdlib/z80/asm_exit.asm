
; ===============================================================
; Nov 2013
; ===============================================================
; 
; _Noreturn void exit(int status)
;
; Execute functions registered by atexit() and then exit
; program via _Exit(status).
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_exit
PUBLIC asm0_exit

EXTERN __exit_stack

EXTERN __Exit, l_jphl

asm_exit:

   ; enter : hl = status
   
   ld de,__exit_stack

asm0_exit:

   ld a,(de)                   ; number of registered functions
   or a
   jp z, __Exit
   
   push hl                     ; save status
   
   ld l,a
   ld h,0
   add hl,hl
   add hl,de                   ; hl points to end of function list

   ld b,a                      ; b = num functions > 0

loop:

   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = pointer to function
   dec hl
   
   push bc
   push hl
   ex de,hl
   call l_jphl                 ; (func)(void)
   pop hl
   pop bc
   
   djnz loop

   pop hl                      ; restore status
   jp __Exit
