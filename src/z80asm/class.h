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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/class.h,v 1.9 2013-09-12 00:10:02 pauloscustodio Exp $ */
/* $Log: class.h,v $
/* Revision 1.9  2013-09-12 00:10:02  pauloscustodio
/* Create g_free0() macro that NULLs the pointer after free, required
/* by z80asm to find out if a pointer was already freed.
/*
/* Revision 1.8  2013/09/08 08:29:21  pauloscustodio
/* Replaced xmalloc et al with g_malloc0 et al.
/*
/* Revision 1.7  2013/05/12 21:39:05  pauloscustodio
/* OBJ_DELETE() now accepts and ignores a NULL argument
/*
/* Revision 1.6  2013/01/30 20:38:59  pauloscustodio
/* Double macro call not necessary
/*
/* Revision 1.5  2013/01/30 00:39:25  pauloscustodio
/* New CLASS_LIST() to create lists of objects defined with CLASS()
/*
/* Revision 1.4  2013/01/20 21:10:32  pauloscustodio
/* Rename bool to BOOL, to be consistent with TRUE and FALSE and
/* distinguish from C++ bool, true, false
/*
/* Revision 1.3  2013/01/19 00:04:53  pauloscustodio
/* Implement StrHash_clone, required change in API of class.h and all classes that used it.
/*
/* Revision 1.2  2012/05/25 21:43:55  pauloscustodio
/* compile error in cygwin gcc 3.4.5 with forward declaration of
/* typedef struct ObjRegister ObjRegister
/*
/* Revision 1.1  2012/05/24 17:01:45  pauloscustodio
/* CH_0009 : new CLASS to define simple classes
/*
/*
/* */

#ifndef CLASS_H
#define CLASS_H

#include "memalloc.h"   /* before any other include */
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
void T_init (T *self)   { self->string = g_malloc0_n(1000,1); }
void T_copy (T *self, T *other)
						{ self->string = g_strdup(other->string); }
void T_fini (T *self)   { g_free0(self->string); }

// usage of class
T * obj1 = OBJ_NEW(T);  // same as T_new()
T * obj2 = T_clone(obj1);
OBJ_DELETE(obj1);       // same as T_delete(obj1); obj1 = NULL;
OBJ_DELETE(obj2);       // same as T_delete(obj2); obj2 = NULL;

OBJ_AUTODELETE(obj1) = FALSE;   // if object is destroyed by another
                                // object that owns it

*----------------------------------------------------------------------------*/

/* declare object registry for use in class definition */
struct ObjRegister;

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
            void (*delete_ptr)(struct ObjRegister *);                       \
            /* destructor function */       \
            char *name;                     /* class name */                \
            char *file; int lineno;         /* where defined */             \
            BOOL autodelete;                /* false to skip cleanup */     \
            LIST_ENTRY(T) entries;          /* D-Linked list of objs */     \
        } _class;                                                           \
        /* next come the user supplied fields */

/*-----------------------------------------------------------------------------
*   End class declaration
*----------------------------------------------------------------------------*/
#define END_CLASS                                                           \
    }; /* end of struct T definition */

/*-----------------------------------------------------------------------------
*   Class definition
*----------------------------------------------------------------------------*/
#define DEF_CLASS(T)                                                        \
    /* constructor */                                                       \
    T * T##_new (void)                                                      \
    {                                                                       \
        T * self = g_new0(T, 1);            /* allocate object */           \
        OBJ_AUTODELETE(self) = TRUE;        /* auto delete by default */    \
        T##_init(self);                     /* call user initialization */  \
        _register_obj((struct ObjRegister *) self,                          \
                      (void (*)(struct ObjRegister *)) T##_delete,          \
                      ""#T, __FILE__, __LINE__);                            \
        /* register for cleanup */      \
        return self;                                                        \
    }                                                                       \
    /* copy-constructor */                                                  \
    T * T##_clone (T * other)                                               \
    {                                                                       \
        T * self = g_malloc0(sizeof(T));      /* allocate object */           \
        memcpy(self, other, sizeof(T));     /* byte copy */                 \
        T##_copy(self, other);              /* alloc memory if needed */    \
        _update_register_obj((struct ObjRegister *) self,                   \
                             __FILE__, __LINE__);                           \
        /* register for cleanup */      \
        return self;                                                        \
    }                                                                       \
    /* destructor */                                                        \
    void T##_delete (T * self)                                              \
    {                                                                       \
        _deregister_obj((struct ObjRegister *) self, __FILE__, __LINE__);   \
        /* remove from cleanup list */  \
        T##_fini(self);                     /* call user cleanup */         \
        g_free0(self);                        /* reclaim memory */            \
    }

/*-----------------------------------------------------------------------------
*   Helper macros
*----------------------------------------------------------------------------*/
#define OBJ_NEW(T)      T##_new()
#define OBJ_DELETE(obj) ( (obj) == NULL ? \
								NULL : \
								( ( (*(obj)->_class.delete_ptr)( \
											(struct ObjRegister *) (obj) ) ), \
								  (obj) = NULL ) )
#define OBJ_AUTODELETE(obj) ((obj)->_class.autodelete)

/*-----------------------------------------------------------------------------
*   Private interface
*----------------------------------------------------------------------------*/
extern void _register_obj( struct ObjRegister *obj,
                           void ( *delete_ptr )( struct ObjRegister * ),
                           char *name,
                           char *file, int lineno );
extern void _update_register_obj( struct ObjRegister *obj, char *file, int lineno );
extern void _deregister_obj( struct ObjRegister *obj, char *file, int lineno );

#endif /* ndef CLASS_H */
