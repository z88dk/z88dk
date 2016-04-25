/*
 *  z88dk z80 multi-task library
 *
 * $Id: thread_create.c,v 1.5 2016-04-25 17:33:05 dom Exp $
 */
 
#include <threading/preempt.h>
 
 
thread_t *thread_create(void (*entry)(), void *stack, int priority)
{
#asm
    push	ix
    di
; sp + 2 = prio
; sp + 4 = stack
; sp + 6 = entry
; Find a free task
    ld          de,THREAD_SIZE 
    ld          a,MAX_THREADS
    ld          b,a
    xor         a
    ld          ix,_threadbase + threads 
.find_task_loop
    bit         7,(ix + thread_flags)
    jr          z,found_slot
    add         ix,de
    inc         a
    djnz        find_task_loop
    ei
    ld          hl,0                    ; No free slots, return
    pop		ix
    ret
.found_slot
    push        ix
    pop         hl
    ld          d,h                     ; Clear the task table down
    ld          e,l
    inc         de
    ld          bc,THREAD_SIZE - 1
    ldir
    ld          (ix+thread_pid),a       ; save thread id
    
    ld          (_threadbase + temp_sp),sp  ; Store our current stack
    ld          hl,4
    add         hl,sp
    ld          a,(hl)                  ; Priority
    ld          (ix + thread_priority),a        
    xor         a
    ld          (ix + thread_nice),a        
    inc         hl
    inc         hl
    ld          e,(hl)			; de = task sp
    inc         hl
    ld          d,(hl)
    inc         hl
    ld          a,(hl)                  ; hl = start address
    inc         hl
    ld          h,(hl)
    ld          l,a
    ex          de,hl
    ld          sp,hl
    ld          b,11                    ; Push required registers (all end up as start addr)
.setup_stack
    push        de
    djnz        setup_stack
    ld          hl,0
    add         hl,sp                   ; hl = task sp
    ld          sp,(_threadbase + temp_sp)       ; Get back callers stack
    ld          (ix + thread_sp), l     ; Save the clients stack pointer
    ld          (ix + thread_sp + 1), h
    set         7,(ix + thread_flags)   ; Thread is there
    ld          hl,(_threadbase + scheduler)
    inc         hl
    inc         hl
    inc         hl
    ld          c,0			; Adjust ment for nice
    call        l_jphl                  ; Initialise the task for the scheduler
    push	ix
    pop		hl
    ei                                  ; Allow manager to carry on
    pop		ix
#endasm          
}
