/*
Z88DK Z80 Macro Assembler

Simple classes defined in C with constructor, destructor and copy
constructor defined.
All objects that were not deleted during the program execution
are orderly destroyed at the exit, i.e. by calling the destructor of
each object, which in turn may call destructors of contained objects.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "alloc.h"
#include "class.h"
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
DEFINE_init_module()
{
	/* make sure m_malloc and strpool are removed last */
    m_alloc_init();
	strpool_init();

#ifdef CLASS_DEBUG
    warn( "class: init\n" );
#endif
}

/*-----------------------------------------------------------------------------
*   Destruct all objects from the stack
*----------------------------------------------------------------------------*/
DEFINE_dtor_module()
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
    init_module();

    obj->_class.delete_ptr = delete_ptr;
    obj->_class.name       = name;

    _update_register_obj( obj );
}

void _update_register_obj( Object *obj )
{
    init_module();

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
    init_module();

    LIST_REMOVE( obj, _class.entries );

#ifdef CLASS_DEBUG
    warn( "class: delete class %s\n", obj->_class.name );
#endif
}
