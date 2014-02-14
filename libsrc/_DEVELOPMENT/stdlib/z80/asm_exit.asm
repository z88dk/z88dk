
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

XLIB asm_exit
XDEF asm0_exit

LIB _Exit, l_jphl

asm_exit:

   ; enter : hl = status
   
   ld de,__exit_stack

asm0_exit:

   ld a,(de)                   ; number of registered functions
   or a
   jp z, _Exit
   
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
   jp _Exit
