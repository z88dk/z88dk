IF __register_sp < -1

   ld sp,(-__register_sp)      ; stack location is stored at memory address

ELSE

   IF __register_sp != -1
   
      ld sp,__register_sp      ; stack is at fixed address

   ENDIF

ENDIF
