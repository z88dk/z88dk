/*
 *  z88dk z80 multi-task library
 *
 *  $Id: get_task.c,v 1.2 2009-09-30 23:03:02 dom Exp $
 */
 
 #include <threading/preempt.h>
 
 #asm

 
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
