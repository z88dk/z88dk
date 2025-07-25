/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2025
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Expression parser based on the shunting-yard algoritm,
see http://www.engr.mun.ca/~theo/Misc/exp_parsing.htm
*/

#include "array.h"
#include "codearea.h"
#include "die.h"
#include "errors.h"
#include "expr1.h"
#include "if.h"
#include "init.h"
#include "module1.h"
#include "strhash.h"
#include "strpool.h"
#include "strutil.h"
#include "sym.h"
#include "symtab1.h"
#include "utlist.h"
#include "utstring.h"
#include "xassert.h"
#include "xmalloc.h"

/*-----------------------------------------------------------------------------
*	UT_array of Expr1*
*----------------------------------------------------------------------------*/
void ut_exprs_init(void* elt)
{
	Expr1* expr = OBJ_NEW(Expr1);
	*((Expr1**)elt) = expr;
}

void ut_exprs_dtor(void* elt)
{
	Expr1* expr = *((Expr1**)elt);
	OBJ_DELETE(expr);
}

UT_icd ut_exprs_icd = { sizeof(Expr1*), ut_exprs_init, NULL, ut_exprs_dtor };


/*-----------------------------------------------------------------------------
*	Expression operations
*----------------------------------------------------------------------------*/

/* init each type of ExprOp */
static void ExprOp_init_asmpc(ExprOp* self);
static void ExprOp_init_number(ExprOp* self, long value);
static void ExprOp_init_symbol(ExprOp* self, Symbol1* symbol);
static void ExprOp_init_operator(ExprOp* self, tokid_t tok, op_type_t op_type);

/*-----------------------------------------------------------------------------
*	Initialization
*----------------------------------------------------------------------------*/
static void init_operator_hash(void);
static void fini_operator_hash(void);

DEFINE_init_module()
{
	init_operator_hash();
}

DEFINE_dtor_module()
{
	fini_operator_hash();
}

/*-----------------------------------------------------------------------------
*	Calculation functions that need to check arguments
*----------------------------------------------------------------------------*/
static long _calc_divide(long a, long b)
{
	if (b == 0)
	{
        error(ErrDivisionByZero, NULL);	/* BUG_0040 */
		return 0;
	}

	return a / b;
}

static long _calc_mod(long a, long b)
{
	if (b == 0)
	{
        error(ErrDivisionByZero, NULL);	/* BUG_0040 */
		return 0;
	}

	return a % b;
}

/* exponentiation by squaring */
static long _calc_power(long base, long exp)
{
	long result = 1;

	if (exp < 0)
		return 0;	/* BUG_0041 */

	while (exp)
	{
		if (exp & 1)
			result *= base;
		exp >>= 1;
		base *= base;
	}

	return result;
}

/*-----------------------------------------------------------------------------
*	Calculation functions for all operators, template:
*	long calc_<symbol> (long a [, long b [, long c ] ] );
*----------------------------------------------------------------------------*/
#define OPERATOR(_operation, _tok, _type, _prec, _assoc, _args, _calc)	\
	static long calc_##_operation _args { return _calc; }
#include "expr_def.h"

/*-----------------------------------------------------------------------------
*	Operator descriptors
*----------------------------------------------------------------------------*/

/* hash of (tok,op_type) to Operator* */
static StrHash* operator_hash;

/* compute hash key */
static const char* operator_hash_key(tokid_t tok, op_type_t op_type)
{
	char key[3];		/* byte 1 = tok; byte 2 = op_type; byte 3 = '\0' */

	/* assert we can map symbol and type in a string */
	xassert(tok > 0 && tok < 256);
	xassert(op_type > 0 && op_type < 256);
	key[0] = (char)tok; key[1] = (char)op_type; key[2] = '\0';

	return spool_add(key);
}

/* init operator_hash - create one Operator for each, add to hash table */
static void init_operator_hash(void)
{
	const char* key;

#define OPERATOR(_operation, _tok, _type, _prec, _assoc, _args, _calc)		\
	{																		\
		static Operator op_##_operation;									\
																			\
		/* init static operator structure */								\
		op_##_operation.tok			= _tok;									\
		op_##_operation.op_type		= _type;								\
		op_##_operation.prec		= _prec;								\
		op_##_operation.assoc		= _assoc;								\
		/* cast into unary type, cannot decide union path at compile time */ \
		op_##_operation.calc.unary	= (long(*)(long))calc_##_operation;		\
																			\
		key = operator_hash_key( _tok, _type );								\
		StrHash_set( &operator_hash, key, & op_##_operation );				\
	}
#include "expr_def.h"
}

/* fini operator_hash */
static void fini_operator_hash(void)
{
	StrHash_remove_all(operator_hash);
}


/* get the operator descriptor for the given (tok, op_type) */
Operator* Operator_get(tokid_t tok, op_type_t op_type)
{
	const char* key;

	init_module();
	key = operator_hash_key(tok, op_type);
	return (Operator*)StrHash_get(operator_hash, key);
}

/*-----------------------------------------------------------------------------
*	Stack for calculator
*----------------------------------------------------------------------------*/
static longArray* calc_stack;

void Calc_push(long value)
{
	long* top;

	INIT_OBJ(longArray, &calc_stack);		/* freed by class */

	top = longArray_push(calc_stack);
	*top = value;
}

long Calc_pop(void)
{
	long* top, value;

	INIT_OBJ(longArray, &calc_stack);		/* freed by class */

	top = longArray_top(calc_stack);
	xassert(top != NULL);
	value = *top;

	longArray_pop(calc_stack);
	return value;
}

void Calc_compute_unary(long (*calc)(long a))
{
	long a = Calc_pop();
	long x = calc(a);
	Calc_push(x);
}

void Calc_compute_binary(long (*calc)(long a, long b))
{
	long b = Calc_pop();
	long a = Calc_pop();
	long x = calc(a, b);
	Calc_push(x);
}

void Calc_compute_ternary(long (*calc)(long a, long b, long c))
{
	long c = Calc_pop();
	long b = Calc_pop();
	long a = Calc_pop();
	long x = calc(a, b, c);
	Calc_push(x);
}

/*-----------------------------------------------------------------------------
*	Expression operations
*----------------------------------------------------------------------------*/
DEF_ARRAY(ExprOp);

/* init each type of ExprOp */
void ExprOp_init_asmpc(ExprOp* self)
{
	self->op_type = ASMPC_OP;
}

void ExprOp_init_number(ExprOp* self, long value)
{
	self->op_type = NUMBER_OP;
	self->d.value = value;
}

void ExprOp_init_symbol(ExprOp* self, Symbol1* symbol)
{
	self->op_type = SYMBOL_OP;
	self->d.symbol = symbol;
}

void ExprOp_init_operator(ExprOp* self, tokid_t tok, op_type_t op_type)
{
	Operator* op;

	op = Operator_get(tok, op_type); xassert(op != NULL);

	self->op_type = op_type;
	self->d.op = op;
}

/* compute ExprOp using Calc_xxx functions */
void ExprOp_compute(ExprOp* self, Expr1* expr, bool not_defined_error)
{
	switch (self->op_type)
	{
	case SYMBOL_OP:
		/* symbol was not defined */
		if (!self->d.symbol->is_defined || self->d.symbol->type == TYPE_COMPUTED)
		{
			expr->result.not_evaluable = true;

			/* copy scope */
			if (self->d.symbol->scope == SCOPE_EXTERN ||
				(self->d.symbol->scope == SCOPE_GLOBAL && !self->d.symbol->is_defined))
			{
				expr->result.extern_symbol = true;
			}
			else if (self->d.symbol->type == TYPE_UNDEFINED)
			{
				expr->result.undefined_symbol = true;
				if (not_defined_error)
                    error(ErrUndefinedSymbol, self->d.symbol->name);
			}

			Calc_push(0);
		}
		else
		{
			Calc_push(self->d.symbol->value);

			/* check cross-section addresses to invalidade relative jumps */
			if (self->d.symbol->section != CURRENTSECTION)
				expr->result.cross_section_addr = true;
		}

		expr->type = MAX(expr->type, self->d.symbol->type);

		/* check if symbol is computable and was computed */
		if (self->d.symbol->type == TYPE_COMPUTED && !self->d.symbol->is_computed)
			expr->is_computed = false;

		break;

	case ASMPC_OP:
		if (get_phased_PC() >= 0) {
			expr->type = MAX(expr->type, TYPE_CONSTANT);
			Calc_push(get_phased_PC());
		}
		else {
			expr->type = MAX(expr->type, TYPE_ADDRESS);
			Calc_push(get_PC());
		}
		break;

	case NUMBER_OP:	Calc_push(self->d.value); break;
	case UNARY_OP:	Calc_compute_unary(self->d.op->calc.unary); break;
	case BINARY_OP:	Calc_compute_binary(self->d.op->calc.binary); break;
	case TERNARY_OP:Calc_compute_ternary(self->d.op->calc.ternary); break;

	default:
		xassert(0);
	}
}

/*-----------------------------------------------------------------------------
*	Class to hold one parsed expression
*----------------------------------------------------------------------------*/
DEF_CLASS(Expr1);
DEF_CLASS_LIST(Expr1);

void Expr1_init(Expr1* self)
{
	self->rpn_ops = OBJ_NEW(ExprOpArray);
	OBJ_AUTODELETE(self->rpn_ops) = false;

	self->text = Str_new(STR_SIZE);

	self->type = TYPE_UNDEFINED;

	self->target_name = NULL;

	self->module = CURRENTMODULE;
	self->section = CURRENTSECTION;
	self->asmpc = get_phased_PC() >= 0 ? get_phased_PC() : get_PC();	/* BUG_0048 */
	self->code_pos = get_cur_module_size();	/* BUG_0015 */
	self->opcode_size = 0;

	self->filename = spool_add(sfile_filename());
	self->line_num = sfile_line_num();
	self->listpos = -1;
}

void Expr1_copy(Expr1* self, Expr1* other)
{
	self->rpn_ops = ExprOpArray_clone(other->rpn_ops);
	self->text = Str_new(STR_SIZE);
	Str_set(self->text, Str_data(other->text));
}

void Expr1_fini(Expr1* self)
{
	OBJ_DELETE(self->rpn_ops);
	Str_delete(self->text);
}

/*-----------------------------------------------------------------------------
*	Expression parser
*----------------------------------------------------------------------------*/
static bool Expr_parse_ternary_cond(Expr1* expr);

#define DEFINE_PARSER( name, prev_name, condition )			\
	static bool name( Expr1 *self )							\
	{														\
		tokid_t op = TK_NIL;								\
															\
		if ( ! prev_name(self) )							\
			return false;									\
															\
		while ( condition )									\
		{													\
			op = sym.tok;									\
			Str_append_n(self->text, sym.tstart, sym.tlen);	\
			/* '%10' is binary constant 2, '% 10' is modulo 10 */	\
			if (*sym.tstart == '%')							\
				Str_append(self->text, " ");				\
			GetSym();										\
			if ( ! prev_name(self) )						\
				return false;								\
															\
			ExprOp_init_operator(							\
				ExprOpArray_push( self->rpn_ops ),			\
				op, BINARY_OP );							\
		}													\
															\
		return true;										\
	}

/* parse value */
static bool Expr_parse_factor(Expr1* self)
{
	Symbol1* symptr;
    const char* short_name, * long_name;

	switch (sym.tok)
	{
	case TK_ASMPC:				/* BUG_0047 */
		ExprOp_init_asmpc(ExprOpArray_push(self->rpn_ops));
		self->type = MAX(self->type, TYPE_ADDRESS);

		Str_append_n(self->text, sym.tstart, sym.tlen);

		GetSym();
		break;

	case TK_NAME:
        short_name = spool_add(sym_text(&sym));
        long_name = local_labels_use_label(short_name);
        symptr = get_used_symbol(long_name);
        ExprOp_init_symbol(ExprOpArray_push(self->rpn_ops), symptr);

        /* copy type */
        self->type = MAX(self->type, symptr->type);

		Str_append(self->text, long_name);      /* add identifier to infix expr */

		GetSym();
		break;

	case TK_NUMBER:
		Str_append_sprintf(self->text, "%ld", sym.number);
		ExprOp_init_number(ExprOpArray_push(self->rpn_ops),
			sym.number);
		self->type = MAX(self->type, TYPE_CONSTANT);
		GetSym();
		break;

	default:
		return 0;
}

	return 1;                   /* syntax OK */
}

/* parse unary operators */
static bool Expr_parse_unary(Expr1* self)
{
	tokid_t open_paren;

	switch (sym.tok)
	{
	case TK_MINUS:
		Str_append_n(self->text, sym.tstart, sym.tlen);
		GetSym();
		if (!Expr_parse_unary(self))		/* right-associative, recurse */
			return false;

		ExprOp_init_operator(ExprOpArray_push(self->rpn_ops),
			TK_MINUS, UNARY_OP);
		return true;

	case TK_PLUS:
		GetSym();
		return Expr_parse_unary(self);

	case TK_BIN_NOT:
		Str_append_n(self->text, sym.tstart, sym.tlen);
		GetSym();
		if (!Expr_parse_unary(self))		/* right-associative, recurse */
			return false;

		ExprOp_init_operator(ExprOpArray_push(self->rpn_ops),
			TK_BIN_NOT, UNARY_OP);
		return true;

	case TK_LOG_NOT:
		Str_append_n(self->text, sym.tstart, sym.tlen);
		GetSym();

		if (!Expr_parse_unary(self))		/* right-associative, recurse */
			return false;

		ExprOp_init_operator(ExprOpArray_push(self->rpn_ops),
			TK_LOG_NOT, UNARY_OP);
		return true;

	case TK_LPAREN:
	case TK_LSQUARE:
		Str_append_n(self->text, sym.tstart, sym.tlen);
		open_paren = sym.tok;
		GetSym();

		if (!Expr_parse_ternary_cond(self))
			return false;

		/* chack parentheses balance */
		if ((open_paren == TK_LPAREN && sym.tok != TK_RPAREN) ||
			(open_paren == TK_LSQUARE && sym.tok != TK_RSQUARE))
			return false;

		Str_append_n(self->text, sym.tstart, sym.tlen);
		GetSym();
		return true;

	default:
		return Expr_parse_factor(self);
	}
}

/* parse A ** B */
static bool Expr_parse_power(Expr1* self)
{
	if (!Expr_parse_unary(self))
		return false;

	while (sym.tok == TK_POWER)
	{
		Str_append_n(self->text, sym.tstart, sym.tlen);
		GetSym();
		if (!Expr_parse_power(self))		/* right-associative, recurse */
			return false;

		ExprOp_init_operator(ExprOpArray_push(self->rpn_ops),
			TK_POWER, BINARY_OP);
	}

	return true;
}

/* parse A * B, A / B, A % B */
DEFINE_PARSER(Expr_parse_multiplication, Expr_parse_power,
	sym.tok == TK_MULTIPLY || sym.tok == TK_DIVIDE || sym.tok == TK_MOD)

	/* parse A + B, A - B */
	DEFINE_PARSER(Expr_parse_addition, Expr_parse_multiplication,
		sym.tok == TK_PLUS || sym.tok == TK_MINUS)

	/* parse A << B, A >> B */
	DEFINE_PARSER(Expr_parse_binary_shift, Expr_parse_addition,
		sym.tok == TK_LEFT_SHIFT || sym.tok == TK_RIGHT_SHIFT)

	/* parse A == B, A < B, A <= B, A > B, A >= B, A != B */
	DEFINE_PARSER(Expr_parse_condition, Expr_parse_binary_shift,
		sym.tok == TK_LESS || sym.tok == TK_LESS_EQ ||
		sym.tok == TK_EQUAL || sym.tok == TK_NOT_EQ ||
		sym.tok == TK_GREATER || sym.tok == TK_GREATER_EQ)

	/* parse A & B */
	DEFINE_PARSER(Expr_parse_binary_and, Expr_parse_condition,
		sym.tok == TK_BIN_AND)

	/* parse A | B, A ^ B */
	DEFINE_PARSER(Expr_parse_binary_or, Expr_parse_binary_and,
		sym.tok == TK_BIN_OR || sym.tok == TK_BIN_XOR)

	/* parse A && B */
	DEFINE_PARSER(Expr_parse_logical_and, Expr_parse_binary_or,
		sym.tok == TK_LOG_AND)

	/* parse A || B */
	DEFINE_PARSER(Expr_parse_logical_or, Expr_parse_logical_and,
		sym.tok == TK_LOG_OR)

	/* parse cond ? true : false */
	static bool Expr_parse_ternary_cond(Expr1* self)
{
	if (!Expr_parse_logical_or(self))		/* get cond or expression */
		return false;

	if (sym.tok != TK_QUESTION)
		return true;

	/* ternary construct found */
	Str_append_char(self->text, '?');
	GetSym();						/* consume '?' */

	if (!Expr_parse_ternary_cond(self))	/* get true */
		return false;

	if (sym.tok != TK_COLON)
		return false;
	Str_append_char(self->text, ':');
	GetSym();						/* consume ':' */

	if (!Expr_parse_ternary_cond(self))	/* get false */
		return false;

	ExprOp_init_operator(ExprOpArray_push(self->rpn_ops),
		TK_TERN_COND, TERNARY_OP);
	return true;
}

/* parse expression at current input, return new Expr1 object;
   return NULL and issue syntax error on error */
Expr1* expr_parse(void) {
	Expr1* self = OBJ_NEW(Expr1);
	if (!Expr_parse_ternary_cond(self))
	{
		/* syntax error in expression */
        error(ErrSyntaxExpr, NULL);

		OBJ_DELETE(self);
		self = NULL;
	}
	return self;
}

/*-----------------------------------------------------------------------------
*	evaluate expression if possible, set result.not_evaluable if failed
*   e.g. symbol not defined
*	NOTE: needs to understand that x + addr1 - addr2, when addr1 and addr2 are
*		in the same module and section, is a constant and not an address
*----------------------------------------------------------------------------*/
long Expr_eval(Expr1* self, bool not_defined_error)
{
	size_t i;

	self->result.not_evaluable = false;
	self->result.undefined_symbol = false;
	self->result.extern_symbol = false;
	self->result.cross_section_addr = false;
    self->result.has_local_symbol = false;

	self->is_computed = true;

	for (i = 0; i < ExprOpArray_size(self->rpn_ops); i++)
	{
		ExprOp* expr_op = ExprOpArray_item(self->rpn_ops, i);

		ExprOp_compute(expr_op, self, not_defined_error);
	}

	/* need to downgrade from COMPUTED if already computed */
	if (self->type == TYPE_COMPUTED && self->is_computed)
	{
		sym_type_t type = TYPE_CONSTANT;

		for (i = 0; i < ExprOpArray_size(self->rpn_ops); i++)
		{
			ExprOp* expr_op = ExprOpArray_item(self->rpn_ops, i);

			switch (expr_op->op_type)
			{
			case SYMBOL_OP:		type = MAX(type, expr_op->d.symbol->type); break;
			case ASMPC_OP:		type = MAX(type, TYPE_ADDRESS); break;
			default:; /* no change */
			}
		}
		xassert(type != TYPE_COMPUTED);
		self->type = type;
	}

	/* need to downgrade to CONSTANT if it is the difference of two addresses */
	if (self->type >= TYPE_ADDRESS && Expr_is_addr_diff(self))
		self->type = TYPE_CONSTANT;

	/* need to upgrade to TYPE_COMPUTED if it contains more than one address */
	if (self->type == TYPE_ADDRESS) {
		int count_addr = 0;

		for (i = 0; i < ExprOpArray_size(self->rpn_ops); i++)
		{
			ExprOp* expr_op = ExprOpArray_item(self->rpn_ops, i);

			switch (expr_op->op_type)
			{
			case SYMBOL_OP:	
				if (expr_op->d.symbol->type == TYPE_ADDRESS)
					count_addr++;
				break;
			case ASMPC_OP:
				count_addr++;
				break;
			default:; /* no change */
			}
		}
		if (count_addr > 1)
			self->type = TYPE_COMPUTED;
	}

	return Calc_pop();
}

/* check if all variables used in an expression are local to the same module
and section; if yes, the expression can be computed in phase 2 of the compile,
if not the expression must be passed to the link phase */
bool Expr_is_local_in_section(Expr1* self, struct Module1* module, struct Section1* section)
{
	size_t i;

	for (i = 0; i < ExprOpArray_size(self->rpn_ops); i++)
	{
		ExprOp* expr_op = ExprOpArray_item(self->rpn_ops, i);

		switch (expr_op->op_type)
		{
		case SYMBOL_OP:
			if (expr_op->d.symbol->module != module || expr_op->d.symbol->section != section)
				return false;
			break;

		case ASMPC_OP:
		case NUMBER_OP:
		case UNARY_OP:
		case BINARY_OP:
		case TERNARY_OP:
			break;

		default:
			xassert(0);
		}
	}
	return true;
}

bool Expr_without_addresses(Expr1* self)
{
	size_t i;
	int num_addresses = 0;

	for (i = 0; i < ExprOpArray_size(self->rpn_ops); i++)
	{
		ExprOp* expr_op = ExprOpArray_item(self->rpn_ops, i);

		switch (expr_op->op_type)
		{
		case SYMBOL_OP:
			if (expr_op->d.symbol->type >= TYPE_ADDRESS)
				num_addresses++;
			break;

		case ASMPC_OP:
			num_addresses++;
			break;

        case NUMBER_OP:
		case UNARY_OP:
		case BINARY_OP:
		case TERNARY_OP:
			break;

		default:
			xassert(0);
		}
	}

	if (num_addresses > 1 ||	// two or more addresses
		(num_addresses == 1 && ExprOpArray_size(self->rpn_ops) > 1))	// or one address with more operands
		return false;
	else
		return true;
}

/* check if expression depends on itself */
bool Expr_is_recusive(Expr1* self, const char* name)
{
	size_t i;

	for (i = 0; i < ExprOpArray_size(self->rpn_ops); i++)
	{
		ExprOp* expr_op = ExprOpArray_item(self->rpn_ops, i);

		switch (expr_op->op_type)
		{
		case SYMBOL_OP:
			if (strcmp(expr_op->d.symbol->name, name) == 0)
				return true;
			break;

        case ASMPC_OP:
		case NUMBER_OP:
		case UNARY_OP:
		case BINARY_OP:
		case TERNARY_OP:
			break;

		default:
			xassert(0);
		}
	}
	return false;
}

/* check if expression is difference of two addresses in the same section */
enum stack_item_type { SI_CONST, SI_ADDR };
struct stack_item {
	enum stack_item_type type;
	bool positive;
	Section1* section;
	struct stack_item* next;
};

static bool Expr_is_addr_diff1(Expr1* self, struct stack_item** phead) {
	for (int i = 0; i < ExprOpArray_size(self->rpn_ops); i++) {
		struct stack_item* elt = NULL;

		ExprOp* op = ExprOpArray_item(self->rpn_ops, i);
		switch (op->op_type) {
		case ASMPC_OP:
			elt = xnew(struct stack_item);
			elt->type = SI_ADDR;
			elt->positive = true;
			elt->section = CURRENTSECTION;
			LL_PREPEND(*phead, elt);
			break;
		case NUMBER_OP:
			elt = xnew(struct stack_item);
			elt->type = SI_CONST;
			elt->positive = true;
			elt->section = NULL;
			LL_PREPEND(*phead, elt);
			break;
		case SYMBOL_OP:
			if (!op->d.symbol->is_defined)
				return false;
			switch (op->d.symbol->type) {
			case TYPE_UNDEFINED:
				return false;
			case TYPE_CONSTANT:
				elt = xnew(struct stack_item);
				elt->type = SI_CONST;
				elt->positive = true;
				elt->section = NULL;
				LL_PREPEND(*phead, elt);
				break;
			case TYPE_ADDRESS:
				elt = xnew(struct stack_item);
				elt->type = SI_ADDR;
				elt->positive = true;
				elt->section = op->d.symbol->section;
				LL_PREPEND(*phead, elt);
				break;
			case TYPE_COMPUTED:
				return false;
			default:
				xassert(0);
			}
			break;
		case UNARY_OP:
			xassert(*phead);
			switch (op->d.op->tok) {
			case TK_MINUS:
				(*phead)->positive = !(*phead)->positive;
				break;
			case TK_BIN_NOT:
			case TK_LOG_NOT:
				if ((*phead)->type == SI_ADDR)
					return false;
				break;
			default:
				xassert(0);
			}
			break;
		case BINARY_OP:
			xassert(*phead);
			xassert((*phead)->next);
			switch (op->d.op->tok) {
			case TK_MULTIPLY:
			case TK_DIVIDE:
			case TK_MOD:
			case TK_LEFT_SHIFT:
			case TK_RIGHT_SHIFT:
			case TK_LESS:
			case TK_LESS_EQ:
			case TK_EQUAL:
			case TK_NOT_EQ:
			case TK_GREATER:
			case TK_GREATER_EQ:
			case TK_BIN_AND:
			case TK_BIN_OR:
			case TK_BIN_XOR:
			case TK_LOG_AND:
			case TK_LOG_OR:
			case TK_POWER:
				if ((*phead)->type == SI_ADDR || (*phead)->next->type == SI_ADDR)
					return false;
				else {
					elt = *phead;
					LL_DELETE(*phead, elt);
					xfree(elt);
					xassert((*phead)->type == SI_CONST);
				}
				break;
			case TK_MINUS:
				(*phead)->positive = !(*phead)->positive;
				/* fall through */
			case TK_PLUS:
				if ((*phead)->type == SI_CONST &&
					(*phead)->next->type == SI_CONST) {
					elt = *phead;
					LL_DELETE(*phead, elt);
					xfree(elt);
					xassert((*phead)->type == SI_CONST);
				}
				else if ((*phead)->type == SI_CONST &&
					(*phead)->next->type == SI_ADDR) {
					elt = *phead;
					LL_DELETE(*phead, elt);
					xfree(elt);
					xassert((*phead)->type == SI_ADDR);
				}
				else if ((*phead)->type == SI_ADDR &&
					(*phead)->next->type == SI_CONST) {
					(*phead)->next->type = (*phead)->type;
					(*phead)->next->positive = (*phead)->positive;
					(*phead)->next->section = (*phead)->section;
					elt = *phead;
					LL_DELETE(*phead, elt);
					xfree(elt);
					xassert((*phead)->type == SI_ADDR);
				}
				else if ((*phead)->type == SI_ADDR &&
					(*phead)->next->type == SI_ADDR) {
					if ((*phead)->section == (*phead)->next->section &&
						(*phead)->positive != (*phead)->next->positive) {
						/* difference of two addresses */
						elt = *phead;
						LL_DELETE(*phead, elt);
						xfree(elt);
						(*phead)->type = SI_CONST;
						(*phead)->positive = true;
						(*phead)->section = NULL;
					}
					else
						return false;
					xassert((*phead)->type == SI_CONST);
				}
				else
					xassert(0);
				break;
			default:
				xassert(0);
			}
			break;
		case TERNARY_OP:
			xassert(*phead);
			xassert((*phead)->next);
			xassert((*phead)->next->next);
			return false;
		default:
			xassert(0);
		}
	}

	xassert((*phead) != NULL);
	xassert((*phead)->next == NULL);
	if ((*phead)->type == SI_CONST)
		return true;
	else
		return false;
}

bool Expr_is_addr_diff(Expr1* self) {
	struct stack_item* head = NULL;
	bool ret = Expr_is_addr_diff1(self, &head);

	// delete stack
	struct stack_item* elt, * tmp;
	LL_FOREACH_SAFE(head, elt, tmp) {
		xfree(elt);
	}

	return ret;
}

bool Expr_depends_on_one_symbol(Expr1* self, Section1** p_used_section) {
    *p_used_section = NULL;
    int count_symbols = 0;
    for (size_t i = 0; i < ExprOpArray_size(self->rpn_ops); i++) {
        ExprOp* expr_op = ExprOpArray_item(self->rpn_ops, i);
        switch (expr_op->op_type) {
        case SYMBOL_OP:
            count_symbols++;
            if (count_symbols == 1)
                *p_used_section = expr_op->d.symbol->section;
            else
                *p_used_section = NULL;
            break;
        case ASMPC_OP:              // #2469
            count_symbols++;
            if (count_symbols != 1)
                *p_used_section = NULL;
            break;
        case NUMBER_OP:
        case UNARY_OP:
        case BINARY_OP:
        case TERNARY_OP:
            break;
        default:
            xassert(0);
        }
    }
    return *p_used_section!=NULL;
}
