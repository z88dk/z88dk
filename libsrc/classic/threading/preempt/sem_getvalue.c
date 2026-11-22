/*
 *  z88dk z80 multi-task library
 *
 * $Id: sem_getvalue.c,v 1.1 2009-09-30 19:06:07 dom Exp $
 */

#include <threading/semaphore.h>


int sem_getvalue(sem_t *sem, int *value)
{
    *value = sem->value;
    return 0;
}
