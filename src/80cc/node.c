
#include "ccdefs.h"

/*
struct node {
    int         ast_type;
    char        declared_location[1024];
    Type       *type;
    union {
         int32_t   ival;  // char, int, long
         double    fval;  // Double
         char     *sval;  // String
         SYMBOL   *sym;   // Defining a variable - TODO, may change
         struct {
             struct node *left;
             struct node *right;
         };
         struct {
             struct node *operand;
         };
         struct {		// Ternary or if
             struct node *cond;
             struct node *then;
             struct node *else;
         };
         struct {		// Initialising variable
             struct node *declvar;
             array *declinit;
         };
         struct node *retval;   // Return value
         array *stmts;          // Compound statements
    }
};
*/

Node *ast_decl(SYMBOL *sym, Node *declvar)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_DECL;
    ret->sym = sym;
    ret->declvar = declvar;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_undecl(SYMBOL *sym)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_UNDECL;
    ret->sym = sym;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}


Node *ast_function_call(int ast_type, SYMBOL *sym, Type *func_type, array *args)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = ast_type;
    ret->sym = sym;
    ret->type = func_type;
    ret->args = args;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}


Node *ast_local_var(SYMBOL *sym, const char *name)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_LOCAL_VAR;
    ret->sym = sym;
    ret->type = sym->ctype;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}


Node *ast_global_var(SYMBOL *sym, const char *name)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_GLOBAL_VAR;
    ret->sym = sym;
    ret->type = sym->ctype;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_conditional(Node *cond, Node *then, Node *nelse) {
     Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_TERNARY;
    ret->cond = cond;
    ret->then = then;
    ret->els = nelse;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_binop(int ast_type, Node *left, Node *right) {
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = ast_type;
    ret->left = left;
    ret->right = right;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_uop(int ast_type, Node *op) {
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = ast_type;
    ret->operand = op;
    ret->filename = Filename;
    ret->line = lineno;
    return ret; 
}

Node *ast_return(Node *retval, Type *desired_return_type) {
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_RETURN;
    ret->type = desired_return_type;
    ret->retval = retval;
    ret->filename = Filename;
    ret->line = lineno;
    return ret; 
}

Node *ast_compound(array *nodes)
{
    Node *ret = calloc(1,sizeof(*ret));

    ret->ast_type = AST_COMPOUND_STMT;
    ret->stmts = nodes;

    return ret;
}

Node *ast_label(int label, const char *slabel)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_LABEL;
    ret->label = label;
    ret->labelname = slabel;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_jump(int label, const char *slabel)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_JUMP;
    ret->label = label;
    ret->labelname = slabel;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_literal(Type *type, zdouble value)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_LITERAL;
    ret->type = type;
    ret->zval = value;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_str_lit(int offs)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_STR_LIT;
    ret->type = make_pointer(c_default_unsigned ? type_uchar : type_char);
    ret->zval = (zdouble)offs;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}


Node *ast_critical(Node *node)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_CRITICAL;
    ret->operand = node;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_loop_countdown(Node *init, Node *body,
                         int exit_label, int step_label, int width8)
{
    Node *ret = calloc(1, sizeof(*ret));
    ret->ast_type = AST_LOOP_COUNTDOWN;
    ret->loop_init = init;
    ret->loop_body = body;
    ret->loop_exit_label = exit_label;
    ret->loop_step_label = step_label;
    ret->loop_width8 = width8 ? 1 : 0;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_preserve_bc(Node *child)
{
    Node *ret = calloc(1, sizeof(*ret));
    ret->ast_type = AST_PRESERVE_BC;
    ret->operand = child;
    ret->type = child ? child->type : NULL;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

/* Used as the declvar of an AST_DECL for stack-allocated arrays/structs
   with an aggregate or string initializer. The legacy parser stages the
   initializer values in the data section under `labelname` (size bytes)
   and emits copy_to_stack at that point; the AST captures the same
   info so a future codegen-from-AST consumer can re-emit the copy. */
Node *ast_init_static(const char *labelname, int size)
{
    Node *ret = calloc(1, sizeof(*ret));
    ret->ast_type = AST_INIT_STATIC;
    ret->label = size;
    ret->labelname = labelname;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

/* `asm("...")` / `__asm__("...")` / `#asm`/`#endasm` text captured during
   parsing. The asm text is copied into a heap string referenced via
   `labelname`; consumers that re-emit (codegen-from-AST) write it
   verbatim, the print walker shows it inline. */
Node *ast_asm(const char *text)
{
    Node *ret = calloc(1, sizeof(*ret));
    ret->ast_type = AST_ASM;
    ret->labelname = text ? strdup(text) : strdup("");
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

/* Aggregate / struct / string-array initializer list: holds the element
   AST nodes in source order. Used as the declvar of an AST_DECL when
   the initializer values are captured (see initials() / agg_init() /
   str_init() / init() in declinit.c). Nested for nested aggregates. */
Node *ast_init_list(array *elems)
{
    Node *ret = calloc(1, sizeof(*ret));
    ret->ast_type = AST_INIT_LIST;
    ret->stmts = elems ? elems : array_init(NULL);
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_switch(Type *sw_type, Node *sw_expr, Node *case_code,
                 array *cases, int default_label, int exit_label)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_SWITCH;

    ret->type = sw_type;
    ret->sw_expr = sw_expr;
    ret->sw_body = case_code;
    ret->sw_cases = cases ? cases : array_init(NULL);
    ret->sw_default_label = default_label;
    ret->sw_exit_label = exit_label;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}


Node *ast_switch_case(Type *sw_type, Node *value, int label)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_SWITCH_CASE;

    ret->type = sw_type;
    ret->sw_value = value;
    ret->sw_label = label;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_cast(Type *to, Node *value)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = OP_CAST;
    ret->type = to;
    ret->operand = value;
    return ret;
}

/* Append `:<type-and-flags>` to `output` if the verbose type-print
   mode is enabled and `type` is non-NULL. Trailing whitespace from
   type_describe / flags_describe is stripped. Used by print_ast to
   decorate AST_DECL / AST_LOCAL_VAR / AST_GLOBAL_VAR / AST_LITERAL /
   AST_FUNC_CALL with type+attribute info.

   `type_describe` is designed to render a *declaration* and trails
   the variable / function name from `type->name`. We blank that
   field temporarily to get the bare type form, since the AST node
   already prints the name itself. */
static void maybe_print_typed(UT_string *output, Type *type)
{
    if (!c_ast_print_types || !type) return;
    char saved[NAMESIZE];
    strncpy(saved, type->name, NAMESIZE);
    type->name[0] = 0;
    UT_string *t;
    utstring_new(t);
    flags_describe(type, type->flags, t);
    type_describe(type, t);
    int len = utstring_len(t);
    char *s = utstring_body(t);
    while (len > 0 && s[len - 1] == ' ') s[--len] = 0;
    if (len > 0) utstring_printf(output, ":%s", s);
    utstring_free(t);
    strncpy(type->name, saved, NAMESIZE);
}

static void print_uop(UT_string *output, char *op, Node *node) {
    utstring_printf(output,"(%s ",op);
    print_ast(output, node->operand);
    utstring_printf(output,")");
    maybe_print_typed(output, node->type);
}


static void print_binop(UT_string *output, char *op, Node *node) {
    utstring_printf(output,"(%s ",op);
    print_ast(output, node->left);
    utstring_printf(output," ");
    print_ast(output,node->right);
    utstring_printf(output,")");
    maybe_print_typed(output, node->type);
}

void print_ast(UT_string *output, Node *node) {
    if ( node == NULL ) {
        utstring_printf(output, "(noop)");
        return;
    };
   // utstring_printf(output, "Node type: %d",node->ast_type);
    switch ( node->ast_type) {
    case AST_DECL: {
        const char *nm = node->sym ? node->sym->name : "?";
        utstring_printf(output, "(decl %s", nm);
        if (node->sym && node->sym->ctype) maybe_print_typed(output, node->sym->ctype);
        if (node->declvar) {
            utstring_printf(output, " = ");
            print_ast(output, node->declvar);
        }
        utstring_printf(output, ")");
        break;
    }
    case AST_UNDECL:
        utstring_printf(output, "(undecl %s)",
                        node->sym ? node->sym->name : "?");
        break;
    case AST_LITERAL:
        if (node->type == NULL) {
            utstring_printf(output, "%.0Lf", node->zval);
        } else {
            switch (node->type->kind) {
            case KIND_INT:
            case KIND_CHAR:
            case KIND_SHORT:
            case KIND_LONG:
            case KIND_LONGLONG:
                utstring_printf(output, "%.0Lf", node->zval);
                break;
            case KIND_DOUBLE:
            case KIND_FLOAT16:
                utstring_printf(output, "%Lf", node->zval);
                break;
            default:
                /* numeric pointer literal (e.g. `(char *)0x1234`). */
                utstring_printf(output, "%.0Lf", node->zval);
                break;
            }
        }
        maybe_print_typed(output, node->type);
        break;
    case AST_STR_LIT:
        utstring_printf(output, "\"%s\"", litq + (int)node->zval + 1);
        maybe_print_typed(output, node->type);
        break;
    case AST_LOCAL_VAR:
        utstring_printf(output, "(lv=%s",
                        node->sym ? node->sym->name : "?");
        if (node->sym && node->sym->ctype) maybe_print_typed(output, node->sym->ctype);
        utstring_printf(output, ")");
        break;
    case AST_GLOBAL_VAR:
        utstring_printf(output, "(gv=%s",
                        node->sym ? node->sym->name : "?");
        if (node->sym && node->sym->ctype) maybe_print_typed(output, node->sym->ctype);
        utstring_printf(output, ")");
        break;
    case AST_FUNC_CALL:
        utstring_printf(output, "(call %s",
                        node->sym ? node->sym->name :
                        (node->type ? node->type->name : "?"));
        if (node->sym && node->sym->ctype) maybe_print_typed(output, node->sym->ctype);
        for ( int i = 0; i < array_len(node->args); i++ ) {
            utstring_printf(output, " ");
            print_ast(output, array_get_byindex(node->args,i));
        }
        utstring_printf(output, ")");
        break;
    case AST_FUNCPTR_CALL:
        utstring_printf(output, "(callptr ");
        print_ast(output, node->callee);
        for ( int i = 0; i < array_len(node->args); i++ ) {
            utstring_printf(output, " ");
            print_ast(output, array_get_byindex(node->args,i));
        }
        utstring_printf(output, ")");
        break;

    case AST_IF:
        utstring_printf(output, "(if ");
        print_ast(output, node->cond);
        utstring_printf(output, " ");
        print_ast(output, node->then);
        if ( node->els ) {
            utstring_printf(output, " ");
            print_ast(output, node->els);
        }
        utstring_printf(output, ")");
        break;
    case AST_TERNARY:
        utstring_printf(output,"(? ");
        print_ast(output, node->cond);
        utstring_printf(output, " ");
        print_ast(output, node->then);
        utstring_printf(output, " ");
        print_ast(output, node->els);
        utstring_printf(output,")");
        break;
    case AST_LABEL:
        utstring_printf(output,"i_%d:",node->label);
        break;
    case AST_JUMP:
        utstring_printf(output,"(goto i_%d)",node->label);
        break;
    case AST_RETURN:
        utstring_printf(output, "(return ");
        print_ast(output, node->retval);
        utstring_printf(output, ")");
        break;
    case AST_COMPOUND_STMT:
        for ( int i = 0; i < array_len(node->stmts); i++ ) {
            Node *s = array_get_byindex(node->stmts, i);
            if (s == NULL) continue;   /* dead-code-elimination may NULL out slots */
            print_ast(output, s);
            utstring_printf(output,"\n");
        }
        break;
    case AST_DEREF:
    case OP_DEREF: print_uop(output, "deref", node); break;
    case AST_ADDR:
    case OP_ADDR:  print_uop(output, "addr", node); break;
    case AST_CRITICAL:
        utstring_printf(output, "(critical ");
        print_ast(output, node->operand);
        utstring_printf(output, ")");
        break;
    case AST_LOOP_COUNTDOWN:
        utstring_printf(output, "(loop-%s init=",
                        node->loop_width8 ? "djnz" : "decbc");
        print_ast(output, node->loop_init);
        if (node->loop_step_label)
            utstring_printf(output, " step->i_%d", node->loop_step_label);
        utstring_printf(output, " exit->i_%d ", node->loop_exit_label);
        print_ast(output, node->loop_body);
        utstring_printf(output, ")");
        break;
    case AST_PRESERVE_BC:
        utstring_printf(output, "(preserve-bc ");
        print_ast(output, node->operand);
        utstring_printf(output, ")");
        break;
    case AST_ASM: {
        const char *p = node->labelname ? node->labelname : "";
        utstring_printf(output, "(asm \"");
        for (; *p; p++) {
            if (*p == '\n')      utstring_printf(output, "\\n");
            else if (*p == '\t') utstring_printf(output, "\\t");
            else if (*p == '"')  utstring_printf(output, "\\\"");
            else if (*p == '\\') utstring_printf(output, "\\\\");
            else                 utstring_printf(output, "%c", *p);
        }
        utstring_printf(output, "\")");
        break;
    }
    case AST_INIT_STATIC:
        utstring_printf(output, "(init-from-static %s %d bytes)",
                        node->labelname ? node->labelname : "?",
                        node->label);
        break;
    case AST_INIT_LIST:
        utstring_printf(output, "(init-list");
        for ( int i = 0; i < array_len(node->stmts); i++ ) {
            utstring_printf(output, " ");
            print_ast(output, array_get_byindex(node->stmts, i));
        }
        utstring_printf(output, ")");
        break;
    case AST_SWITCH:
        utstring_printf(output,"(switch ");
        print_ast(output, node->sw_expr);
        utstring_printf(output," (dispatch");
        for (int i = 0; i < array_len(node->sw_cases); i++) {
            utstring_printf(output, " ");
            print_ast(output, array_get_byindex(node->sw_cases, i));
        }
        if (node->sw_default_label) {
            utstring_printf(output, " default->i_%d", node->sw_default_label);
        }
        utstring_printf(output, " exit->i_%d)", node->sw_exit_label);
        print_ast(output, node->sw_body);
        utstring_printf(output,")");
        break;
    case AST_SWITCH_CASE:
        utstring_printf(output,"(case ");
        print_ast(output, node->sw_value);
        utstring_printf(output," goto i_%d)",node->sw_label);
        break;
    case OP_SIZEOF:
        utstring_printf(output, "(sizeof %ld)", (long)(int64_t)node->zval);
        break;
    case OP_CAST:
        utstring_printf(output,"(cast ");
        if (node->type) type_describe(node->type,output);
        utstring_printf(output," ");
        print_ast(output, node->operand);
        utstring_printf(output,")");
        break;
    case OP_USHR: print_binop(output,">>U", node); break;
    case OP_USHL: print_binop(output,"<<U", node); break;
    case OP_SSHR: print_binop(output,">>S", node); break;
    case OP_SSHL: print_binop(output,"<<S", node); break;
    case OP_PRE_INC:  print_uop(output, "pre++", node); break;
    case OP_POST_INC: print_uop(output, "post++", node); break;
    case OP_PRE_DEC:  print_uop(output, "pre--", node); break;
    case OP_POST_DEC: print_uop(output, "post--", node); break;
    case OP_MULT: print_binop(output,"*", node); break;
    case OP_DIV:  print_binop(output,"/", node); break;
    case OP_MOD:  print_binop(output,"%", node); break;
    case OP_ADD:  print_binop(output,"+", node); break;
    case OP_SUB:  print_binop(output,"-", node); break;
    case OP_OR:   print_binop(output,"|", node); break;
    case OP_AND:  print_binop(output,"&", node); break;
    case OP_XOR:  print_binop(output,"^", node); break;
    case OP_ASSIGN: print_binop(output,"=", node); break;
    case OP_AMULT:  print_binop(output,"*=", node); break;
    case OP_ADIV:  print_binop(output,"/=", node); break;
    case OP_AMOD:  print_binop(output,"%=", node); break;
    case OP_AADD:  print_binop(output,"+=", node); break;
    case OP_ASUB:  print_binop(output,"-=", node); break;
    case OP_AOR:   print_binop(output,"|=", node); break;
    case OP_AAND:  print_binop(output,"&=", node); break;
    case OP_AXOR:  print_binop(output,"^=", node); break;
    case OP_ASSHR: print_binop(output,">>=", node); break;
    case OP_ASSHL: print_binop(output,"<<=", node); break;
    case OP_EQ:    print_binop(output,"==", node); break;
    case OP_NE:    print_binop(output,"!=", node); break;
    case OP_GT:    print_binop(output,">", node); break;
    case OP_GE:    print_binop(output,">=", node); break;
    case OP_LT:    print_binop(output,"<", node); break;
    case OP_LE:    print_binop(output,"<=", node); break;
    case OP_COMP:  print_uop(output, "~", node); break;
    case OP_LNEG:  print_uop(output, "!", node); break;
    case OP_NEG:   print_uop(output, "-", node); break;
    case OP_OROR:  print_binop(output,"||", node); break;
    case OP_ANDAND: print_binop(output,"&&", node); break;
    default:
        utstring_printf(output, "(?ast_kind=%d)", node->ast_type);
        break;
    }
}
