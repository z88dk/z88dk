/* decl.c */
extern int dodeclare(enum storage_type storage, TAG_SYMBOL *mtag, int is_struct);
extern int get_ident(enum ident_type existing);
extern int dummy_idx(int typ, TAG_SYMBOL *otag);
extern void declglb(int typ, enum storage_type storage, TAG_SYMBOL *mtag, TAG_SYMBOL *otag, int is_struct, struct varid *var);
extern void declloc(int typ, TAG_SYMBOL *otag, char locstatic, struct varid *var);
extern uint32_t CalcArgValue(int type, enum ident_type ident, enum symbol_flags flags);
extern char *ExpandArgValue(uint32_t, char *buffer, char tagidx);
extern void ptrerror(int ident);
extern TAG_SYMBOL *GetVarID(struct varid *var,enum storage_type storage);
extern char *ExpandType(int type, char **sign, char tagidx);
extern int get_type_size(int type, TAG_SYMBOL *otag);
