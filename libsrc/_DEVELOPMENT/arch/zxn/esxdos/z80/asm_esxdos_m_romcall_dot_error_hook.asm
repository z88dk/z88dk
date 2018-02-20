; void *esxdos_m_romcall_dot_error_hook(void (*f)(unsigned char error, void *))

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC asm_esxdos_m_romcall_error_hook

asm_esxdos_m_romcall_dot_error_hook:

   ; NextOS only
   
   ; Register an asm function that is called when a basic error
   ; occurs during a rst $10 or rst $18 in a dot command.
   ;
   ; The asm function will get:
   ;
   ;     A = basic error code - 1
   ;    DE = return address after restart with stack properly adjusted
   ;         (you can resume the program if you jump to this address)
   ;
   ; enter : hl = address of function
   ;
   ; uses  : unknown
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst  __ESXDOS_SYSCALL
   defb __ESX_M_ERRH
   
   ret
