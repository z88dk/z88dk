IF __register_sp < -1
   IF __CPU_INTEL__
     ld hl,(-__register_sp)      ; stack location is stored at memory address
     ld sp,hl
   ELSE
     ld sp,(-__register_sp)      ; stack location is stored at memory address
   ENDIF
ELSE

   IF __register_sp != -1
   
      ld sp,__register_sp      ; stack is at fixed address

   ENDIF

ENDIF
