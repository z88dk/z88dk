/*
 * structure for lvalue's - (cclvalue.h)
 *
 * $Id: lvalue.h,v 1.1.1.1 2000-07-04 15:33:31 dom Exp $
 */

struct lvalue {
        SYMBOL *symbol ;                /* symbol table address, or 0 for constant */
        int indirect ;                  /* type of indirect object, 0 for static object */
        int ptr_type ;                  /* type of pointer or array, 0 for other idents */
        int is_const ;                  /* true if constant expression */
        signed long const_val ;                        /* value of constant expression (& other uses) */
        TAG_SYMBOL *tagsym ;    /* tag symbol address, 0 if not struct */
        void (*binop)() ;                /* function address of highest/last binary operator */
        char *stage_add ;               /* stage addess of "oper 0" code, else 0 */
        int val_type ;                  /* type of value calculated */
        char flags ;                    /* As per symbol */
        char oflags;                    /* Needed for deref of far str*/
        int type;                       /* type (from symbol table) */
        int ident;                      /* ident (from symbol table) */
	char storage;			/* storage (from sym tab) */
        char c_id;                      /* ident of cast        */
        char c_vtype;                   /* type of value calc if cast */
        char c_flags;                   /* flags for casting */
	int  level;		/* Parenth level (cast) */
	int  castlevel;
	int  offset;
        TAG_SYMBOL *c_tag;
        
        
} ;

#define LVALUE struct lvalue
