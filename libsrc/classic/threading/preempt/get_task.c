/*
 *  z88dk z80 multi-task library
 *
 *  $Id: get_task.c,v 1.3 2016-04-25 17:33:05 dom Exp $
 */
 
 #include <threading/preempt.h>
 
 #asm
		SECTION  code_clib
		PUBLIC   get_task
 
 ; Entry:       a = task number
 ; Exit        ix = Task table for specified task
 ;              a = task number
 ;
 ; Uses:   b,d,e
 .get_task
            ld          ix,_threadbase + threads - THREAD_SIZE 
            ld          de,THREAD_SIZE 
            ld          b,a
            inc         b
 .get_task_loop
            add         ix,de
            djnz        get_task_loop
            ret
#endasm
