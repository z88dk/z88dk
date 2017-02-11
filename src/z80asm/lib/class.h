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

#pragma once

#include "alloc.h"
#include "queue.h"
#include "types.h"

#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   PUBLIC INTERFACE

// declare the class
CLASS(T)
    int a, b;
    char * string;
END_CLASS;

// define the class
DEF_CLASS(T);

// helper functions, need to be defined
void T_init (T *self)   { self->string = m_calloc(1000,1); }
void T_copy (T *self, T *other)
						{ self->string = m_strdup(other->string); }
void T_fini (T *self)   { m_free(self->string); }

// usage of class
T * obj1 = OBJ_NEW(T);  // same as T_new()
T * obj2 = T_clone(obj1);
OBJ_DELETE(obj1);       // same as T_delete(obj1); obj1 = NULL;
OBJ_DELETE(obj2);       // same as T_delete(obj2); obj2 = NULL;

OBJ_AUTODELETE(obj1) = FALSE;   // if object is destroyed by another
                                // object that owns it

// usage for static objects
T * obj = NULL;
T * alias = INIT_OBJ( T, &obj );	// calls OBJ_NEW on first call
									// returns alias == obj
*----------------------------------------------------------------------------*/

/* declare object registry for use in class definition */
struct Object;

/*-----------------------------------------------------------------------------
*   Start class declaration
*----------------------------------------------------------------------------*/
#define CLASS(T)	                                                        \
    /* forward declaration of struct */                                     \
    typedef struct T T;                                                     \
    /* constructor, copy constructor, destructor defined by DEF_CLASS() */  \
    extern T *  T##_new    (void);                                          \
    extern T *  T##_clone  (T * other);                                     \
    extern void T##_delete (T * self);                                      \
    /* helper functions to be supplied by user */                           \
    extern void T##_init (T * self);        /* called by T##_new    */      \
    extern void T##_copy (T * self, T * other);								\
											/* called by T##_clone  */      \
    extern void T##_fini (T * self);        /* called by T##_delete */      \
    /* class structure */                                                   \
    struct T {                                                              \
        /* header, equal in all classes */                                  \
        struct {                            /* private attributes */        \
            void (*delete_ptr)(struct Object *);                       		\
            /* destructor function */       \
            char *name;                     /* class name */                \
            Bool autodelete;                /* false to skip cleanup */     \
            LIST_ENTRY(T) entries;          /* D-Linked list of objs */     \
        } _class;                                                           \
        /* next come the user supplied fields */

/*-----------------------------------------------------------------------------
*   End class declaration
*----------------------------------------------------------------------------*/
#define END_CLASS                                                           \
    }; /* end of struct T definition */

/*-----------------------------------------------------------------------------
*   Empty _class initializer
*----------------------------------------------------------------------------*/
#define CLASS_INITIALIZER	{ 0, 0, 0, { 0, 0 } }

/*-----------------------------------------------------------------------------
*   Class definition
*----------------------------------------------------------------------------*/
#define DEF_CLASS(T)                                                        \
    /* constructor */                                                       \
    T * T##_new (void)                                                      \
    {                                                                       \
        T * self = m_new(T);		            /* allocate object */           \
        OBJ_AUTODELETE(self) = TRUE;        /* auto delete by default */    \
        T##_init(self);                     /* call user initialization */  \
        _register_obj((struct Object *) self,                          		\
                      (void (*)(struct Object *)) T##_delete, ""#T );		\
        /* register for cleanup */      									\
        return self;                                                        \
    }                                                                       \
    /* copy-constructor */                                                  \
    T * T##_clone (T * other)                                               \
    {                                                                       \
        T * self = m_new(T);					/* allocate object */           \
        memcpy(self, other, sizeof(T));     /* byte copy */                 \
        T##_copy(self, other);              /* alloc memory if needed */    \
        _update_register_obj((struct Object *) self );						\
        /* register for cleanup */      									\
        return self;                                                        \
    }                                                                       \
    /* destructor */                                                        \
    void T##_delete (T * self)                                              \
    {                                                                       \
        _deregister_obj((struct Object *) self );							\
        /* remove from cleanup list */  									\
        T##_fini(self);                     /* call user cleanup */         \
        m_free(self);                        /* reclaim memory */            \
    }

/*-----------------------------------------------------------------------------
*   Helper macros
*----------------------------------------------------------------------------*/
#define OBJ_NEW(T)      T##_new()
#define INIT_OBJ(T, pobj)	\
	( *(pobj) != NULL ?			\
		*(pobj) :				\
		( *(pobj) = T##_new() ) \
	)
#define OBJ_DELETE(obj) ( (obj) == NULL ? \
								NULL : \
								( ( (*(obj)->_class.delete_ptr)( \
											(struct Object *) (obj) ) ), \
								  (obj) = NULL ) )
#define OBJ_AUTODELETE(obj) ((obj)->_class.autodelete)

/*-----------------------------------------------------------------------------
*   Private interface
*----------------------------------------------------------------------------*/
extern void _register_obj( struct Object *obj,
                           void ( *delete_ptr )( struct Object * ),
                           char *name );
extern void _update_register_obj( struct Object *obj );
extern void _deregister_obj( struct Object *obj );
