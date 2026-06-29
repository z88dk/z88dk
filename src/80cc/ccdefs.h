/*
 *      Small C+ Compiler
 *
 *      The master header file
 *      Includes everything else!!!
 *
 *      $Id: ccdefs.h,v 1.5 2016-08-26 05:44:47 aralbrec Exp $
 */


#ifndef CCDEFS_H
#define CCDEFS_H

#include <sys/types.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <math.h>

typedef long double zdouble;

#include "define.h"
#include "tokeniser.h"


/*
 * 	Now the fix for HP-UX
 *	Darn short filename filesystems!
 */

#ifdef hpux
#define FILENAME_LEN 1024
#else
#define FILENAME_LEN FILENAME_MAX
#endif


/*
 *      Now some system files for good luck
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*
 *      Prototypes
 */

extern Node    *callfunction(SYMBOL *ptr, Type *func_ptr_call_type);


/* cdbfile.c */
extern void     debug_write_module(void);
extern void     debug_write_symbol(SYMBOL *sym);
extern void     debug_write_type(Type *type);

#include "codegen.h"

extern void gen_comment(const char *comment);
extern void gen_file_header(void);
extern void gen_file_footer(void);
extern void gen_switch_section(const char *section_name);


extern void gen_conv_uint2char(void);
extern void gen_conv_sint2char(void);
extern void gen_conv_uint2long(void);
extern void gen_conv_sint2long(void);
extern void gen_conv_carry2int(void);
extern void codegen_call(int nargs_count, const char *name, SYMBOL *sym);

extern void gen_intrinsic_in(SYMBOL *sym);
extern void gen_intrinsic_out(SYMBOL *sym);

extern void gen_swap_float(Kind float_type);
extern void gen_pop_frame(void);
extern void gen_push_frame(void);
extern void gen_push_float(Kind typeToPush);

extern int zinterruptoffset(SYMBOL *sym);
extern void gen_interrupt_enter(SYMBOL *func);
extern void gen_interrupt_leave(SYMBOL *func);

extern void codegen_critical_enter(void);
extern void codegen_critical_leave(void);
extern void gen_shortcall(Type *functype, int rst, int value);
extern void gen_bankedcall(SYMBOL *sym, Type* functype);
extern void gen_hl_call(Type *functype, int module, int address);
extern void gen_emit_line(int);
extern void gen_swap(void);

extern void gen_load_indirect(LVALUE *lval);
extern void gen_load_static(SYMBOL *sym);
extern void gen_store_static(SYMBOL *sym);
extern int  gen_load_static_offset(SYMBOL *sym, int offset, Kind k);
extern int  gen_store_static_offset(SYMBOL *sym, int offset, Kind k);
extern int  gen_address_offset(SYMBOL *ptr, int offset);
extern void gen_local_addr(int frame_offset);
extern void gen_load_local(int frame_offset, Kind k, int is_unsigned);
extern int  gen_load_local_int_to_de(int frame_offset);
extern void gen_store_local(int frame_offset, Kind k);
extern void gen_store_local_keep(int frame_offset, Kind k);
extern void gen_store_literal_at_hl(int64_t value, int width);
extern int  can_access_local_native(int frame_offset, Kind k);
extern void gen_load_byte(SYMBOL *sym);
extern void gen_store_static_byte_in_a(SYMBOL *sym);
extern void gen_store_local_byte_in_a(int frame_offset);
extern void gen_step_local_inplace_16(int frame_offset, int is_inc);
extern void gen_step_static_inplace_16(SYMBOL *sym, int is_inc);
extern void gen_byte_pack_long_finish(void);
extern void gen_load_byte_test(SYMBOL *sym);
extern void gen_load_byte_cmp_const(SYMBOL *sym, int value);
extern void gen_load_byte_signed_cmp_const(SYMBOL *sym, int value);
extern void gen_byte_cmp_byte(SYMBOL *sym_a, SYMBOL *sym_b);
extern void gen_byte_ord_cmp_byte(SYMBOL *lhs, SYMBOL *rhs, int is_unsigned);
extern void gen_store_tos(Kind k);
extern void gen_struct_copy(int size);
extern void gen_push_far_addr(void);
extern void gen_far_store(Kind k);
extern void gen_truthy_test(Kind k);
extern void gen_ptr_diff_scale(int elem);
extern void gen_ret_cc(const char *cc);
extern void gen_bitfield_store(Type *t);
extern void gen_load_constant_as_float(double value, Kind to, unsigned char isunsigned);
extern void dcallrts(char *sname, Kind to);
extern void zconvert_to_decimal(Kind from, Kind to, unsigned char isunsigned, unsigned char toissigned);
extern void zconvert_from_decimal(Kind from, Kind to, unsigned char isunsigned);
extern void force(Kind t1, Kind t2, char isunsigned1, char isunsigned2, int isconst);
extern void zconvert_to_long(unsigned char tounsigned, Kind from, unsigned char fromunsigned);
extern void zconvert_to_llong(unsigned char tounsigned, Kind from, unsigned char fromunsigned);
extern void gen_leave_function(Kind save,char type, int incritical);
extern int gen_push_function_argument(Kind expr, Type *type, int push_sdccchar);
extern void gen_switch_preamble(Kind kind);
extern void gen_switch_case(Kind kind, int64_t value, int label);
extern void gen_switch_postamble(Kind kind);
extern void gen_jp_label(int label, int end_of_scope);
extern void gen_save_pointer(LVALUE *lval);

extern int gen_restore_frame_after_call(int offset, Kind save, int saveaf, int usebc);

extern void opjump(char *cc, int label, int end_of_scope);
extern void testjump(LVALUE *,int label);
extern void zerojump(void (*oper)(LVALUE *,int), int label, LVALUE *lval);

extern void zadd_const(LVALUE *lval, int64_t value);
extern void zadd(LVALUE *);
extern void zsub(LVALUE *);
extern void mult(LVALUE *);
extern void mult_const(LVALUE *lval, int64_t value);
extern int mult_dconst(LVALUE *lval, double value, int isrhs);
extern void zdiv(LVALUE *);
extern void zdiv_const(LVALUE *lval, int64_t value);
extern int zdiv_dconst(LVALUE *lval, double value, int isrhs);
extern void zmod(LVALUE *);
extern void zmod_const(LVALUE *lval, int64_t value);
extern void zor(LVALUE *);
extern void zor_const(LVALUE *lval, int64_t value);
extern void zxor(LVALUE *);
extern void zxor_const(LVALUE *lval, int64_t value);
extern void zand(LVALUE *);
extern void zand_const(LVALUE *lval, int64_t value);
extern void asr(LVALUE *);
extern void asr_const(LVALUE *lval, int64_t value);
extern void asl(LVALUE *);
extern void asl_const(LVALUE *lval, int64_t value);
extern void lneg(LVALUE *);
extern void neg(LVALUE *);
extern void com(LVALUE *);
extern void inc(LVALUE *);
extern void dec(LVALUE *);
extern void zeq(LVALUE *);
extern void zeq_const(LVALUE *m, int64_t value);
extern void zne(LVALUE *);
extern void zne_const(LVALUE *, int64_t value);
extern void zlt(LVALUE *);
extern void zlt_const(LVALUE *, int64_t value);
extern void zle(LVALUE *);
extern void zle_const(LVALUE *, int64_t value);
extern void zgt(LVALUE *);
extern void zgt_const(LVALUE *, int64_t value);
extern void zge(LVALUE *);
extern void zge_const(LVALUE *, int64_t value);


extern void copy_to_stack(char *label, int stack_offset,  int size);
extern void copy_to_extern(const char *src, const char *dest, int size);
extern void gen_builtin_strcpy(void); 
extern void gen_builtin_strchr(int32_t c); 
extern void gen_builtin_memset(int32_t c, int32_t s);
extern void gen_builtin_memcpy(int32_t src, int32_t n);
extern void gen_address(SYMBOL *ptr);

extern void zconvert_to_long(unsigned char tounsigned, Kind from, unsigned char fromunsigned);
extern void zconvert_to_llong(unsigned char tounsigned, Kind from, unsigned char fromunsigned);


/* const.c */
extern int        constant(LVALUE *lval);


extern int        storeq(int length, unsigned char *queue,int32_t *val);
extern int        qstr(double *val);
extern void       stowlit(int value, int size);
extern void       size_of(LVALUE *lval);
extern void       offset_of(LVALUE *lval);
extern void       load_fixed(LVALUE *lval);
extern void       load_double_into_fa(LVALUE *lval);
extern void       load_llong_into_acc(zdouble val);
extern void       write_constant_queue(void);
extern void       indicate_constant_written(int litlab);
extern int        ir_pool_litlab_llong(zdouble dval);
extern int        ir_pool_litlab_double(zdouble value);

extern void       dofloat(enum maths_mode mode, double raw, unsigned char fa[]);
#include "data.h"

/* declinit.c */
extern int        initials(const char *dropname, Type *type, Node **out_init);
extern int        str_init(Type *tag, array **out_list);

extern array     *array_init(void (*destructor)(void *));
extern void       array_free(array *arr);
extern size_t     array_len(array *arr);
extern void       array_add(array *arr, void *elem);
extern void array_del_byindex(array *arr, int index);
extern void array_insert(array *arr, int index, void *elem);
extern void      *array_get_byindex(array *arr, int index);
extern void       array_set_byindex(array *arr, int index, void *elem);
extern Type      *find_tag(const char *name);
extern Type      *find_tag_field(Type *tag, const char *fieldname);
extern Type      *parse_expr_type(void);
extern Type      *default_function(const char *name);
extern Type      *default_function_with_type(const char *name, Type *return_type);
extern Type     *asm_function(const char *name);
extern Type      *make_pointer(Type *base_type);
extern Type      *dodeclare(enum storage_type storage);
extern Node      *declare_local(int local_static);
extern void       declare_func_kr(void);
extern int        ispointer(Type *type);
extern void       type_describe(Type *type, UT_string *output);
extern void       flags_describe(Type *type, int32_t flags, UT_string *output);
extern int        type_matches(Type *t1, Type *t2);
extern int        type_matches_pointer(Type *t1, Type *t2);
extern void       parse_addressmod(void);
extern namespace *get_namespace(const char *name);
extern void       check_pointer_namespace(Type *lhs, Type *rhs);
extern int        isutype(Type *type);

/* error.c */
extern int        endst(void);
extern void       illname(char *sname);
extern void       multidef(const char *sname);
extern void       needtoken(char *str);
extern void       needchar(char c);
extern void       needlval(void);
extern void       warningfmt(const char *category,const char *fmt, ...);
extern void       warningfmt_at(const char *category, const char *file, int line, const char *fmt, ...);
extern void       debug(int num,char *str,...);
extern void       errorfmt(const char *fmt, int fatal, ...);
extern void       errorfmt_at(const char *file, int line, int fatal, const char *fmt, ...);
extern void       parse_warning_option(const char *value);

/* cpp_invoke.c */
extern void       cpp_add_arg(const char *arg);
extern FILE      *cpp_open(const char *cpp_exe, const char *input_file);
extern int        cpp_close(FILE *fp);

/* expr.c */
extern struct nodepair *expression(int *con, zdouble *val, Type **type);
extern int        heir1(LVALUE *lval);
extern int        heira(LVALUE *lval);


/* goto.c */
extern GOTO_TAB *gotoq; /* Pointer for gotoq */
extern Node     *dolabel(void);
extern Node     *dogoto(void);
extern void      goto_cleanup(void);

#include "io.h"

/* lex.c */
extern int      streq(char str1[], char str2[]);
extern int      astreq(char *str1, char *str2);
extern int      match(char *lit);
extern int      cmatch(char lit);
extern int      acmatch(char lit);
extern int      rmatch2(char* lit);
extern int      rcmatch(char lit);
extern int      amatch(char *lit);
extern int      swallow(int kw_id);
extern int      checkws(void);



/* main.c */
extern void     ccabort(void);
extern void     dumplits(int size, int pr_label, int queueptr, int queuelab, unsigned char *queue);
extern int      dumpzero(int size, int count);
extern void     openin(void);
extern void     newfile(void);
extern void     closeout(void);
extern void     WriteDefined(char *sname, int value);

extern int      c_notaltreg;
extern int      c_cline_directive;
extern int      c_cpu;
extern int      c_params_offset;
extern int      c_fp_mantissa_bytes;
extern int      c_fp_exponent_bias;
extern int      c_old_diagnostic_fmt;
extern int      c_ast_print;
extern int      c_ast_print_types;


#include "misc.h"

/* ast_code.c */
extern void     ast_generate_code2(Node *node);
extern void     ast_normalize_types(Node *node);

/* ast_opt.c */
extern Node    *ast_fold_constants(Node *node);
extern Node    *ast_simplify_algebraic(Node *node);
extern Node    *ast_strength_reduce(Node *node);
extern Node    *ast_compoundify_assign(Node *node);
extern Node    *ast_const_propagate(Node *node);
extern Node    *ast_dead_code(Node *node);
extern Node    *ast_thread_jumps(Node *node);
extern Node    *ast_cse(Node *node);
extern Node    *ast_cse_synthesize(Node *node);
extern Node    *ast_licm(Node *node);
extern Node    *ast_dse(Node *node);
extern Node    *ast_demote_unused_poststep(Node *node);
extern Node    *ast_loop_reverse(Node *node);
extern Node    *ast_typecheck(Node *node);
extern Node    *ast_opt_run(Node *node);

/* node.c */
extern Node    *ast_decl(SYMBOL *sym, Node *declvar);
extern Node    *ast_undecl(SYMBOL *sym);
extern Node    *ast_function_call(int ast_type, SYMBOL *sym, Type *func_type, array *args);
extern Node    *ast_local_var(SYMBOL *sym, const char *name);
extern Node    *ast_global_var(SYMBOL *sym, const char *name);
extern Node    *ast_conditional(Node *cond, Node *then, Node *nelse);
extern Node    *ast_binop(int ast_type, Node *left, Node *right);
extern Node    *ast_uop(int ast_type, Node *op);
extern Node    *ast_return(Node *retval, Type *desired_return_type);
extern Node    *ast_compound(array *nodes);
extern Node    *ast_label(int label, const char *slabel);
extern Node    *ast_jump(int label, const char *slabel);
extern Node    *ast_literal(Type *type, zdouble value);
extern Node    *ast_str_lit(int offs);
extern Node    *ast_critical(Node *node);
extern Node    *ast_loop_countdown(Node *init, Node *body, int exit_label, int step_label, int width8);
extern Node    *ast_preserve_bc(Node *child);
extern Node    *ast_init_static(const char *labelname, int size);
extern Node    *ast_init_list(array *elems);
extern Node    *ast_asm(const char *text);
extern Node    *ast_switch(Type *sw_type, Node *sw_Expr, Node *case_code, array *cases, int default_label, int exit_label);
extern Node    *ast_switch_case(Type *sw_type, Node *sw_value, int label);
extern Node    *ast_cast(Type *to, Node *node);
extern void     print_ast(UT_string *output, Node *node);

/* plunge.c */
extern int      skim(TokenKind tk_op, int (*heir)(LVALUE* lval), LVALUE *lval);
extern void     dropout(int k, int is_or, int exit1, LVALUE *lval);
extern int      plnge1(int (*heir)(LVALUE* lval), LVALUE *lval);
extern void     plnge2a(int (*heir)(LVALUE* lval), LVALUE *lval, LVALUE *lval2, void (*oper)(LVALUE *lval), void (*doper)(LVALUE *lval), int ast_type);
extern void     plnge2b(int (*heir)(LVALUE* lval), LVALUE *lval, LVALUE *lval2, void (*oper)(LVALUE *lval));
extern void     load_constant(LVALUE *lval);

/* preproc.c */
extern void     junk(void);
extern char     ch(void);
extern char     nch(void);
extern char     gch(void);
extern void     clear(void);
extern char     inbyte(void);
extern void     vinline(void);
extern void     preprocess(void);
extern void     cache_source_line(int n, const char *text);
extern const char *get_source_line(const char *filename, int n);

/* primary.c */
extern int      primary(LVALUE *lval);
extern int      intcheck(LVALUE *lval, LVALUE *lval2);
extern void     force(Kind to, Kind from, char to_sign, char from_sign, int lconst);
extern int      widen_if_float(LVALUE *lval, LVALUE *lval2, int operator_is_commutative);
extern void     widenintegers(LVALUE *lval, LVALUE *lval2);
extern int      dbltest(LVALUE *lval, LVALUE *lval2);
extern void     result(LVALUE *lval, LVALUE *lval2);
extern void     prestep(LVALUE *lval, int n, void (*step)(LVALUE *lval), int ast_type);
extern void     poststep(int k, LVALUE *lval, int n, void (*step)(LVALUE *lval), void (*unstep)(LVALUE *lval), int ast_type);
extern void     store(LVALUE *lval);
extern void     rvaluest(LVALUE *lval);
extern void     rvalue(LVALUE *lval);
extern struct nodepair *test(int label, int parens);
extern int      constexpr(double *val, Kind *valtype, int flag);
extern void     cscale(Type *type, int *val);
extern int      docast(LVALUE *lval,LVALUE *dest_lval);
extern void     convert_int_to_double(char type, char zunsign);
extern int      ulvalue(LVALUE *lval);
extern void     check_assign_range(Type *type, double const_value);

/* stmt.c */
extern struct nodepair *statement(void);
extern void     gen_leave_function(Kind save,char type, int incritical);
extern Node    *doasm(void);
extern void     dopragma(void);
extern Node    *doasmfunc(char wantbr);


/* sym.c */
extern SYMBOL  *findstc(char *sname);
extern SYMBOL  *findglb(const char *sname);
extern SYMBOL  *findloc(char *sname);
extern SYMBOL  *addglb(char *sname, Type *type, enum ident_type id, Kind kind, int value, enum storage_type storage);
extern SYMBOL  *addloc(char *sname, Type *type, enum ident_type id, Kind kind, int where);
extern void     sym_undecl_frame(array *arr, SYMBOL *target, int need_undecl);



/* while.c */
extern void     addwhile(WHILE_TAB *ptr);
extern void     delwhile(void);
extern WHILE_TAB *readwhile(WHILE_TAB *ptr);
#endif
