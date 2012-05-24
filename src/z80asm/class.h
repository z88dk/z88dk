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

Copyright (C) Paulo Custodio, 2011-2012

Simple classes defined in C with constructor, destructor and copy
constructor defined.
All objects that were not deleted during the program execution
are orderly destroyed at the exit, i.e. by calling the destructor of
each object, which in turn may call destructors of contained objects.

*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/class.h,v 1.1 2012-05-24 17:01:45 pauloscustodio Exp $ */
/* $Log: class.h,v $
/* Revision 1.1  2012-05-24 17:01:45  pauloscustodio
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
void T_init (T *self)   { self->string = xcalloc(1000,1); }
void T_copy (T *self)   { self->string = xstrdup(self->string); }
void T_fini (T *self)   { xfree(self->string); }

// usage of class
T * obj1 = OBJ_NEW(T);  // same as T_new()
T * obj2 = T_clone(obj1);
OBJ_DELETE(obj1);       // same as T_delete(obj1); obj1 = NULL;
OBJ_DELETE(obj2);       // same as T_delete(obj2); obj2 = NULL;

OBJ_AUTODELETE(obj1) = FALSE;   // if object is destroyed by another
                                // object that owns it

*----------------------------------------------------------------------------*/

/* declare object registry for use in class definition */
typedef struct ObjRegister ObjRegister;

/*-----------------------------------------------------------------------------
*   Start class declaration
*----------------------------------------------------------------------------*/
#define CLASS(T)                                                            \
    /* forward declaration of struct */                                     \
    typedef struct T T;                                                     \
    /* constructor, copy constructor, destructor defined by DEF_CLASS() */  \
    extern T *  T##_new    (void);                                          \
    extern T *  T##_clone  (T * other);                                     \
    extern void T##_delete (T * self);                                      \
    /* helper functions to be supplied by user */                           \
    extern void T##_init (T * self);        /* called by T##_new    */      \
    extern void T##_copy (T * self);        /* called by T##_clone  */      \
    extern void T##_fini (T * self);        /* called by T##_delete */      \
    /* class structure */                                                   \
    struct T {                                                              \
        /* header, equal in all classes */                                  \
        struct {                            /* private attributes */        \
            void (*delete_ptr)(ObjRegister *);                              \
            /* destructor function */       \
            char *name;                     /* class name */                \
            char *file; int lineno;         /* where defined */             \
            bool autodelete;                /* false to skip cleanup */     \
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
        T * self = xcalloc_struct(T);       /* allocate object */           \
        OBJ_AUTODELETE(self) = TRUE;        /* auto delete by default */    \
        T##_init(self);                     /* call user initialization */  \
        _register_obj((ObjRegister *) self,                                 \
                      (void (*)(ObjRegister *)) T##_delete,                 \
                      ""#T, __FILE__, __LINE__);                            \
        /* register for cleanup */      \
        return self;                                                        \
    }                                                                       \
    /* copy-constructor */                                                  \
    T * T##_clone (T * other)                                               \
    {                                                                       \
        T * self = xmalloc(sizeof(T));      /* allocate object */           \
        memcpy(self, other, sizeof(T));     /* byte copy */                 \
        T##_copy(self);                     /* alloc memory if needed */    \
        _update_register_obj((ObjRegister *) self, __FILE__, __LINE__);     \
        /* register for cleanup */      \
        return self;                                                        \
    }                                                                       \
    /* destructor */                                                        \
    void T##_delete (T * self)                                              \
    {                                                                       \
        _deregister_obj((ObjRegister *) self, __FILE__, __LINE__);          \
        /* remove from cleanup list */  \
        T##_fini(self);                     /* call user cleanup */         \
        xfree(self);                        /* reclaim memory */            \
    }

/*-----------------------------------------------------------------------------
*   Helper macros
*----------------------------------------------------------------------------*/
#define OBJ_NEW(T)      T##_new()
#define OBJ_DELETE(obj) ( ( (*(obj)->_class.delete_ptr)((ObjRegister *)(obj)) ), \
                          (obj) = NULL )
#define OBJ_AUTODELETE(obj) ((obj)->_class.autodelete)

/*-----------------------------------------------------------------------------
*   Private interface
*----------------------------------------------------------------------------*/
extern void _register_obj( ObjRegister *obj,
                           void ( *delete_ptr )( ObjRegister * ),
                           char *name,
                           char *file, int lineno );
extern void _update_register_obj( ObjRegister *obj, char *file, int lineno );
extern void _deregister_obj( ObjRegister *obj, char *file, int lineno );

#endif /* ndef CLASS_H */
