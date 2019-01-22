 
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
        errorfmt("Negative Size Illegal", 0);
        val = (-val);
    }
    if (valtype == KIND_DOUBLE)
        warningfmt("unknown","Unexpected floating point encountered, taking int value");
    needchar(']'); /* force single dimension */
    return (val); /* and return size */
}


static void swallow_bitfield(void)
{
    double val;
    Kind   valtype;
    if (cmatch(':')) {
        constexpr(&val, &valtype, 1);
        warningfmt("unsupported-feature","Bitfields not supported by compiler");
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
    size_t   i = arr->size++;
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




Type *dodeclare2(Type **base_type, decl_mode mode);


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
    size_t    i;
    for ( i = 0; i < array_len(tag->fields) ; i++ ) {
        Type *field = array_get_byindex(tag->fields, i);

        // Consider anonymous structs
        if ( strlen(field->name) == 0 && field->kind == KIND_STRUCT ) {
            size_t offset = field->offset;
            field = find_tag_field(field->tag, fieldname);

            // If we found it, return a copy of it and adjust the offset
            if ( field ) {
                Type *ret = CALLOC(1,sizeof(*ret));
                *ret = *field;
                ret->offset += offset;
                return ret;
            }
            continue;
        }
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

    ptr = addglb(type->name, type, ID_VARIABLE, KIND_ENUM, 0, STATIK);
    ptr->size = value;
    ptr->isassigned = 1;

    return type;
}

Type *make_enum(const char *name)
{
    Type *type = CALLOC(1,sizeof(*type));

    type->fields = array_init(NULL);    
    type->kind = KIND_INT; /// Erk
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
    type->isunsigned = 1;
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
        snprintf(sname, sizeof(sname),"0__anonenum_%d", num_enums_defined++);
    
    if ( (ptr = find_enum(sname)) == NULL ) {
        ptr = make_enum(sname);
        addglb(sname, ptr,  ID_ENUM, type->kind, 0, LSTATIC);

        // Forward definition
        if ( rcmatch(';')) {
            return ptr;
        }
    }

    if ( array_len(ptr->fields) && rcmatch('{')) {
        // Redefinition
        SYMBOL *sym = findglb(sname);
        errorfmt("Redefinition of enum '%s', previously defined at %s",1, sname, sym->declared_location);
        junk();
    } else if ( array_len(ptr->fields) == 0 && rcmatch('{')) {
        int32_t  value = 0;        
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
                    warningfmt("unknown","Unexpected floating point encountered, taking int value");
                value = dval;
            }
            elem = make_constant(sname, value);
            array_add(ptr->fields, elem);  // Keep reference to the enum value so we validate switches..            
            value++;
        } while (cmatch(',') && !rcmatch('}'));
        needchar('}');
    } 
    return ptr;
}

Type *parse_struct(Type *type, char isstruct)
{
    char    sname[NAMESIZE];
    Type   *str = NULL;
    size_t  offset = 0;
    int     size = 0;
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
        snprintf(str->name, sizeof(str->name), "0__anon%s_%d", isstruct ? "struct" : "union", num_structs++);
        str->kind = KIND_STRUCT;
        str->fields = array_init(free_type); 
        str->weak = 1;
        str->size = -1;
        str->isstruct = isstruct;        
        add_tag(str);        
    } 
    if ( rcmatch('{')) {
        Type *elem;
        Type *base_type = NULL;        
        needchar('{');
        do {
            // Read each field now */
            blanks();
            elem = dodeclare2(&base_type, MODE_NONE);
            
            if ( elem != NULL ) {
                if ( strlen(elem->name) == 0 && elem->kind != KIND_STRUCT ) {
                    errorfmt("Member variables must be named",1);
                }
                elem->offset = offset;
                if ( isstruct ) {
                    // Accept arr[0] as a synonym for arr[] for flexible members
                    if ( elem->size == 0 && elem->kind == KIND_ARRAY ) {
                        elem->size = -1;
                        elem->len = -1;
                    }
                    if ( elem->size != -1 ) {
                        offset += elem->size;
                        size += elem->size;
                    }
                } else { 
                    if ( elem->size > size ) size = elem->size;
                }
                array_add(str->fields, elem);
            } else {
                break;
            }
            // Swallow bitfields
            swallow_bitfield();

            // It was a flexible member, this needs to be last in the sturct
            if ( elem->size <= 0 ) {
                if ( rcmatch(';') == 0 ) {
                    errorfmt("Flexible member needs to be last element of struct",1);
                }
                needchar(';');
                if ( rcmatch('}') == 0 ) {
                    errorfmt("Flexible member needs to be last element of struct",1);
                }
                break;
            }

            if ( rcmatch('}')) 
                break;
            if ( cmatch(';')) {
                base_type = NULL;
                continue;
            }
            needchar(',');
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
            char wasconst = type->isconst;
            /* So we've identified it, we should copy it */
            *type = *ptr->ctype;
            type->isconst |= wasconst;
            return 0;
        }
    }
    return -1;
}

// Read the base type 
static Type *parse_type(void)
{
    Type *type = CALLOC(1,sizeof(*type));
    int   typed = 0;


    swallow("register");
    swallow("auto");
    type->len = 1;
    if ( swallow("const")) {
        type->isconst = 1;
    } else if (swallow("volatile")) {
        //warningfmt("unsupported-feature","Volatile type not supported by compiler");
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

    if ( amatch("signed")) {
        type->isunsigned = 0;
        type->kind = KIND_INT;
        type->size = 2;
        typed = 1;
    } else if ( amatch("unsigned")) {
        type->isunsigned = 1;
        type->kind = KIND_INT; 
        type->size = 2;        
        typed = 1;
    }
    
    if ( amatch("char"))  {
        type->kind = KIND_CHAR;
        type->size = 1;
    } else if ( amatch("int") || amatch("short")) {
        swallow("int");        
        type->kind = KIND_INT;
        type->size = 2;
    } else if ( amatch("long")) {
        swallow("int");
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
    } else if ( chase_typedef(type) < 0 && typed == 0 ) {
        FREENULL(type);
        return NULL;
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
        } else if ( amatch("__z88dk_sdccdecl")) {
            type->flags |= SDCCDECL;
            type->flags &= ~(SMALLC|FLOATINGDECL);
            continue;
        } else if ( amatch("__z88dk_params_offset")) {
            needchar('(');
            double   val;
            Kind     valtype;

            if (constexpr(&val,&valtype, 1) == 0 ) {
                errorfmt("Expecting a constant expression for __z88dk_params_offset", 1);
                val = 0;
            }
            type->funcattrs.params_offset = val;
            needchar(')');
        } else if ( amatch("__z88dk_shortcall")) { // __z88dk_shortcall(rstnumber, value)
            double   rstnumber,val;
            Kind  valtype;

            needchar('(');
            if (constexpr(&rstnumber,&valtype, 1) == 0 ) {
                errorfmt("Expecting a restart number",1);
            } else {
                if ( rstnumber < 0 || rstnumber > 0x38 || ((int)rstnumber % 8 ) ) {
                    errorfmt("Invalid rst number: %d",1, (int)rstnumber);
                } 
                needchar(',');
                if (  constexpr(&val,&valtype, 1) == 0 ) {
                    errorfmt("Expecting a constant call number",1);
                } else {
                    if ( val < 0 || val > 65535 ) {
                        errorfmt("Short call value is out of range (%x)",1, (int)val);
                    }
                    type->flags |= SHORTCALL;
                    type->funcattrs.shortcall_rst = rstnumber;
                    type->funcattrs.shortcall_value = val;
                }
            }
            needchar(')');
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

    if ( (type->flags & (NAKED|CRITICAL) ) == (NAKED|CRITICAL) ) {
        errorfmt("Function '%s' is both __naked and __critical, this is not permitted", 1, type->name);
    }
}

static int check_existing_parameter(Type *func, Type *param)
{
    int    i;

    for ( i = 0; i < array_len(func->parameters); i++ ) {
        Type *existing = array_get_byindex(func->parameters,i);

        if ( strlen(param->name) && strcmp(existing->name, param->name) == 0 ) {
            errorfmt("A parameter named %s has already been defined for function",1, param->name);
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
        func->funcattrs.oldstyle = 1;  // i.e. arbitrary number of parameters
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
        param = dodeclare2(NULL, MODE_NONE); // STORAGE_AUTO);

        if ( param == NULL ) {
            // KR Fake an argument
            iskr = 1;            
            param = CALLOC(1,sizeof(*param));
            *param = *type_int;  // Implicitly int
            if ( symname(param->name) == 0 ) {
                errorfmt("Illegal Argument Name: %s", 0, param->name);
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
        if ( param->kind == KIND_STRUCT ) {
            Type *ptr = make_pointer(param);            
            warningfmt("conversion","Cannot pass a struct by value, converting to pointer to struct");
            strcpy(ptr->name, param->name);
            param = ptr;        
        }
        if ( param->kind == KIND_ELLIPSES) {
            if ( array_len(func->parameters)  ) {
                array_add(func->parameters, param);    
                func->funcattrs.hasva = 1;            
            } else {                    
                errorfmt("Ellipses must follow a parameter",1);
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
        errorfmt("Can't define a function returning a function",1);
        return NULL;
    }
    if ( base_type->kind == KIND_ARRAY ) {
        errorfmt("Can't define a function returning an array",1);
        return NULL;
    }
    if ( base_type->kind == KIND_STRUCT ) {
        Type *ptr = make_pointer(base_type);
        warningfmt("conversion","Can't define a function returning an struct, converting to a pointer");
        strcpy(ptr->name, base_type->name);
        base_type = ptr;
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
            errorfmt("Pointer to what exactly?",1);
            junk();
            return NULL;
        }
        if ( amatch("__far"))
            base_type->isfar = 1;
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
    Type *type = dodeclare2(NULL, MODE_CAST);

    if ( type && strlen(type->name)) {
        warningfmt("invalid-cast-syntax","We're not expecting name '%s' with cast expression",type->name);
    }

    return type;
}

/** \brief Declare a local variableif we need to
 */
int declare_local(int local_static)
{
    Type *type;
    Type *base_type = NULL;
    SYMBOL *sym;

    do {
        type = dodeclare2(&base_type, MODE_NONE);
        if ( type == NULL ) {
            return 0;
        }
        if ( local_static ) {
            char  namebuf[NAMESIZE * 2 + 10];
            snprintf(namebuf, sizeof(namebuf),"st_%s_%s", currfn->name, type->name);
            sym = addglb(namebuf, type, ID_VARIABLE, type->kind, 0, LSTATIC);
            if ( cmatch('=')) {
                sym->isassigned = 1;
                sym->initialised = 1;
                initials(namebuf, type);                
            } else {
                sym->bss_section = strdup(c_bss_section);
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

                    if ( expr_type->kind == KIND_VOID ) {
                        warningfmt("void","Assigning from a void expression");
                    }
                    
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
                        force(type->kind, expr, type->isunsigned, expr_type->isunsigned, 0);
                    }
                    StoreTOS(type->kind);
                }
            }
        }
    } while ( cmatch(','));
    needchar(';');
    return 1;
}

// Only called for globals
Type *dodeclare(enum storage_type storage)
{
    Type  *base_type = NULL;
    SYMBOL *sym;
    decl_mode mode = MODE_NONE;
    int32_t    ataddress = -1;

    if ( storage == TYPDEF ) mode = MODE_TYPEDEF;
    else if ( storage == EXTERNAL ) mode = MODE_EXTERN;


    if ( amatch("__at")) {
        Kind valtype;
        double val;

        needchar('(');
        constexpr(&val,&valtype, 1);
        needchar(')');
        ataddress = val;
    }

    while ( 1 ) {
        Type *type = dodeclare2(&base_type, mode);
        char  drop_name[NAMESIZE * 2];
        int   alloc_size;
        
        if ( type == NULL ) {
            break;
        }

        blanks();
        if ( strlen(type->name) == 0 ) {
            // Struct defined
            needchar(';');
            return type;
        }

        // Main is __stdc
        if ( strcmp(type->name,"main") == 0 && type->kind == KIND_FUNC) {
            type->flags &= ~(SMALLC|FLOATINGDECL|CALLEE|FASTCALL);
        }

        if ( type->kind == KIND_FUNC && (type->flags & (FASTCALL|SMALLC)) == FASTCALL && array_len(type->parameters) > 1) {
            warningfmt("incorrect-function-declspec","Cannot define function '%s' as __z88dk_fastcall __stdc when it has more than 1 argument",type->name);
            type->flags ^= FASTCALL;
        }

        if ( rcmatch('{') && type->kind == KIND_FUNC) {
            declfunc(type, storage);
            return type;
        }

        sym = addglb(type->name, type, ID_VARIABLE, type->kind, 0, storage);
        sym->isassigned = 1; // Assigned to 0
     
        snprintf(drop_name, sizeof(drop_name), "%s", type->name);


        // Handle the @ syntax. If the address is wrapped in ( ) then we can assign something to it
        if ( cmatch('@')) {
            Kind valtype;
            double val;
            char brackets = 0;

            
            if ( cmatch('(')) {
                brackets = 1;
            }

            constexpr(&val,&valtype, 1);

            if ( brackets ) {
                needchar(')');
            }

            // If initialised, the drop name should be something different
            snprintf(drop_name, sizeof(drop_name), "__extern_%s", type->name);            
            type->value = val;
            sym->storage = EXTERNP;
            sym->initialised = 1;
        }

        // Handle the sdcc way of declaring variables at address
        if ( ataddress != -1 ) {
            type->value = ataddress;
            sym->storage = EXTERNP;
            sym->initialised = 1;
            // If initialised, the drop name should be something different
            snprintf(drop_name, sizeof(drop_name), "__extern_%s", type->name);                        
        }

         if ( cmatch(';')) {
             // Maybe not right
            sym->bss_section = strdup(c_bss_section);

            return type;
        } else if ( cmatch(',')) {
            sym->bss_section = strdup(c_bss_section);
            continue;
        } 

        if ( type->kind == KIND_FUNC ) {
            errorfmt("Cannot initialise function '%s' to a constant", 1, type->name);
            junk();
            return type;
        }

        needchar('=');
        sym->initialised = 1;

        alloc_size = initials(drop_name, type);

        if ( sym->storage == EXTERNP ) {
            // Copy from local to the supplied address
            output_section(c_init_section);
            copy_to_extern(drop_name, type->name, alloc_size);
        }

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
        type->size = tag->size;
        break;
    default:
        type->size = 2;
        break;
    }
    return type;
}

// Parse a declaration
// mode = 0 = normal
// mode = 1 = typedef
// mode = 2 = cast
Type *dodeclare2(Type **base_type, decl_mode mode)
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
            errorfmt("Negative Size Illegal", 0);
            dval = (-dval);
        }
        if ( valtype == KIND_DOUBLE )
            warningfmt("invalid-value","Unexpected floating point encountered, taking int value");
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

    // Validate that structs are not weak if we have an instance
    if ( type->kind == KIND_STRUCT ) {
        if ( type->tag->weak && mode == MODE_NONE ) {
            errorfmt("Cannot not declare an instance of incompletely defined struct '%s'",1,type->tag->name);
        }
        if ( type->size == -1 ) {
            type->size = type->len * type->tag->size;
        }
    }

    if ( ispointer(type) && type->ptr->kind == KIND_FUNC ) {
        /* Function pointers, fastcall isn't valid */
        if ( type->ptr->flags & FASTCALL ) {
            warningfmt("invalid-function-declspec","FASTCALL is not a valid modifier for function pointers");
            type->ptr->flags &= ~FASTCALL;
        }
    }

    return type;
}

Type *default_function(const char *name)
{
    return default_function_with_type(name, type_int);
}

Type *default_function_with_type(const char *name, Type *return_type)
{
    Type *type = CALLOC(1,sizeof(*type));

    strcpy(type->name, name);
    type->kind = KIND_FUNC;
    type->funcattrs.oldstyle = 1;
    type->return_type = return_type;
    type->parameters = array_init(NULL);
    type->size = 0;
    type->len = 1;

    if ( c_use_r2l_calling_convention == NO ) {
        type->flags |= SMALLC;
        type->flags &= ~FLOATINGDECL;
    }
    return type;
}

Type *asm_function(const char *name)
{
    Type *type = CALLOC(1,sizeof(*type));

    strcpy(type->name, name);
    type->kind = KIND_FUNC;
    type->funcattrs.oldstyle = 1;
    type->return_type = type_ulong;
    type->parameters = array_init(NULL);
    array_add(type->parameters, make_pointer(type_char));
    type->size = 0;
    type->len = 1;

    return type;
}


void declare_func_kr()
{
    char   sname[NAMESIZE];
    Type  *func;
  
    if ( symname(sname) == 0 ) {
        junk();
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
        /* Check for a type, we may have an implicit int function return */
        Type *param = parse_type();

        if ( param != NULL ) {
            param = dodeclare2(&param, MODE_NONE);
        } else {
            param = make_type(KIND_INT, NULL);
            if ( symname(param->name) == 0 ) {
                errorfmt("Illegal Argument Name: %s", 0, param->name);
                junk();
            }
        }
        if ( check_existing_parameter(func, param) == 0 ) 
            array_add(func->parameters, param);
    
        if (ch() != ')' && cmatch(',') == 0) {
            warningfmt("syntax","Expected ','");
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
        param = dodeclare2(&base_type, MODE_NONE);
        if ( param == NULL ) {
            break;
        }
        if ( param->kind == KIND_ARRAY ) {
            Type *ptr = make_pointer(param->ptr);
            strcpy(ptr->name, param->name);
            param = ptr;
        }
        if ( param->kind == KIND_STRUCT ) {
            Type *ptr = make_pointer(param);            
            warningfmt("conversion","Cannot pass a struct by value, converting to pointer to struct");
            strcpy(ptr->name, param->name);
            param = ptr;
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
            warningfmt("invalid-function-definition","Found K&R declaration for unknown parameter '%s' for function '%s'",param->name, func->name);
        }
        if ( cmatch(',')) {
            // Nothing
        } else {
            needchar(';');
            base_type = NULL;
        }
    }
}

void flags_describe(Type *type, int32_t flags, UT_string *output)
{
    if ( flags & SDCCDECL ) {
        utstring_printf(output,"__z88dk_sdccdecl ");
    }
    if ( (flags & SMALLC) == SMALLC && (flags & FLOATINGDECL) == 0) {
        utstring_printf(output,"__smallc ");
    }
    if ( (flags & SMALLC) == 0 && (flags & FLOATINGDECL) == 0) {
        utstring_printf(output,"__stdc ");
    }
    if ( flags & FASTCALL ) {
        utstring_printf(output,"__z88dk_fastcall ");
    }
    if ( flags & CALLEE ) {
        utstring_printf(output,"__z88dk_callee ");
    }  
    if ( flags & SAVEFRAME ) {
        utstring_printf(output,"__z88dk_saveframe ");
    }  
    if ( flags & NAKED ) {
        utstring_printf(output,"__naked ");
    }  
    if ( flags & CRITICAL ) {
        utstring_printf(output,"__critical ");
    }  

    if ( flags & SHORTCALL ) {
        utstring_printf(output,"__z88dk_shortcall(%d,%d) ", type->funcattrs.shortcall_rst, type->funcattrs.shortcall_value);
    }

    if ( type->funcattrs.params_offset ) {
        utstring_printf(output,"__z88dk_params_offset(%d) ", type->funcattrs.params_offset);
    }

}

void type_describe(Type *type, UT_string *output)
{
    char tail[100];
    int  i;

    tail[0] = 0;
    if ( type->ptr )
        type_describe(type->ptr,output);
   
    switch ( type->kind ) {
    case KIND_NONE:
        return;
    case KIND_VOID:
        utstring_printf(output, "void ");
        break;
    case KIND_CHAR:
        utstring_printf(output,"%schar ",type->isunsigned ? "unsigned " : "");
        break;
    case KIND_SHORT:
        utstring_printf(output,"%sshort ",type->isunsigned ? "unsigned " : "");
        break;
    case KIND_INT:
        utstring_printf(output,"%sint ",type->isunsigned ? "unsigned " : "");
        break;
    case KIND_LONG:
        utstring_printf(output,"%slong ",type->isunsigned ? "unsigned " : "");
        break;
    case KIND_FLOAT:
    case KIND_DOUBLE:    
        utstring_printf(output,"double ");
        break;
    case KIND_ARRAY:
        snprintf(tail, sizeof(tail),"[%d]",type->len);
        break;
    case KIND_PTR:
        utstring_printf(output,"*");
        break;
    case KIND_CPTR:
        utstring_printf(output,"*__far ");
        break;
    case KIND_STRUCT:
        utstring_printf(output,"%s %s ",type->tag->isstruct ? "struct" : "union", type->tag->name);
        break;
    case KIND_FUNC:
        type_describe(type->return_type, output);
        utstring_printf(output,"%s(",type->name);
        for ( i = 0; i < array_len(type->parameters) ; i++ ) {
            if ( i ) utstring_printf(output,", ");
            type_describe(array_get_byindex(type->parameters,i), output);
        }
        utstring_printf(output,")");
        return;
    case KIND_ELLIPSES:
        utstring_printf(output,"...");
        return;
    case KIND_PORT8:
    case KIND_PORT16:
    case KIND_ENUM:
    case KIND_CARRY:
        break;
    }
    utstring_printf(output,"%s%s",type->name,tail);
    return;
}

/**
 * Performs a rough match of types (ignoring array lengths)
 * 
 * t1 = prototype
 * t2 = definition
 */
int type_matches(Type *t1, Type *t2)
{
    int i;

    if ( t1->kind != t2->kind && !(ispointer(t1) && t2->kind == KIND_ARRAY) && !(ispointer(t2) && t1->kind == KIND_ARRAY) )
        return 0;

    if ( t1->isunsigned != t2->isunsigned )
        return 0;

    if ( t1->ptr && t2->ptr ) {
         if (type_matches(t1->ptr,t2->ptr) == 0 ) 
            return 0;
    } else if ( t1->ptr || t2->ptr ) {
        return 0;
    }

    if ( t1->return_type && t2->return_type ) {
        if (type_matches(t1->return_type,t2->return_type) == 0 )
            return 0;
    } else if ( t1->return_type || t2->return_type ) {
        return 0;
    }

    if ( t1->tag && t2->tag ) {
        if ( t1->tag != t2->tag ) 
           return 0;
    }  else if ( t1->tag || t2->tag ) {
       return 0;
    }

    if ( t1->fields && t2->fields) {
        if ( array_len(t1->fields) != array_len(t2->fields))
            return 0;
        for ( i = 0; i < array_len(t1->fields); i++ ) {
            Type *t1f = array_get_byindex(t1->fields, i);
            Type *t2f = array_get_byindex(t2->fields, i);
            if ( type_matches(t1f,t2f) == 0 )
                return 0;
        }
    } else if ( t1->fields || t2->fields ) {
        return 0;
    }

    if ( t1->funcattrs.oldstyle == 0 ) {                
        if ( t1->parameters && t2->parameters) {
            if ( array_len(t1->parameters) != array_len(t2->parameters))
                return 0;
            for ( i = 0; i < array_len(t1->parameters); i++ ) {
                Type *t1f = array_get_byindex(t1->parameters, i);
                Type *t2f = array_get_byindex(t2->parameters, i);
                if ( type_matches(t1f,t2f) == 0 )
                    return 0;
            }
        } else if ( t1->parameters || t2->parameters ) {
            return 0;
        }
    }

    /* If we get here then it's a good enough match */
    return 1;
}


static int get_parameter_size(Type *functype, Type *type)
{
    switch ( type->kind ) {
        case KIND_CHAR:
            return functype->flags & SDCCDECL ? 1 : 2;
        case KIND_CPTR:
            return 4;
        default:
            return type->size;
 }

}


static void declfunc(Type *type, enum storage_type storage)
{
    int where;


    currfn = findglb(type->name);
    
    if ( currfn != NULL ) {
        if ( currfn->func_defined ) {
            errorfmt("Function '%s' was already defined at %s", 1, type->name, currfn->declared_location);
            junk();
            return;
        }
        if ( storage == LSTATIC && currfn->storage != LSTATIC) {
            errorfmt("Static declaration of '%s' follows non-static declaration at %s",1,type->name, currfn->declared_location);
        }
        if ( type_matches(currfn->ctype, type) == 0 ) {
            UT_string *output;

            utstring_new(output);

            utstring_printf(output,"Definition of '%s': ", type->name);
            type_describe(type, output);
            utstring_printf(output," - does not match declaration at %s : ",currfn->declared_location);
            type_describe(currfn->ctype, output);            
            errorfmt("%s",0,utstring_body(output));
            utstring_free(output);
            if ( currfn->ctype->kind != KIND_FUNC ) {
                currfn = NULL;
                return;
            }
        }
        // Take the prototype flags
        type->flags = (type->flags & ~(SMALLC)) | currfn->ctype->flags;
        if ( currfn->ctype->funcattrs.params_offset ) 
            type->funcattrs.params_offset = currfn->ctype->funcattrs.params_offset;
        type->funcattrs.shortcall_rst = currfn->ctype->funcattrs.shortcall_rst;
        type->funcattrs.shortcall_value = currfn->ctype->funcattrs.shortcall_value;
    } else {
        currfn = addglb(type->name, type, ID_VARIABLE, type->kind, 0, storage);
    }
    currfn->func_defined = 1; 
    

    // Reset all local variables
    locptr = STARTLOC;
    // Setup local variables
    output_section(c_code_section);
    


    infunc = 1; /* In a function for sure! */
    
    where = 2 + currfn->ctype->funcattrs.params_offset;

    /* If we use frame pointer we preserve previous framepointer on entry
        * to each function
        */
    if (c_framepointer_is_ix != -1 || (type->flags & (SAVEFRAME|NAKED)) == SAVEFRAME )
        where += 2;

    if ( (type->flags & (CRITICAL|NAKED)) == CRITICAL ) {
        where += zcriticaloffset();
    }

    

    nl();
    {
        UT_string *str;

        utstring_new(str);
        flags_describe(type, type->flags, str);
        
        outfmt("; Function %s flags 0x%08x %s\n",type->name,type->flags, utstring_body(str));
        utstring_renew(str);
        type_describe(type, str);        
        outfmt("; %s\n", utstring_body(str));
        utstring_free(str);
    }
    /* For SMALLC we need to start counting from the last argument */
    if ( (type->flags & SMALLC) == SMALLC ) {
        int i;

        for ( i = array_len(type->parameters) - 1; i >= 0; i-- ) {
            SYMBOL     *ptr;
            UT_string  *str;            
            Type       *ptype = array_get_byindex(type->parameters, i);

            utstring_new(str);

            if ( (strlen(ptype->name) == 0 || ptype->name[0] == '0') && ptype->kind != KIND_ELLIPSES) {
                errorfmt("Function parameters (argument %d) must be named when defining a function",1,i);
                continue;
            } 
            // Create a local variable
            ptr = addloc(ptype->name, ID_VARIABLE, ptype->kind);
            ptr->ctype = ptype;
            ptr->offset.i = where;
            type_describe(ptype, str);
            outfmt("; parameter '%s' at %d size(%d)\n",utstring_body(str),where, ptype->size);
            utstring_free(str);
            ptr->isassigned = 1;
            where += get_parameter_size(type,ptype);
        }
    } else {
        int i;
        for ( i = 0; i < array_len(type->parameters); i++ ) {
            SYMBOL    *ptr;
            UT_string *str;            
            Type      *ptype = array_get_byindex(type->parameters, i);

            utstring_new(str);
            
            if ( (strlen(ptype->name) == 0  || ptype->name[0] == '0') && ptype->kind != KIND_ELLIPSES) {
                errorfmt("Function parameters (argument %d) must be named when defining a function",1,i);
                continue;
            }
            // Create a local variable
            ptr = addloc(ptype->name, ID_VARIABLE, ptype->kind);
            ptr->ctype = ptype;            
            ptr->offset.i = where;

            type_describe(ptype, str);            
            outfmt("; parameter '%s' at %d size(%d)\n", utstring_body(str),where, ptype->size);  
            utstring_free(str);            
            ptr->isassigned = 1;            
            where += get_parameter_size(type, ptype);
        }
    }

    prefix();
    outname(currfn->name, dopref(currfn));
    col(); /* print function name */
    if (dopref(currfn) == NO) {
        nl();
        GlobalPrefix(); outname(currfn->name, YES); nl();
        prefix();
        outname(currfn->name, YES);
        col();
    }
    nl();
        
    
    if ( (type->flags & CRITICAL) == CRITICAL ) {
        zentercritical();
    }
    pushframe();
    if (array_len(currfn->ctype->parameters) && (type->flags & (FASTCALL|NAKED)) == FASTCALL ) {
        Type *type = array_get_byindex(currfn->ctype->parameters,array_len(currfn->ctype->parameters) - 1);
        int   adjust = 1;

        if ( type->size == 2 || type->size == 1) 
            zpush();
        else if ( type->size == 4 || type->size == 3)
            lpush();
        else if ( type->kind == KIND_DOUBLE )
            dpush();
        else
            adjust = 0;

        if ( adjust ) {
            SYMBOL *ptr = findloc(type->name);
            int     i;

            if ( ptr ) {
                ptr->offset.i -= (get_parameter_size(currfn->ctype,type) + 2);
                where = 2;
            }

            if ( currfn->ctype->flags & SMALLC ) {
                for ( i = 0; i < array_len(currfn->ctype->parameters) - 1; i++ ) {
                    Type *arg = array_get_byindex(currfn->ctype->parameters, i);
                    ptr = findloc(arg->name);
                    if ( ptr ) {
                        ptr->offset.i -= get_parameter_size(currfn->ctype,type);
                    }
                }
            }
        }
    }
    
    stackargs = where;
    lastst = STEXP;
    if (statement() != STRETURN && (type->flags & NAKED) == 0 ) {
        if ( type->return_type->kind != KIND_VOID && lastst != STASM) {
            warningfmt("return-type","Control reaches end of non-void function");
        }
        /* do a statement, but if it's a return, skip */
        /* cleaning up the stack */
        leave(NO, NO, 0);
    }
    goto_cleanup();
    function_appendix(currfn);

#ifdef INBUILT_OPTIMIZER
    generate();
#endif
    Zsp = 0;
    infunc = 0; /* not in fn. any more */
}
