/*
 *  z88dk z80 multi-task library
 *
 * $Id: thread_exit.c,v 1.1 2009-09-29 21:39:37 dom Exp $
 */
 
#include <threading/preempt.h>
 
 
void thread_exit()
{
#asm
   ld          ix,(_threadbase + current)
   bit	       2,(ix+thread_flags)
   ret         nz		; System threads cannot exit
   di
   res         7,(ix+thread_flags)      ; Thread no available
   ei				; Enable
   halt				; We should no longer exist
#endasm
}
