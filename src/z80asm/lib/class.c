/*
Simple classes defined in C with constructor, destructor and copy
constructor defined.
All objects that were not deleted during the program execution
are orderly destroyed at the exit, i.e. by calling the destructor of
each object, which in turn may call destructors of contained objects.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/class.c,v 1.7 2014-05-25 01:02:30 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */
#include "class.h"
#include "die.h"
#include "init.h"
#include "strpool.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Object register - just the pointers defined by CLASS()
*----------------------------------------------------------------------------*/
CLASS( Object )
/* no user fields */
END_CLASS;

/* list of all created objects */
typedef LIST_HEAD( ObjectList, Object ) ObjectList;
static ObjectList objects = LIST_HEAD_INITIALIZER( objects );

/*-----------------------------------------------------------------------------
*   Search next object to be deleted
*----------------------------------------------------------------------------*/
static Object *next_autodelete( ObjectList *headp )
{
    Object *obj;

    LIST_FOREACH( obj, headp, _class.entries )

    if ( OBJ_AUTODELETE( obj ) )
        return obj;

    return NULL;
}

/*-----------------------------------------------------------------------------
*   Initialize
*----------------------------------------------------------------------------*/
DEFINE_init()
{
	/* make sure xmalloc and strpool are removed last */
    xmalloc_init();
	strpool_init();

#ifdef CLASS_DEBUG
    warn( "class: init\n" );
#endif
}

/*-----------------------------------------------------------------------------
*   Destruct all objects from the stack
*----------------------------------------------------------------------------*/
DEFINE_fini()
{
    Object *obj;

#ifdef CLASS_DEBUG
    warn( "class: cleanup\n" );
#endif

    /* delete all objects that are not deleted by the respective parent */
    while ( ( obj = next_autodelete( &objects ) ) != NULL )
        OBJ_DELETE( obj );          /* delete obj, set to NULL */

    /* safety net - should not come here - delete any remaining objects */
    while ( ! LIST_EMPTY( &objects ) )
    {
        obj = LIST_FIRST( &objects );
        OBJ_DELETE( obj );          /* delete obj, set to NULL */
    }
}

/*-----------------------------------------------------------------------------
*   Register an object
*----------------------------------------------------------------------------*/
void _register_obj( Object *obj,
                    void ( *delete_ptr )( Object * ),
                    char *name )
{
    init();

    obj->_class.delete_ptr = delete_ptr;
    obj->_class.name       = name;

    _update_register_obj( obj );
}

void _update_register_obj( Object *obj )
{
    init();

    LIST_INSERT_HEAD( &objects, obj, _class.entries );

#ifdef CLASS_DEBUG
    warn( "class: new class %s\n", obj->_class.name );
#endif
}

/*-----------------------------------------------------------------------------
*   Deregister an object
*----------------------------------------------------------------------------*/
void _deregister_obj( Object *obj )
{
    init();

    LIST_REMOVE( obj, _class.entries );

#ifdef CLASS_DEBUG
    warn( "class: delete class %s\n", obj->_class.name );
#endif
}


/*
* $Log: class.c,v $
* Revision 1.7  2014-05-25 01:02:30  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.6  2014/05/19 00:11:25  pauloscustodio
* Make sure strpool is deleted after class, because objects defined with class may use strpool
*
* Revision 1.5  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.4  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.3  2013/12/19 00:18:23  pauloscustodio
* Use init.h mechanism for intialization code; rename object structure
*
* Revision 1.2  2013/12/18 23:50:36  pauloscustodio
* Remove file and lineno from class defintion - not useful
*
* Revision 1.1  2013/12/18 23:05:52  pauloscustodio
* Move class.c to the z80asm/lib directory
*
* Revision 1.3  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.2  2013/01/20 21:10:32  pauloscustodio
* Rename bool to Bool, to be consistent with TRUE and FALSE and
* distinguish from C++ bool, true, false
*
* Revision 1.1  2012/05/24 17:01:45  pauloscustodio
* CH_0009 : new CLASS to define simple classes
*
*/
