/*
Simple classes defined in C with constructor, destructor and copy
constructor defined.
All objects that were not deleted during the program execution
are orderly destroyed at the exit, i.e. by calling the destructor of
each object, which in turn may call destructors of contained objects.

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/class.c,v 1.1 2013-12-18 23:05:52 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */
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
    warn( "class: cleanup\n" );
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
        warn( "class: init\n" );
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
    warn( "class %s(%d): new class %s\n", file, lineno, obj->_class.name );
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
    warn( "class %s(%d): delete class %s created at %s(%d)\n", file, lineno, 
		  obj->_class.name, 
          obj->_class.file, obj->_class.lineno );
#endif
}


/* 
* $Log: class.c,v $
* Revision 1.1  2013-12-18 23:05:52  pauloscustodio
* Move class.c to the z80asm/lib directory
*
* Revision 1.3  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.2  2013/01/20 21:10:32  pauloscustodio
* Rename bool to BOOL, to be consistent with TRUE and FALSE and
* distinguish from C++ bool, true, false
*
* Revision 1.1  2012/05/24 17:01:45  pauloscustodio
* CH_0009 : new CLASS to define simple classes
*
*/
