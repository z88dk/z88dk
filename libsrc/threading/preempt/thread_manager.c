/*
 *  z88dk z80 multi-task library
 *
 * $Id: thread_manager.c,v 1.4 2015-01-21 17:49:59 stefano Exp $
 */
 

#include <threading/preempt.h>


void thread_manager()
{
#asm
	PUBLIC	thread_manager_first_entry
          push  af            ; Preserve register on process stack
          push  bc  
          push  de  
          push  hl  
          push  ix  
          ex    af,af  
          exx   
          push  af  
          push  bc  
          push  de  
          push  hl  
          push  iy  
;Save the process stack
.thread_manager_first_entry
          ld    hl,0  
          add   hl,sp  
          ld    ix,(_threadbase + current)      ; Pick up the current thread
          ld    (ix + thread_sp),l              ; Save the stack pointer
          ld    (ix + thread_sp + 1),h
          ld    hl,(_threadbase + task_save_func)    ; See if there is an OS specific saving to do
          ld    a,h
          or    l
          call  nz,l_jphl
      
          ld    sp,_threadbase + temp_sp
          ld    hl,(_threadbase + generic_func)
          ld    a,h
          or    l
          call  nz,l_jphl
          ld    hl,(_threadbase + scheduler) ; We can insert in different scheduler methods
          call  l_jphl                          ; Exits with ix holding the new task
          ld    (_threadbase + current),ix      ; Save this new task
          ld    hl,(_threadbase + task_restore_func) ; See if there is an platform specific restoration to do
          ld    a,h
          or    l
          call  nz,l_jphl
.have_task
          ld    l,(ix + thread_sp)              ; Get the stack back and start it running
          ld    h,(ix + thread_sp + 1)
          ld    sp,hl  
          pop   iy  
          pop   hl  
          pop   de  
          pop   bc  
          pop   af  
          ex    af,af  
          exx   
          pop   ix  
          pop   hl  
          pop   de  
          pop   bc  
          pop   af  
          ei    
          reti
#endasm     
}
