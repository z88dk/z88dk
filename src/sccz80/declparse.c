 
#include "ccdefs.h"
#include "define.h" 


Type   *type_void = &(Type){ KIND_VOID, 1, 0 };
Type   *type_carry = &(Type){ KIND_CARRY, 1, 0 };
Type   *type_char = &(Type){ KIND_CHAR, 1, 0 };
Type   *type_uchar = &(Type){ KIND_CHAR, 1, 1 };
Type   *type_int = &(Type){ KIND_INT, 2, 0 };
Type   *type_uint = &(Type){ KIND_INT, 2, 1 };
Type   *type_long = &(Type){ KIND_LONG, 4, 0 };
Type   *type_ulong = &(Type){ KIND_LONG, 4, 1 };
Type   *type_double = &(Type){ KIND_DOUBLE, 6, 0 };

static int32_t needsub(void)
{
    double  val;
    int     valtype;

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
    int valtype;
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




Type *dodeclare2();

Type *global_hash = NULL;

Type *find_enum(const char *name)
{
    Type *t;
    HASH_FIND_STR(global_hash, name, t);
    return t;
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

void add_global(Type *type)
{
    // addglb()
    HASH_ADD_STR(global_hash, name, type);
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
    type->kind = KIND_INT;
    type->isconst = 1;
    strcpy(type->name, name);
    type->value = value;

    ptr = addglb(type->name, ID_VARIABLE, KIND_ENUM, 0, STATIK, 0, 0);
    ptr->ctype = type;
    ptr->size = value;

    return type;
}

Type *make_enum(const char *name)
{
    Type *type = CALLOC(1,sizeof(*type));

    type->fields = array_init(NULL);    
    type->kind = KIND_ENUM;
    type->size = 2;
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



static Type *parse_enum(Type *type)
{
    Type *ptr;
    char sname[NAMESIZE];
    static int num_enums_defined = 0;

    type->kind = KIND_INT;
    type->isunsigned = c_default_unsigned;
    if ( symname(sname) == 0 )
        snprintf(sname, sizeof(sname),"0sc_i_enumb%d", num_enums_defined++);
    
    if ( (ptr = find_enum(sname)) == NULL ) {
        int32_t  value = 0;

        add_global(ptr = make_enum(sname));
        needchar('{');
        do {
            Type *elem;
            if (symname(sname) == 0)
                illname(sname);
            if (cmatch('=')) {
                double dval;
                int    valtype;

                constexpr(&dval, &valtype, 1);
                if ( valtype == KIND_DOUBLE )
                    warning(W_DOUBLE_UNEXPECTED);
                value = dval;
            }
            elem = make_constant(sname, value);
            array_add(ptr->fields, elem);  // Keep reference to the enum value so we validate switches..
            add_global(elem);
            
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
            elem = dodeclare2(0);
            
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
    
    type->tag = str;
    type->size = str->size;
    return type;
}

// Read the base type 
static Type *parse_type(void)
{
    Type *type = CALLOC(1,sizeof(*type));

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
    } 
    // } else if ( chase_typedef(type) < 0 ) 
    //     return NULL;

    // Successful
    return type;
}



Type *parse_parameter_list(Type *return_type)
{
    Type *func;
    Type *param;

    needchar('(');

    if ( rcmatch(')') ) {
        func = CALLOC(1,sizeof(*func));
        func->kind = KIND_FUNC;
        func->size = 0;
        func->oldstyle = 1;  // i.e. arbitrary number of parameters
        func->return_type = return_type;
        func->parameters = array_init(free_type);
        return func;
    }

    do {
        func = CALLOC(1,sizeof(*func));
        func->kind = KIND_FUNC;
        func->size = 0;
        func->return_type = return_type;
        func->parameters = array_init(NULL);        
        
        // TODO: K&R
        param = dodeclare2(); // STORAGE_AUTO);
        
        // A void type by itself, no parameters
        if ( param->kind == KIND_VOID ) {
            break;
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
            array_add(func->parameters, param);
        }
        if ( !rcmatch(',')) 
            break;
        needchar(',');
    } while (1);
    needchar(')');
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

int declare_local(int isstatic)
{
    return 0;
}

Type *parse_expr_type()
{
    return NULL;
}

Type *dodeclare(enum storage_type storage)
{
    while ( 1 ) {
        Type *type = dodeclare2();
        
        if ( type == NULL ) {
            break;
        }
        if ( cmatch(';')) {
            if ( storage == STKLOC ) {
                SYMBOL *ptr = addloc(type->name, ID_VARIABLE, type->kind, 0, 0);
                ptr->ctype = type;
            } else {
                SYMBOL *ptr = addglb(type->name, ID_VARIABLE, type->kind, 0, storage, 0, 0);
                ptr->ctype = type;
            }
            return NULL;
        } else {
            return type;
        }
    }
    return NULL;
}

// Parse a declaration
Type *dodeclare2()
{
    char namebuf[NAMESIZE];
    Type *type;

    if ( (type = parse_type()) == NULL ) {
         return NULL;
    }

    // For port8/16 don't do much else beyond 
    if ( type->kind == KIND_PORT8 || type->kind == KIND_PORT16 ) {
        double dval;
        int    valtype;

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
        // TODO: Put in hash?
        return type;
    }

    type = parse_decl(namebuf, type);

    if ( type != NULL ) {
        strcpy(type->name, namebuf);
    }

    /* We can catch @ here */
    if ( cmatch('@')) {

    }

    return type;
}