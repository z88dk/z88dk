/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Paulo Custodio, 2011-2013

Simple classes defined in C with constructor, destructor and copy
constructor defined.
All objects that were not deleted during the program execution
are orderly destroyed at the exit, i.e. by calling the destructor of
each object, which in turn may call destructors of contained objects.

*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/class.c,v 1.2 2013-01-20 21:10:32 pauloscustodio Exp $ */
/* $Log: class.c,v $
/* Revision 1.2  2013-01-20 21:10:32  pauloscustodio
/* Rename bool to BOOL, to be consistent with TRUE and FALSE and
/* distinguish from C++ bool, true, false
/*
/* Revision 1.1  2012/05/24 17:01:45  pauloscustodio
/* CH_0009 : new CLASS to define simple classes
/*
/*
/* */

#include "memalloc.h"   /* before any other include */
#include "class.h"
#include "types.h"
#include "die.h"

/*-----------------------------------------------------------------------------
*   Object register - just the pointers defined by CLASS()
*----------------------------------------------------------------------------*/
CLASS( ObjRegister )
/* no user fields */
END_CLASS;

/* list of all created objects */
typedef LIST_HEAD( ObjRegisterList, ObjRegister ) ObjRegisterList;
static ObjRegisterList objects = LIST_HEAD_INITIALIZER( objects );

/*-----------------------------------------------------------------------------
*   error messages
*----------------------------------------------------------------------------*/
static char msg_init[] = "class: init\n";
static char msg_cleanup[] = "class: cleanup\n";
static char msg_new_class[] = "class %s(%d): new class %s at 0x%p\n";
static char msg_delete_class[] = "class %s(%d): delete class %s at 0x%p created at %s(%d)\n";

/*-----------------------------------------------------------------------------
*   Destruct all objects from the stack, to be called atexit
*----------------------------------------------------------------------------*/
static ObjRegister *next_autodelete( ObjRegisterList *headp )
{
    ObjRegister *obj;

    LIST_FOREACH( obj, headp, _class.entries )
    {
        if ( OBJ_AUTODELETE( obj ) )
        {
            return obj;
        }
    }
    return NULL;
}

static void cleanup( void )
{
    ObjRegister *obj;

#ifdef CLASS_DEBUG
    warn( msg_cleanup );
#endif

    /* delete all objects that are not deleted by the respective parent */
    while ( ( obj = next_autodelete( &objects ) ) != NULL )
    {
        OBJ_DELETE( obj );          /* delete obj, set to NULL */
    }

    /* safety net - should not come here - delete any remaining objects */
    while ( ! LIST_EMPTY( &objects ) )
    {
        obj = LIST_FIRST( &objects );
        OBJ_DELETE( obj );          /* delete obj, set to NULL */
    }
}

/*-----------------------------------------------------------------------------
*   setup atexit()
*----------------------------------------------------------------------------*/
static void init( void )
{
    static BOOL initialized = FALSE;

    if ( ! initialized )
    {
#ifdef CLASS_DEBUG
        warn( msg_init );
#endif
        atexit( cleanup );
        initialized = TRUE;
    }
}

/*-----------------------------------------------------------------------------
*   Register an object
*----------------------------------------------------------------------------*/
void _register_obj( ObjRegister *obj,
                    void ( *delete_ptr )( ObjRegister * ),
                    char *name,
                    char *file, int lineno )
{
    init();
    obj->_class.delete_ptr = delete_ptr;
    obj->_class.name       = name;

    _update_register_obj( obj, file, lineno );
}

void _update_register_obj( ObjRegister *obj, char *file, int lineno )
{
    init();
    obj->_class.file       = file;
    obj->_class.lineno     = lineno;

    LIST_INSERT_HEAD( &objects, obj, _class.entries );

#ifdef CLASS_DEBUG
    warn( msg_new_class, file, lineno, obj->_class.name, obj );
#endif
}

/*-----------------------------------------------------------------------------
*   Deregister an object
*----------------------------------------------------------------------------*/
void _deregister_obj( ObjRegister *obj, char *file, int lineno )
{
    init();
    LIST_REMOVE( obj, _class.entries );

#ifdef CLASS_DEBUG
    warn( msg_delete_class, file, lineno, obj->_class.name, obj,
          obj->_class.file, obj->_class.lineno );
#endif
}
