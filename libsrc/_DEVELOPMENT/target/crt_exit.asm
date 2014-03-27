
; ISO/IEC 9899:201x
; 5.1.2.2.3 Program termination

; If the return type of the main function is a type compatible with int, a return from the
; initial call to the main function is equivalent to calling the exit function with the value
; returned by the main function as its argument

; ONLY THE EXIT STACK WILL BE EXECUTED ON NORMAL RETURN FROM MAIN

   ; run exit stack

   IF __exit_stack_sz > 0
   
      LIB asm_exit
      
      call asm_exit
   
   ENDIF
