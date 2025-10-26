/*
 *  z88dk z80 multi-task library
 *
 * $Id: sem_destroy.c,v 1.1 2009-09-30 19:06:07 dom Exp $
 */

#include <threading/semaphore.h>

int sem_destroy(sem_t *sem)
{
    if ( sem->waiters ) {
        return -1;
    }
    return 0;
}
