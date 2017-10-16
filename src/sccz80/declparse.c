 
#include "ccdefs.h"
#include "define.h" 

static void declfunc(Type *type, enum storage_type storage);
static void handle_kr_type_parameters(Type *func);

Type   *type_void = &(Type){ KIND_VOID, 1, 0, .len=1 };
Type   *type_carry = &(Type){ KIND_CARRY, 1, 0, .len=1 };
Type   *type_char = &(Type){ KIND_CHAR, 1, 0, .len=1 };
Type   *type_uchar = &(Type){ KIND_CHAR, 1, 1, .len=1 };
Type   *type_int = &(Type){ KIND_INT, 2, 0, .len=1 };
Type   *type_uint = &(Type){ KIND_INT, 2, 1, .len=1 };
Type   *type_long = &(Type){ KIND_LONG, 4, 0, .len=1 };
Type   *type_ulong = &(Type){ KIND_LONG, 4, 1, .len=1 };
Type   *type_double = &(Type){ KIND_DOUBLE, 6, 0, .len=1 };

static int32_t needsub(void)
{
    double  val;
    Kind    valtype;

    if (cmatch(']'))
        return (0); /* null size */
    if (constexpr(&val,&valtype, 1) == 0) {
        val = 1;
    } else if (val < 0) {
        error(E_NEGATIVE);
        val = (-val);
    }
    if (valtype == KIND_DOUBLE)
        warning(W_DOUBLE_UNEXPECTED);
    needchar(']'); /* force single dimension */
    return (val); /* and return size */
}


static void swallow_bitfield(void)
{
    double val;
    Kind   valtype;
    if (cmatch(':')) {
        constexpr(&val, &valtype, 1);
        warning(W_BITFIELD);
    }
}

array *array_init(void (*destructor)(void *))
{
    array *arr = CALLOC(1,sizeof(*arr));
    arr->size = 0;
    arr->elems = NULL;
    arr->destructor = destructor;
    return arr;
}

void array_free(array *arr)
{
    int i;
    // TODO: Destruction of contents
    for ( i = 0; i < arr->size; i++ ) {
        if ( arr->destructor ) arr->destructor(arr->elems[i]);
    }
    FREENULL(arr->elems);
    FREENULL(arr);
}

size_t array_len(array *arr)
{
    return arr->size;
}

void array_add(array *arr, void *elem)
{
    int   i = arr->size++;
    arr->elems = REALLOC(arr->elems, arr->size * sizeof(arr->elems[i]));
    arr->elems[i] = elem;
}

void *array_get_byindex(array *arr, int index)
{
    if ( index < 0 || index >= arr->size ) {
        return NULL;
    }
    return arr->elems[index];
}




Type *dodeclare2(Type **base_type);


Type *find_enum(const char *name)
{
    SYMBOL *ptr = findglb(name);

    if ( ptr && ptr->ident == ID_ENUM ) {
        return ptr->ctype;
    }
    return NULL;
}

static Type *tag_hash = NULL;

void add_tag(Type *type)
{
    // addglb
    HASH_ADD_STR(tag_hash, name, type);    
}

Type *find_tag(const char *name)
{
    Type *t;
    HASH_FIND_STR(tag_hash, name, t);

    return t;
}

Type *find_tag_field(Type *tag, const char *fieldname)
{
    int    i;
    for ( i = 0; i < array_len(tag->fields) ; i++ ) {
        Type *field = array_get_byindex(tag->fields, i);
        if ( strcmp(field->name, fieldname) == 0 ) {
            return field;
        }
    }
    return NULL;
}





static Type *parse_decl_tail(Type *base_type);
static Type *parse_decl(char name[], Type *base_type);

void free_type(void *data)
{
    Type *type = data;

    if ( type->fields)
        array_free(type->fields);
    if ( type->parameters )
        array_free(type->parameters);
    if ( type->return_type ) 
        free_type(type->return_type);
    FREENULL(type);
}

Type *make_constant(const char *name, int32_t value)
{
    SYMBOL *ptr;
    Type *type = CALLOC(1,sizeof(*type));

    // TODO: We need to make constants long if necessary
    type->kind = KIND_ENUM;
    type->isconst = 1;
    strcpy(type->name, name);
    type->value = value;

    ptr = addglb(type->name, ID_VARIABLE, KIND_ENUM, 0, STATIK);
    ptr->ctype = type;
    ptr->size = value;
    ptr->isassigned = 1;

    return type;
}

Type *make_enum(const char *name)
{
    Type *type = CALLOC(1,sizeof(*type));

    type->fields = array_init(NULL);    
    type->kind = KIND_ENUM;
    type->size = 2;
    type->len = 1;
    type->isconst = 1;
    strcpy(type->name, name);

    return type;
}

Type *make_pointer(Type *base_type)
{
    Type *type = CALLOC(1,sizeof(*type));
    type->kind = base_type->isfar ? KIND_CPTR : KIND_PTR;
    type->ptr = base_type;
    type->size = base_type->isfar ? 3 : 2;
    type->len = 1;
    return type;
}


Type *make_array(Type *base_type,int32_t len)
{
    Type *type = CALLOC(1,sizeof(*type));
    type->kind = KIND_ARRAY;
    type->ptr = base_type;
    type->len = len;
    if ( len != - 1 ) {
        type->size = len * base_type->size;
    } else {
        type->size = -1;
    }
    return type;
}

int ispointer(Type *type)
{
    return type->kind == KIND_PTR || type->kind == KIND_CPTR;
}


static Type *parse_enum(Type *type)
{
    Type *ptr;
    char sname[NAMESIZE];
    static int num_enums_defined = 0;

    type->kind = KIND_INT;
    type->len = 1;
    type->size = 2;
    type->isunsigned = c_default_unsigned;
    if ( symname(sname) == 0 )
        snprintf(sname, sizeof(sname),"0sc_i_enumb%d", num_enums_defined++);
    
    if ( (ptr = find_enum(sname)) == NULL ) {
        int32_t  value = 0;

        ptr = make_enum(sname);
        SYMBOL *sym = addglb(sname, ID_ENUM, type->kind, 0, LSTATIC);
        sym->ctype = type;

        needchar('{');
        do {
            Type *elem;

            if (symname(sname) == 0)
                illname(sname);
            if (cmatch('=')) {
                double dval;
                Kind   valtype;

                constexpr(&dval, &valtype, 1);
                if ( valtype == KIND_DOUBLE )
                    warning(W_DOUBLE_UNEXPECTED);
                value = dval;
            }
            elem = make_constant(sname, value);
            array_add(ptr->fields, elem);  // Keep reference to the enum value so we validate switches..
//            add_global(elem);
            
            value++;
        } while (cmatch(',') && !rcmatch('}'));
        needchar('}');
    } 
    return ptr;
}

Type *parse_struct(Type *type, int isstruct)
{
    char    sname[NAMESIZE];
    Type   *str = NULL;
    size_t  offset = 0;
    size_t  size = 0;
    static int num_structs;

    if ( symname(sname) ) {
        str = find_tag(sname);
        if ( str && str->weak == 0) {
            if (rcmatch('{')) {
                multidef(sname);
                return NULL;
            } 
            type->kind = KIND_STRUCT;
            type->size = str->size;
            type->tag = str;
            type->isstruct = isstruct;
            return type;
        } else if ( str == NULL ) {
            str = CALLOC(1,sizeof(*str));
            str->kind = KIND_STRUCT;
            str->weak = 1;
            str->size = -1;            
            str->fields = array_init(free_type);  
            str->isstruct = isstruct;
            strcpy(str->name, sname);
            add_tag(str);                    
        }
        // It's a weak reference we should define it 
    } else {
        // Anonymous struct
        str = CALLOC(1,sizeof(*str));
        snprintf(str->name, sizeof(str->name), "0__anonstruct_%d", num_structs++);
        str->kind = KIND_STRUCT;
        str->fields = array_init(free_type); 
        str->weak = 1;
        str->size = -1;
        str->isstruct = isstruct;        
        add_tag(str);        
    } 
    if ( rcmatch('{')) {
        Type *elem;
        needchar('{');

        do {
            // Read each field now */
            blanks();
            elem = dodeclare2(NULL);
            
            if ( elem != NULL ) {
                elem->offset = offset;
                if ( isstruct ) { 
                    offset += elem->size;
                    size += elem->size;
                } else { 
                    if ( elem->size > size ) size = elem->size;
                }
                array_add(str->fields, elem);
            } else {
                break;
            }
            // Swallow bitfields
            swallow_bitfield();

            if ( rcmatch('}')) 
                break;
            needchar(';');
        } while ( 1 );
        needchar('}');
        str->size = size;  // It's now defined
        str->weak = 0;
    }
    // TODO: Only pointers to weak structures are valid
    type->kind = KIND_STRUCT;
    type->tag = str;
    type->size = str->size;
    return type;
}

static int chase_typedef(Type *type)
{
    SYMBOL *ptr;

    blanks();

    for ( ptr = symtab; ptr != NULL; ptr = ptr->hh.next ) {
        if (ptr->storage == TYPDEF && amatch(ptr->name)) {
            /* So we've identified it, we should copy it */
            *type = *ptr->ctype;
            return 0;
        }
    }
    return -1;
}

// Read the base type 
static Type *parse_type(void)
{
    Type *type = CALLOC(1,sizeof(*type));

    type->len = 1;
    if ( swallow("const")) {
        type->isconst = 1;
    } else if (swallow("volatile")) {
        warning(W_VOLATILE);
    }

    if (amatch("__sfr")) {
        blanks();
        type->kind = KIND_PORT8;

        if ( amatch("__banked")) {
            type->kind = KIND_PORT16;
        }
        match("__at");
        return type;
    }

    if (amatch("far")) 
        type->isfar = 1;
    else if ( amatch("near"))
        type->isfar = 0;

    if ( amatch("signed"))
        type->isunsigned = 0;
    else if ( amatch("unsigned"))
        type->isunsigned = 1;
    
    if ( amatch("char"))  {
        type->kind = KIND_CHAR;
        type->size = 1;
    } else if ( amatch("int") || amatch("short")) {
        type->kind = KIND_INT;
        type->size = 2;
    } else if ( amatch("long")) {
        type->kind = KIND_LONG;
        type->size = 4;
    } else if ( amatch("float") || amatch("double")) {
        type->kind = KIND_DOUBLE;
        type->size = 6;
    } else if ( amatch("void")) {
        type->kind = KIND_VOID;
        type->size = 1;
    } else if ( amatch("...")) {
        type->kind = KIND_ELLIPSES;
    } else if ( amatch("enum")) {
        return parse_enum(type);
    } else if ( amatch("struct")) {
        return parse_struct(type, 1);
    } else if ( amatch("union")) {
        return parse_struct(type, 0);
    } else if ( chase_typedef(type) < 0 ) {
        FREENULL(type);
        return type;
    }

    // Successful
    return type;
}

static void parse_trailing_modifiers(Type *type)
{
    if ( c_use_r2l_calling_convention == NO ) {
        type->flags |= SMALLC;
    }
    while (1) {
        if (amatch("__z88dk_fastcall") || amatch("__FASTCALL__")) {
            type->flags |= FASTCALL;
            type->flags &= ~FLOATINGDECL;
        } else if (amatch("__z88dk_callee") || amatch("__CALLEE__")) {
            type->flags |= CALLEE;
            type->flags &= ~FLOATINGDECL;
        } else if (amatch("__z88dk_saveframe") || amatch("__SAVEFRAME__")) {
            type->flags |= SAVEFRAME;
        } else if (amatch("__smallc")) {
            type->flags |= SMALLC;
            type->flags &= ~FLOATINGDECL;
        } else if (amatch("__stdc")) {
            type->flags &= ~(SMALLC|FLOATINGDECL);
        } else if (amatch("__naked")) {
            type->flags |= NAKED;
            continue;
        } else if ( amatch("__critical")) {
            type->flags |= CRITICAL;
            continue;
        } else if (amatch("__preserves_regs")) {
            int c;
            needchar('(');
            /* Consume what's inside, isalpha, comma, white space */
            while ((c = ch())) {
                if (isalpha(c) || isspace(c) || c == ',') {
                    gch();
                    continue;
                }
                break;
            }

            needchar(')');
        } else {
            break;
        }
    }

    /* Main is always STDC */
    if ( strcmp(type->name,"main") == 0 ) {
        type->flags &= ~SMALLC;
    }

    if ( (type->flags & (NAKED|CRITICAL) ) == (NAKED|CRITICAL) ) {
        error(E_NAKED_CRITICAL, type->name);
    }
}

static int check_existing_parameter(Type *func, Type *param)
{
    int    i;

    for ( i = 0; i < array_len(func->parameters); i++ ) {
        Type *existing = array_get_byindex(func->parameters,i);

        if ( strlen(param->name) && strcmp(existing->name, param->name) == 0 ) {
            printf("A parameter named %s has already been defined for function\n",param->name);
            junk();
            return -1;
        }
    }
    return 0;
}

Type *parse_parameter_list(Type *return_type)
{
    Type *func;
    Type *param;
    int   iskr = 0;

    needchar('(');

    if ( rcmatch(')') ) {
        cmatch(')');
        func = CALLOC(1,sizeof(*func));
        func->kind = KIND_FUNC;
        func->size = 0;
        func->len = 1;
        func->oldstyle = 1;  // i.e. arbitrary number of parameters
        func->return_type = return_type;
        func->parameters = array_init(free_type);
        parse_trailing_modifiers(func);
        return func;
    }

    func = CALLOC(1,sizeof(*func));
    func->kind = KIND_FUNC;
    func->size = 0;
    func->len = 1;        
    func->return_type = return_type;
    func->parameters = array_init(NULL);        
    
    do {
        param = dodeclare2(NULL); // STORAGE_AUTO);

        if ( param == NULL ) {
            // KR Fake an argument
            iskr = 1;            
            param = CALLOC(1,sizeof(*param));
            *param = *type_int;  // Implicitly int
            if ( symname(param->name) == 0 ) {
                error(E_ARGNAME);
                junk();
            }
        }
        
        // A void type by itself, no parameters
        if ( param->kind == KIND_VOID ) {
            break;
        }
        /* An array parameter becomes a pointer as function argument */
        if ( param->kind == KIND_ARRAY ) {
            Type *ptr = make_pointer(param->ptr);
            strcpy(ptr->name, param->name);
            param = ptr;
        }
        if ( param != NULL ) {
            if ( param->kind == KIND_ELLIPSES) {
                if ( array_len(func->parameters)  ) {
                    array_add(func->parameters, param);    
                    func->hasva = 1;            
                } else {                    
                    printf("Ellipses must follow a parameter\n");
                }
                break;
            } else if ( param->kind == KIND_VOID ) {
                // Break out for a void parameter
                break;
            }
            // It's a parameter that should have a name, if we didn't get one, then fake one.
            // The caller will check if it needs to have a name i.e. we're in function definition context
            // Function pointers set their name inside the call
            if ( strlen(param->name) == 0  && symname(param->name) == 0 ) {
                snprintf(param->name, sizeof(param->name),"0__parameter_%lu",array_len(func->parameters));
                param->name[0] = 0;
            }
            if ( check_existing_parameter(func, param) == 0 )            
                array_add(func->parameters, param);
        }
        if ( !rcmatch(',')) 
            break;
        needchar(',');
    } while (1);
    needchar(')'); 
    parse_trailing_modifiers(func);

    if ( iskr ) {
        handle_kr_type_parameters(func);
    }

    return func;
}

Type *parse_decl_array(Type *base_type)
{
    Type *t;
    int32_t   len;

    needchar('[');
    
    if ( rcmatch(']')) {
        len = -1;
        needchar(']');
    } else {
        len = needsub(); // Swallows the ]
    } 
    
    t = parse_decl_tail(base_type);
    
    return make_array(t,len);
}

Type *parse_decl_func(Type *base_type)
{
    if ( base_type->kind == KIND_FUNC ) {
        printf("Can't define a function returning a function");
        return NULL;
    }
    if ( base_type->kind == KIND_ARRAY ) {
        printf("Can't define a function returning an array");
        return NULL;
    }
    return parse_parameter_list(base_type);
}


Type *parse_decl_tail(Type *base_type)
{    
    if ( rcmatch('['))
        return parse_decl_array(base_type);
    if ( rcmatch('('))
        return parse_decl_func(base_type);
    return base_type;
}

Type *parse_decl(char name[], Type *base_type)
{
    if ( rcmatch('(') ) {
        needchar('(');
        if ( rcmatch('*') == 0 ) { // Function parameters
            /* Check for argument list */
            Type *function_type = parse_decl_func(base_type);
            if ( function_type != NULL ) 
                return function_type;
        } else {
            /* It's a function pointer TODO: name etc */
            Type *stub = CALLOC(1,sizeof(*stub)); 
            Type *t = parse_decl(name, stub); 
            needchar(')');
            Type *tail = parse_decl_tail(base_type);
            *stub = *tail;
            FREENULL(tail);
            return t;
        }
    }

    if ( rcmatch('*')) {
        needchar('*');
        if ( base_type == NULL ) {
            printf("Pointer to what exactly?");
            return NULL;
        }
        return parse_decl(name, make_pointer(base_type));
    }

    if ( symname(name) ) {
        // TODO, if we're casting then we shouldn't have a name
    }
    
    return parse_decl_tail(base_type);
}

/** \brief Parse an expression as used for a cast or a sizeof operation
 */
Type *parse_expr_type()
{
    return dodeclare2(NULL);
}

/** \brief Declare a local variableif we need to
 */
int declare_local(int local_static)
{
    Type *type;
    Type *base_type = NULL;
    SYMBOL *sym;

    do {
        type = dodeclare2(&base_type);
        if ( type == NULL ) {
            return 0;
        }
        if ( local_static ) {
            char  namebuf[NAMESIZE * 2 + 10];
            snprintf(namebuf, sizeof(namebuf),"st_%s_%s", currfn->name, type->name);
            sym = addglb(namebuf, ID_VARIABLE, type->kind, 0, LSTATIC);
            sym->ctype = type;
            if ( cmatch('=')) {
                sym->isassigned = 1;
                sym->initialised = 1;
                initials(namebuf, type);                
            }
        } else {
            int size = type->size;

            if  ( size < 0 ) size = 0;

            sym = addloc(type->name, ID_VARIABLE, type->kind);
            sym->ctype = type;
            declared += size;
            sym->offset.i = Zsp - declared;
            if ( cmatch('=')) {
                sym->isassigned = 1;
                sym->initialised = 1;
                if ( type->kind == KIND_STRUCT || type->kind == KIND_ARRAY ) {
                    // Call static initialiser and copy onto stack
                    char newname[NAMESIZE * 2 + 20];

                    snprintf(newname, sizeof(newname),"auto_%s_%s",currfn->name, sym->name);
                    int alloc_size = initials(newname, type);
                    
                    declared += (alloc_size - size);
                    if ( type->kind == KIND_ARRAY ) {
                        sym->offset.i -= (alloc_size -size);
                        sym->size += (alloc_size - size);
                    }
                    Zsp = modstk(Zsp - declared, NO, NO);
                    declared = 0;
                    copy_to_stack(newname, 0, alloc_size);
                } else {
                    Kind expr;
                    Type *expr_type;
                    char *before, *start;
                    int   vconst;
                    double val;

                    Zsp = modstk(Zsp - (declared - type->size), NO, NO);
                    declared = 0;
                    setstage(&before, &start);
                    expr = expression(&vconst, &val, &expr_type);
                    
                    if ( vconst && expr != type->kind ) {
                        // It's a constant that doesn't match the right type
                        LVALUE  lval={0};
                        clearstage(before, 0);
                        if ( expr == KIND_DOUBLE ) {
                            decrement_double_ref_direct(val);
                        }
                        lval.ltype = type;
                        lval.val_type = type->kind;
                        lval.const_val = val;
                        load_constant(&lval);
                    } else {
                        clearstage(before, start);
                        //conv type
                        force(type->kind, expr, 0, 0, 0);
                    }
                    StoreTOS(type->kind);
                }
            }
        }
    } while ( cmatch(','));
    return 1;
}

// Only called for globals
Type *dodeclare(enum storage_type storage)
{
    Type  *base_type = NULL;
    SYMBOL *sym;

    while ( 1 ) {
        Type *type = dodeclare2(&base_type);
        
        if ( type == NULL ) {
            break;
        }

        blanks();
        if ( strlen(type->name) == 0 ) {
            // Struct defined
            needchar(';');
            return type;
        }
        sym = addglb(type->name, ID_VARIABLE, type->kind, 0, storage);
        sym->ctype = type;
        sym->isassigned = 1; // Assigned to 0

        /* We can catch @ here? Need to flag sym somehow */
        if ( cmatch('@')) {
            Kind valtype;
            double val;

            constexpr(&val,&valtype, 1);

            type->value = val;
            sym->storage = EXTERNP;
            sym->initialised = 1;
        }


 

        if ( rcmatch('{')) {
            declfunc(type, storage);
            return type;
        } else  if ( cmatch(';')) {
            return type;
        } else if ( cmatch(',')) {
            continue;
        } 
        needchar('=');
        sym->initialised = 1;
        initials(type->name, type);
        if ( cmatch(';')) {
            return type;
        }
        needchar(',');
    }
    return NULL;
}

Type *make_type(Kind kind, Type *tag)
{
    Type *type = CALLOC(1,sizeof(*type));

    type->len = 1;
    type->kind = kind;
    switch ( kind ) {
    case KIND_CHAR:
        type->size = 1;
        break;
    case KIND_INT:
        type->size = 2;
        break;
    case KIND_CPTR:
        type->size = 3;  // TODO: far flag
        break;
    case KIND_LONG:
        type->size = 4;
        break;
    case KIND_DOUBLE:
        type->size = 6;
        break;
    case KIND_STRUCT:
        // TODO
        break;
    default:
        type->size = 2;
        break;
    }
    return type;
}

// Parse a declaration
Type *dodeclare2(Type **base_type)
{
    char namebuf[NAMESIZE];
    Type *type;
    int   flags = 0;

    if ( base_type != NULL && *base_type != NULL ) {
        type = CALLOC(1,sizeof(*type));
        *type = **base_type;
    } else {
        if ( (type = parse_type()) == NULL ) {
            return NULL;
        }
        if ( base_type )
            *base_type = type;
            
        // Parse for z88dk flags
        while (blanks(), rcmatch('_')) {
            if ( amatch("__LIB__") ) {
                flags |= LIBRARY;
            } else if ( amatch("__CALLEE__") ) {
                flags |= CALLEE;
            } else if ( amatch("__SHARED__") ) {
                flags |= SHARED;
            } else if ( amatch("__SHAREDC__") ) {
                flags |= SHAREDC;
            } else if ( amatch("__FASTCALL__") ) {
                flags |= FASTCALL;
            } else if ( amatch("__SAVEFRAME__") ) {
                flags |= SAVEFRAME;
            } else {
                break;
            }
        }
    }

    // For port8/16 don't do much else beyond 
    if ( type->kind == KIND_PORT8 || type->kind == KIND_PORT16 ) {
        double dval;
        Kind   valtype;

        constexpr(&dval, &valtype, 1);
        if (dval < 0) {
            error(E_NEGATIVE);
            dval = (-dval);
        }
        if ( valtype == KIND_DOUBLE )
            warning(W_DOUBLE_UNEXPECTED);
        type->value = dval;

        if ( symname(type->name) == 0 ) 
            illname(type->name);
        return type;
    }

    if ( type->kind == KIND_STRUCT && rcmatch(';')) {        
        return type;
    }

    type = parse_decl(namebuf, type);

    if ( type != NULL ) {
        strcpy(type->name, namebuf);
    }

    if ( type->kind == KIND_FUNC ) {
        type->flags |= flags;
    }

    return type;
}

Type *default_function(const char *name)
{
    Type *type = CALLOC(1,sizeof(*type));

    strcpy(type->name, name);
    type->kind = KIND_FUNC;
    type->oldstyle = 1;
    type->return_type = type_int;

    if ( c_use_r2l_calling_convention == NO ) {
        type->flags |= SMALLC;
    }
    return type;
}


void declare_func_kr()
{
    char   sname[NAMESIZE];
    Type  *func;
  
    if ( symname(sname) == 0 ) {
        return;
    }
    needchar('(');

    func = CALLOC(1,sizeof(*func));    
    func->kind = KIND_FUNC;
    func->size = 0;
    func->len = 1;        
    func->return_type = type_int;
    strcpy(func->name, sname);
    func->parameters = array_init(NULL);       

    while ( cmatch(')') == 0 ) {
        Type *param = CALLOC(1,sizeof(*param));
        *param = *type_int;  // Implicitly int
        if ( symname(param->name) == 0 ) {
            error(E_ARGNAME);
            junk();
        } else {
            if ( check_existing_parameter(func, param) == 0 ) 
                array_add(func->parameters, param);
        }

        if (ch() != ')' && cmatch(',') == 0) {
            warning(W_EXPCOM);
        }
    }
    parse_trailing_modifiers(func);
    handle_kr_type_parameters(func);
    // And start the function
    declfunc(func, STATIK);
}

static void handle_kr_type_parameters(Type *func)
{
    Type  *param;
    Type  *base_type = NULL;

    while ( !rcmatch('{')) {
        int    i;
        param = dodeclare2(&base_type);
        if ( param == NULL ) {
            break;
        }
        for ( i = 0; i < array_len(func->parameters); i++ ) {
            Type *existing = array_get_byindex(func->parameters,i);
            if ( strcmp( existing->name, param->name) == 0 ) {
                // Found the argument
                *existing = *param;
                break;
            }
        }
        if ( i == array_len(func->parameters) ) {
            printf("Found declaration for unknown parameter");
        }
        if ( cmatch(',')) {
            // Nothing
        } else {
            needchar(';');
            base_type = NULL;
        }
    }
}

static void declfunc(Type *type, enum storage_type storage)
{
    int where;

    currfn = findglb(type->name);
    
    if ( currfn != NULL ) {
        // TODO: Check that parameters match
    } else {
        currfn = addglb(type->name, ID_VARIABLE, type->kind, 0, storage);
        currfn->ctype = type;   
    }

    // Reset all local variables
    locptr = STARTLOC;
    // Setup local variables
    output_section(c_code_section);
    
    nl();
    prefix();
    outname(currfn->name, dopref(currfn));
    col(); /* print function name */
    if (dopref(currfn) == NO) {
        nl();
        prefix();
        outname(currfn->name, YES);
        col();
    }
    nl();

    infunc = 1; /* In a function for sure! */
    
    if (((type->flags & SHARED) && c_makeshare) || c_shared_file) {
        /* Shared library definition, offset the stack */
        where = 2 + c_share_offset;
    } else
        where = 2;
    /* If we use frame pointer we preserve previous framepointer on entry
        * to each function
        */
    if (c_framepointer_is_ix != -1 || (type->flags & (SAVEFRAME|NAKED)) == SAVEFRAME )
        where += 2;

    if ( (type->flags & (CRITICAL|NAKED)) == CRITICAL ) {
        where += zcriticaloffset();
    }
    
    /* main is always __stdc */
    if ( strcmp(currfn->name,"main") == 0 ) {
        currfn->flags &= ~SMALLC;
    }
    
    // TODO: If any parameters don't have a name then error

    /* For SMALLC we need to start counting from the last argument */
    if ( (type->flags & SMALLC) == SMALLC ) {
        int i;
        for ( i = array_len(currfn->ctype->parameters) - 1; i >= 0; i-- ) {
            SYMBOL *ptr;
            Type *type = array_get_byindex(currfn->ctype->parameters, i);

            if ( strlen(type->name) == 0 ) {
                errorfmt("Function parameters (argument %d) must be named when defining a function\n",i);
                return;
            }
            // Create a local variable
            ptr = addloc(type->name, ID_VARIABLE, type->kind);
            ptr->ctype = type;
            ptr->offset.i = where;
            ptr->isassigned = 1;
            where += type->size;
        }
    } else {
        int i;
        for ( i = 0; i < array_len(currfn->ctype->parameters); i++ ) {
            SYMBOL *ptr;
            Type *type = array_get_byindex(currfn->ctype->parameters, i);
            if ( strlen(type->name) == 0 ) {
                errorfmt("Function parameters (argument %d) must be named when defining a function\n",i);
                return;
            }
            // Create a local variable
            ptr = addloc(type->name, ID_VARIABLE, type->kind);
            ptr->ctype = type;            
            ptr->offset.i = where;
            ptr->isassigned = 1;            
            where += type->size;
        }
    }
        
    
    if ( (type->flags & CRITICAL) == CRITICAL ) {
        zentercritical();
    }
    pushframe();
    if (array_len(currfn->ctype->parameters) && (type->flags & (FASTCALL|NAKED)) == FASTCALL ) {
        Type *type = array_get_byindex(currfn->ctype->parameters,0);
        int   adjust = 1;

        if ( type->size == 2 ) 
            zpush();
        else if ( type->size == 4)
            lpush();
        else if ( type->kind == KIND_DOUBLE )
            dpush();
        else
            adjust = 0;

        if ( adjust ) {
            SYMBOL *ptr = findloc(type->name);
            if ( ptr ) {
                ptr->offset.i -= type->size;
                where = 2;
            }
        }
    }
    
    stackargs = where;
    if (statement() != STRETURN) {
        /* do a statement, but if it's a return, skip */
        /* cleaning up the stack */
        leave(NO, NO, 0);
    }
    goto_cleanup();
    function_appendix(currfn);

#ifdef INBUILT_OPTIMIZER
    generate();
#endif
    infunc = 0; /* not in fn. any more */
}
