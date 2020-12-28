
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


Node *ast_function_call(int ast_type, Type *func_type, array *args)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = ast_type;
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
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}


Node *ast_global_var(SYMBOL *sym, const char *name)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_GLOBAL_VAR;
    ret->sym = sym;
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

Node *ast_return(Node *retval) {
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_RETURN;
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


Node *ast_critical(Node *node)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_CRITICAL;
    ret->operand = node;
    ret->filename = Filename;
    ret->line = lineno;
    return ret;
}

Node *ast_switch(Type *sw_type, Node *sw_expr, Node *case_code)
{
    Node *ret = calloc(1,sizeof(*ret));
    ret->ast_type = AST_SWITCH;

    ret->type = sw_type;
    ret->sw_expr = sw_expr;
    ret->sw_body = case_code;
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


static void print_uop(UT_string *output, char *op, Node *node) {
    utstring_printf(output,"(%s ",op);
    print_ast(output, node->operand);
    utstring_printf(output,")");
}


static void print_binop(UT_string *output, char *op, Node *node) {
    utstring_printf(output,"(%s ",op);
    print_ast(output, node->left);
    utstring_printf(output," ");
    print_ast(output,node->right);
    utstring_printf(output,")");
}

void print_ast(UT_string *output, Node *node) {
    if ( node == NULL ) {
        utstring_printf(output, "(noop)");
        return;
    };
   // utstring_printf(output, "Node type: %d",node->ast_type);
    switch ( node->ast_type) {
    case AST_DECL:
        utstring_printf(output,"(decl %s =",node->sym->ctype->name);
        print_ast(output, node->declvar);
        utstring_printf(output,")");
        break;
    case AST_UNDECL:
        utstring_printf(output,"(undecl %s)",node->sym->ctype->name);
        break;
    case AST_LITERAL:
        switch ( node->type->kind ) {
        case KIND_INT:
        case KIND_CHAR:
        case KIND_SHORT:
        case KIND_LONG:
        case KIND_LONGLONG:
            utstring_printf(output, "%.0Lf",node->zval);
            break;
        case KIND_DOUBLE:
            utstring_printf(output, "%Lf",node->zval);
            break;
        default:
            utstring_printf(output, "LIT");
            break;
        }
        break;
    case AST_LOCAL_VAR:
        utstring_printf(output, "(lv=%s)",node->sym->ctype->name);
        break;
    case AST_GLOBAL_VAR:
        utstring_printf(output, "(gv=%s)",node->sym->ctype->name);
        break;
    case AST_FUNC_CALL:
        utstring_printf(output, "(%s",node->type->name);
        for ( int i = 0; i < array_len(node->args); i++ ) {
            utstring_printf(output, " ");
            print_ast(output, array_get_byindex(node->args,i));
        }
        utstring_printf(output, ")");
        break;
    // AST_FUNCPTR_CALL,

    case AST_IF:
        utstring_printf(output, "(if ");
        print_ast(output, node->cond);
        utstring_printf(output," ");
        print_ast(output, node->cond);
        utstring_printf(output," ");
        print_ast(output, node->els);
        utstring_printf(output,")");
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
            print_ast(output, array_get_byindex(node->stmts,i));
            utstring_printf(output,"\n");
        }
        break;
    case AST_DEREF:
    case OP_DEREF: print_uop(output, "deref", node);
    case AST_ADDR:
    case OP_ADDR:  print_uop(output, "addr", node);
    case AST_CRITICAL:
        utstring_printf(output, "(critical ");
        print_ast(output, node->operand);
        utstring_printf(output, ")");
        break;
    case AST_SWITCH:
        utstring_printf(output,"(switch ");
        print_ast(output, node->sw_expr);
        print_ast(output, node->sw_body);
        utstring_printf(output,")");
        break;
    case AST_SWITCH_CASE:
        utstring_printf(output,"(case ");
        print_ast(output, node->sw_value);
        utstring_printf(output," goto i_%d)",node->sw_label);
        break;
    // OP_SIZEOF,
    // OP_CAST,
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
        break;
    // OP_DEREF,
    // OP_ADDR
    }
}