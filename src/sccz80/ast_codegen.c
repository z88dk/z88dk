#include "ccdefs.h"
#include "define.h"


// Forward declarations
static void generate_code(Node *node);
static void generate_binop(Node *node);
static void generate_uop(Node *node);
static void generate_conditional(Node *node);
static void generate_compound(Node *node);
static void generate_return(Node *node);
static void generate_jump(Node *node);
static void generate_label(Node *node);
static void generate_func_call(Node *node);
static void generate_literal(Node *node);
static void generate_var(Node *node);
static void generate_decl(Node *node);

// Type promotion for binary operations
static Type *promote_types(Type *t1, Type *t2) {
    if (!t1) return t2;
    if (!t2) return t1;
    
    // If either is double, result is double
    if (t1->kind == KIND_DOUBLE || t2->kind == KIND_DOUBLE) return type_double;
    
    // If either is float, result is float
    if (t1->kind == KIND_FLOAT16 || t2->kind == KIND_FLOAT16) return type_float16;
    
    // If either is long long, result is long long
    if (t1->kind == KIND_LONGLONG || t2->kind == KIND_LONGLONG) return type_longlong;
    
    // If either is long, result is long
    if (t1->kind == KIND_LONG || t2->kind == KIND_LONG) return type_long;
    
    // If either is int, result is int
    if (t1->kind == KIND_INT || t2->kind == KIND_INT) return type_int;
    
    // Otherwise, assume int
    return type_int;
}

// Normalize types in the AST tree
static void normalize_types(Node *node) {
    if (!node) return;
    
    switch (node->ast_type) {
    case AST_LITERAL:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
        // Types already set
        break;
    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
        // Type is function return type, already set
        for (int i = 0; i < array_len(node->args); i++) {
            normalize_types(array_get_byindex(node->args, i));
        }
        break;
    case OP_MULT: case OP_DIV: case OP_MOD: case OP_ADD: case OP_SUB:
    case OP_OR: case OP_AND: case OP_XOR:
    case OP_EQ: case OP_NE: case OP_GT: case OP_GE: case OP_LT: case OP_LE:
    case OP_OROR: case OP_ANDAND:
    case OP_USHR: case OP_USHL: case OP_SSHR: case OP_SSHL:
        normalize_types(node->left);
        normalize_types(node->right);
        node->type = promote_types(node->left->type, node->right->type);
        break;
    case OP_PRE_INC: case OP_POST_INC: case OP_PRE_DEC: case OP_POST_DEC:
    case OP_COMP: case OP_LNEG: case OP_NEG: case OP_DEREF: case OP_ADDR:
        normalize_types(node->operand);
        node->type = node->operand->type;  // Most uops preserve type
        break;
    case AST_TERNARY:
        normalize_types(node->cond);
        normalize_types(node->then);
        normalize_types(node->els);
        node->type = promote_types(node->then->type, node->els->type);
        break;
    case AST_RETURN:
        normalize_types(node->retval);
        node->type = node->retval ? node->retval->type : type_void;
        break;
    case AST_COMPOUND_STMT:
        for (int i = 0; i < array_len(node->stmts); i++) {
            normalize_types(array_get_byindex(node->stmts, i));
        }
        break;
    case AST_IF:
        normalize_types(node->cond);
        normalize_types(node->then);
        if (node->els) normalize_types(node->els);
        break;
    case AST_SWITCH:
        normalize_types(node->sw_expr);
        normalize_types(node->sw_body);
        break;
    case AST_SWITCH_CASE:
        normalize_types(node->sw_value);
        break;
    case AST_LABEL:
    case AST_JUMP:
        // No types
        break;
    case AST_DECL:
        if (node->declvar) normalize_types(node->declvar);
        break;
    case AST_UNDECL:
        break;
    default:
        // Handle other cases if needed
        break;
    }
}


/*
 * Main entry point: Generate code for the AST
 */
void ast_generate_code(Node *root)
{
    if (root == NULL) return;
    normalize_types(root);
    generate_code(root);
}

/*
 * Recursive AST walker
 */
static void generate_code(Node *node)
{
    if (node == NULL) return;

    switch (node->ast_type) {
    case AST_LITERAL:
        generate_literal(node);
        break;
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
        generate_var(node);
        break;
    case AST_FUNC_CALL:
        generate_func_call(node);
        break;
    case AST_RETURN:
        generate_return(node);
        break;
    case AST_COMPOUND_STMT:
        generate_compound(node);
        break;
    case AST_IF:
        generate_conditional(node);
        break;
    case AST_LABEL:
        generate_label(node);
        break;
    case AST_JUMP:
        generate_jump(node);
        break;
    case AST_DECL:
        generate_decl(node);
        break;
    // Binary ops
    case OP_ADD:
    case OP_SUB:
    case OP_MULT:
    case OP_DIV:
    case OP_MOD:
    case OP_AND:
    case OP_OR:
    case OP_XOR:
    case OP_EQ:
    case OP_NE:
    case OP_LT:
    case OP_LE:
    case OP_GT:
    case OP_GE:
    case OP_ASSIGN:
    case OP_AADD:
    case OP_ASUB:
    case OP_AMULT:
    case OP_ADIV:
    case OP_AMOD:
    case OP_AAND:
    case OP_AOR:
    case OP_AXOR:
    case OP_ASSHR:
    case OP_ASSHL:
    case OP_OROR:
    case OP_ANDAND:
        generate_binop(node);
        break;
    // Unary ops
    case OP_NEG:
    case OP_COMP:
    case OP_LNEG:
    case OP_DEREF:
    case OP_ADDR:
    case OP_PRE_INC:
    case OP_POST_INC:
    case OP_PRE_DEC:
    case OP_POST_DEC:
        generate_uop(node);
        break;
    // Add more cases as needed
    default:
        // Unknown or unhandled node
        break;
    }
}

/*
 * Generate code for literals
 */
static void generate_literal(Node *node)
{
    // Load the literal value based on type
    switch (node->type->kind) {
    case KIND_INT:
    case KIND_SHORT:
    case KIND_CHAR:
        vconst(node->zval);
        break;
    case KIND_LONG:
        vlongconst(node->zval);
        break;
    case KIND_DOUBLE:
    case KIND_FLOAT16:
        gen_load_constant_as_float(node->zval, node->type->kind, 0);
        break;
    default:
        // Default to int
        vconst(node->zval);
        break;
    }
}

/*
 * Generate code for variables
 */
static void generate_var(Node *node)
{
    LVALUE lval = {0};
    lval.symbol = node->sym;
    lval.ltype = node->sym->ctype;
    lval.val_type = node->sym->type;
    lval.indirect_kind = node->sym->type;
    // Load the variable
    if ( node->sym && (node->sym->type == KIND_PORT8  || node->sym->type == KIND_PORT16) ) {
        gen_intrinsic_in(node->sym);
    } else if (node->sym && node->ast_type == AST_GLOBAL_VAR) {
        gen_load_static(node->sym);
    } else {     
        // TODO: Missing something      
        gen_load_indirect(&lval);
    }
}

/*
 * Generate code for function calls
 */
static void generate_func_call(Node *node)
{
    // Assume node->args is array of arguments
    for (int i = array_len(node->args) - 1; i >= 0; i--) {
        Node *arg = array_get_byindex(node->args, i);
        generate_code(arg);
        gen_push_function_argument(arg->type->kind, arg->type, 0);  // Push arguments
    }
    // Call the function
    callfunction(node->sym, NULL);
}

/*
 * Generate code for binary operations
 */
static void generate_binop(Node *node)
{
    LVALUE lval = {0};
    lval.val_type = node->type ? node->type->kind : KIND_INT;  // Default to int
    lval.ltype = node->type;

    // TODO: We need to save LHS/RHS value whilst we load the other one
    // Generate left operand
    generate_code(node->left);
    // Generate right operand
    generate_code(node->right);

    // Perform the operation
    switch (node->ast_type) {
    case OP_ADD:
        zadd(&lval);
        break;
    case OP_SUB:
        zsub(&lval);
        break;
    case OP_MULT:
        mult(&lval);
        break;
    case OP_DIV:
        zdiv(&lval);
        break;
    case OP_MOD:
        zmod(&lval);
        break;
    case OP_AND:
        zand(&lval);
        break;
    case OP_OR:
        zor(&lval);
        break;
    case OP_XOR:
        zxor(&lval);
        break;
    case OP_EQ:
        zeq(&lval);
        break;
    case OP_NE:
        zne(&lval);
        break;
    case OP_LT:
        zlt(&lval);
        break;
    case OP_LE:
        zle(&lval);
        break;
    case OP_GT:
        zgt(&lval);
        break;
    case OP_GE:
        zge(&lval);
        break;
    case OP_ASSIGN:
        // For assignment, left should be lvalue, right rvalue
        // Assume left is variable, generate right, then store
        generate_code(node->right);
        // Store to left
        if (node->left->ast_type == AST_LOCAL_VAR || node->left->ast_type == AST_GLOBAL_VAR) {
            LVALUE left_lval = {0};
            left_lval.symbol = node->left->sym;
            left_lval.ltype = node->left->sym->ctype;
            left_lval.val_type = node->left->sym->type;
            smartstore(&left_lval);
        }
        break;
    // Add more assignment ops as needed
    default:
        break;
    }
}

/*
 * Generate code for unary operations
 */
static void generate_uop(Node *node)
{
    LVALUE lval = {0};
    lval.val_type = node->type ? node->type->kind : KIND_INT;
    lval.ltype = node->type;

    generate_code(node->operand);
    switch (node->ast_type) {
    case OP_NEG:
        neg(&lval);
        break;
    case OP_COMP:
        com(&lval);
        break;
    case OP_LNEG:
        lneg(&lval);
        break;
    case OP_DEREF:
        // Dereference is handled in rvalue, but for AST, assume operand is address
        // May need special handling
        break;
    case OP_ADDR:
        // Address of, generate address
        if (node->operand->ast_type == AST_LOCAL_VAR || node->operand->ast_type == AST_GLOBAL_VAR) {
            gen_address(node->operand->sym);
        }
        break;
    case OP_PRE_INC:
        // Pre-increment: load, inc, store
        if (node->operand->ast_type == AST_LOCAL_VAR || node->operand->ast_type == AST_GLOBAL_VAR) {
            LVALUE op_lval = {0};
            op_lval.symbol = node->operand->sym;
            op_lval.ltype = node->operand->sym->ctype;
            op_lval.val_type = node->operand->sym->type;
            prestep(&op_lval, 1, inc, OP_PRE_INC);
        }
        break;
    case OP_POST_INC:
        if (node->operand->ast_type == AST_LOCAL_VAR || node->operand->ast_type == AST_GLOBAL_VAR) {
            LVALUE op_lval = {0};
            op_lval.symbol = node->operand->sym;
            op_lval.ltype = node->operand->sym->ctype;
            op_lval.val_type = node->operand->sym->type;
            poststep(1, &op_lval, 1, inc, dec, OP_POST_INC);
        }
        break;
    case OP_PRE_DEC:
        if (node->operand->ast_type == AST_LOCAL_VAR || node->operand->ast_type == AST_GLOBAL_VAR) {
            LVALUE op_lval = {0};
            op_lval.symbol = node->operand->sym;
            op_lval.ltype = node->operand->sym->ctype;
            op_lval.val_type = node->operand->sym->type;
            prestep(&op_lval, -1, dec, OP_PRE_DEC);
        }
        break;
    case OP_POST_DEC:
        if (node->operand->ast_type == AST_LOCAL_VAR || node->operand->ast_type == AST_GLOBAL_VAR) {
            LVALUE op_lval = {0};
            op_lval.symbol = node->operand->sym;
            op_lval.ltype = node->operand->sym->ctype;
            op_lval.val_type = node->operand->sym->type;
            poststep(1, &op_lval, -1, dec, inc, OP_POST_DEC);
        }
        break;
    default:
        break;
    }
}

/*
 * Generate code for conditionals (if/ternary)
 */
static void generate_conditional(Node *node)
{
    int lab1 = getlabel();
    int lab2 = getlabel();

    // Condition
    generate_code(node->cond);
    testjump(NULL, lab1);

    // Then branch
    generate_code(node->then);
    if (node->els) {
        gen_jp_label(lab2, 1);
    }
    postlabel(lab1);

    // Else branch
    if (node->els) {
        generate_code(node->els);
        postlabel(lab2);
    }
}

/*
 * Generate code for compound statements
 */
static void generate_compound(Node *node)
{
    for (int i = 0; i < array_len(node->stmts); i++) {
        generate_code(array_get_byindex(node->stmts, i));
    }
}

/*
 * Generate code for return
 */
static void generate_return(Node *node)
{
    if (node->retval) {
        generate_code(node->retval);
        // Convert to return type if necessary
        if (node->retval->type->kind != currfn->ctype->return_type->kind) {
            LVALUE lval = {0};
            lval.val_type = node->retval->type->kind;
            lval.ltype = node->retval->type;
            lval.is_const = 0; // Assume not constant
            force(currfn->ctype->return_type->kind, lval.val_type, 
                  node->retval->type->isunsigned, currfn->ctype->return_type->isunsigned, lval.is_const);
        }
    }
    gen_leave_function(currfn->ctype->return_type->kind, 0, 0);
}

/*
 * Generate code for jumps (goto/break/continue)
 */
static void generate_jump(Node *node)
{
    gen_jp_label(node->label, 1);
}

/*
 * Generate code for labels
 */
static void generate_label(Node *node)
{
    postlabel(node->label);
}

/*
 * Generate code for declarations
 */
static void generate_decl(Node *node)
{
    // For local declarations, may need to allocate space
    // For now, assume globals are handled elsewhere
    if (node->declvar) {
        generate_code(node->declvar);
        // Assign to variable
        LVALUE lval = {0};
        lval.symbol = node->sym;
        smartstore(&lval);
    }
}
