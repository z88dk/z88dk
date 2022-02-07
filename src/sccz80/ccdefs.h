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

extern void     callfunction(SYMBOL *ptr, Type *func_ptr_call_type);


/* cdbfile.c */
extern void     debug_write_module();
extern void     debug_write_symbol(SYMBOL *sym);
extern void     debug_write_type(Type *type);

#include "codegen.h"

extern void gen_comment(const char *comment);
extern void gen_file_header(void);
extern void gen_file_footer(void);
extern void gen_switch_section(const char *section_name);


extern void gen_store_to_tos(Kind typeobj);
extern void gen_conv_uint2char(void);
extern void gen_conv_sint2char(void);
extern void gen_conv_uint2long(void);
extern void gen_conv_sint2long(void);
extern void gen_conv_carry2int(void);
extern void gen_call(int nargs_count, const char *name, SYMBOL *sym);

extern void gen_intrinsic_in(SYMBOL *sym);
extern void gen_intrinsic_out(SYMBOL *sym);

extern void gen_swap_float(Kind float_type);
extern void gen_pop_frame(void);
extern void gen_push_frame(void);
extern void gen_push_float(Kind typeToPush);
extern void gen_push_primary(LVALUE *lval);

extern int zinterruptoffset(SYMBOL *sym);
extern void gen_interrupt_enter(SYMBOL *func);
extern void gen_interrupt_leave(SYMBOL *func);

extern void gen_critical_enter(void);
extern void gen_critical_leave(void);
extern void gen_shortcall(Type *functype, int rst, int value);
extern void gen_bankedcall(SYMBOL *sym);
extern void gen_hl_call(Type *functype, int module, int address);
extern void gen_emit_line(int);

extern void gen_load_indirect(LVALUE *lval);
extern void gen_load_static(SYMBOL *sym);
extern void gen_store_static(SYMBOL *sym);
extern void gen_load_constant_as_float(double value, Kind to, unsigned char isunsigned);
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
extern void eq0(LVALUE *,int label);
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
extern void dummy(LVALUE *);


extern void copy_to_stack(char *label, int stack_offset,  int size);
extern void copy_to_extern(const char *src, const char *dest, int size);
extern void gen_builtin_strcpy(); 
extern void gen_builtin_strchr(int32_t c); 
extern void gen_builtin_memset(int32_t c, int32_t s);
extern void gen_builtin_memcpy(int32_t src, int32_t n);

extern void zconvert_to_long(unsigned char tounsigned, Kind from, unsigned char fromunsigned);
extern void zconvert_to_llong(unsigned char tounsigned, Kind from, unsigned char fromunsigned);


/* const.c */
extern int        constant(LVALUE *lval);

extern void       address(SYMBOL *ptr);

extern int        storeq(int length, unsigned char *queue,int32_t *val);
extern int        qstr(double *val);
extern void       stowlit(int value, int size);
extern unsigned char litchar(void);
extern void       size_of(LVALUE *lval);
extern void       offset_of(LVALUE *lval);
extern void       load_double_into_fa(LVALUE *lval);
extern void       load_llong_into_acc(zdouble val);
extern void       write_constant_queue(void);
extern void       indicate_constant_written(int litlab);

extern void       dofloat(enum maths_mode mode, double raw, unsigned char fa[]);
#include "data.h"

/* declinit.c */
extern int        initials(const char *dropname, Type *type);
extern int        str_init(Type *tag);

extern void       array_free(array *arr);
extern size_t     array_len(array *arr);
extern void       array_add(array *arr, void *elem);
extern void      *array_get_byindex(array *arr, int index);
extern Type      *find_tag(const char *name);
extern Type      *find_tag_field(Type *tag, const char *fieldname);
extern Type      *parse_expr_type();
extern Type      *default_function(const char *name);
extern Type      *default_function_with_type(const char *name, Type *return_type);
extern Type     *asm_function(const char *name);
extern Type      *make_pointer(Type *base_type);
extern Type      *dodeclare(enum storage_type storage);
extern int        declare_local(int local_static);
extern void       declare_func_kr();
extern int        ispointer(Type *type);
extern void       type_describe(Type *type, UT_string *output);
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
extern void       debug(int num,char *str,...);
extern void       errorfmt(const char *fmt, int fatal, ...);
extern void       parse_warning_option(const char *value);

/* expr.c */
extern Kind       expression(int *con, zdouble *val, Type **type);
extern int        heir1(LVALUE *lval);
extern int        heira(LVALUE *lval);


/* goto.c */
extern GOTO_TAB *gotoq; /* Pointer for gotoq */
extern int      dolabel(void);
extern void     dogoto(void);
extern void     goto_cleanup(void);

#include "io.h"
extern void     discardbuffer(t_buffer *buf);

/* lex.c */
extern int      streq(char str1[], char str2[]);
extern int      astreq(char *str1, char *str2);
extern int      match(char *lit);
extern int      cmatch(char lit);
extern int      acmatch(char lit);
extern int      rmatch2(char* lit);
extern int      rcmatch(char lit);
extern int      amatch(char *lit);
extern int      swallow(char *lit);
extern int      checkws();



/* main.c */
extern void     ccabort(void);
extern void     dumplits(int size, int pr_label, int queueptr, int queuelab, unsigned char *queue);
extern int      dumpzero(int size, int count);
extern void     openin(void);
extern void     newfile(void);
extern void     doinclude(void);
extern void     endinclude(void);
extern void     closeout(void);
extern void     WriteDefined(char *sname, int value);

extern int      c_notaltreg;
extern int      c_cline_directive;
extern int      c_cpu;
extern int      c_params_offset;
extern int      c_fp_mantissa_bytes;
extern int      c_fp_exponent_bias;
extern int      c_old_diagnostic_fmt;


#include "misc.h"

/* plunge.c */
extern int      skim(char *opstr, void (*testfuncz)(LVALUE* lval, int label), void (*testfuncq)(int label), int dropval, int endval, int (*heir)(LVALUE* lval), LVALUE *lval);
extern void     dropout(int k, void (*testfuncz)(LVALUE* lval, int label), void (*testfuncq)(int label), int exit1, LVALUE *lval);
extern int      plnge1(int (*heir)(LVALUE* lval), LVALUE *lval);
extern void     plnge2a(int (*heir)(LVALUE* lval), LVALUE *lval, LVALUE *lval2, void (*oper)(LVALUE *lval), void (*doper)(LVALUE *lval), void (*constoper)(LVALUE *lval, int64_t constval), int (*dconstoper)(LVALUE *lval, double const_val, int isrhs));
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
extern void     addmac(void);
extern void     delmac(void);
extern char     putmac(char c);
extern void     defmac(char *text);
extern void     set_temporary_input(FILE *temp);
extern void     restore_input(void);
extern void     push_buffer_fp(FILE *fp);
extern void     pop_buffer_fp(void);

/* primary.c */
extern int      primary(LVALUE *lval);
extern zdouble  calc(Kind left_kind, zdouble left, void (*oper)(LVALUE *), Kind right_kind, zdouble right, int is16bit);
extern zdouble  calcun(Kind left_kind, zdouble left, void (*oper)(LVALUE *), Kind right_kind, zdouble right);
extern int      intcheck(LVALUE *lval, LVALUE *lval2);
extern void     force(Kind to, Kind from, char to_sign, char from_sign, int lconst);
extern int      widen_if_float(LVALUE *lval, LVALUE *lval2, int operator_is_commutative);
extern void     widenintegers(LVALUE *lval, LVALUE *lval2);
extern int      dbltest(LVALUE *lval, LVALUE *lval2);
extern void     result(LVALUE *lval, LVALUE *lval2);
extern void     prestep(LVALUE *lval, int n, void (*step)(LVALUE *lval));
extern void     poststep(int k, LVALUE *lval, int n, void (*step)(LVALUE *lval), void (*unstep)(LVALUE *lval));
extern void     smartpush(LVALUE *lval, char *before);
extern void     smartstore(LVALUE *lval);
extern void     rvaluest(LVALUE *lval);
extern void     rvalue(LVALUE *lval);
extern int      test(int label, int parens);
extern int      constexpr(double *val, Kind *valtype, int flag);
extern void     cscale(Type *type, int *val);
extern int      docast(LVALUE *lval,LVALUE *dest_lval);
extern void     convert_int_to_double(char type, char zunsign);
extern int      ulvalue(LVALUE *lval);
extern int      check_lastop_was_testjump(LVALUE *lval);
extern int      check_range(LVALUE *lval, int32_t min_value, int32_t max_value) ;
extern void     check_assign_range(Type *type, double const_value);

/* stmt.c */
extern int      statement(void);
extern void     gen_leave_function(Kind save,char type, int incritical);
extern void     doasm(void);
extern void     dopragma(void);
extern void     doasmfunc(char wantbr);


/* sym.c */
extern SYMBOL  *findstc(char *sname);
extern SYMBOL  *findglb(const char *sname);
extern SYMBOL  *findloc(char *sname);
extern SYMBOL  *addglb(char *sname, Type *type, enum ident_type id, Kind kind, int value, enum storage_type storage);
extern SYMBOL  *addloc(char *sname, Type *type, enum ident_type id, Kind kind, int where);

/* while.c */
extern void     addwhile(WHILE_TAB *ptr);
extern void     delwhile(void);
extern WHILE_TAB *readwhile(WHILE_TAB *ptr);
#endif
