
; == crt_exit =================================================

; ISO/IEC 9899:201x
; 5.1.2.2.3 Program termination

; Only the exit stack runs on termination of main()

IF __exit_stack_size > 0
   
   EXTERN asm_exit
   
   jp asm_exit                 ; exit function jumps to __Exit
   
ENDIF

; =============================================================
