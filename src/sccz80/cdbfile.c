#include "ccdefs.h"


static void write_cdb_type(UT_string *output, Type *type,int comma);


void debug_write_module()
{
    utstring_printf(debug_utstr,"M:%.*s\n",(int)strlen(Filename)-2,Filename+1);
}


static void encode_cdbstring(UT_string *dest, const char *toencode)
{
    char c;

    while ( ( c = *toencode++) != 0 ) {
        if ( isalpha(c)) {
            utstring_printf(dest, "%c", c);
        } else {
            utstring_printf(dest, "_%02x",c);
        }
    }    
}


/* C = code, E = data, B = stack */

// Write the cdb declaration
void debug_write_symbol(SYMBOL *sym)
{
    UT_string *temp;

    utstring_new(temp);

    if ( sym->storage == LSTATIC ) {
        if ( sym->ctype->kind != KIND_FUNC ) {
            utstring_printf(temp,"S:F%.*s$%s$%d_0$",(int)strlen(Filename)-2,Filename+1,sym->name,sym->level);
        } else {
            utstring_printf(temp,"F:F%.*s$%s$%d_0$",(int)strlen(Filename)-2,Filename+1,sym->name,sym->level);
        }
        utstring_printf(temp,"%d", sym->scope_block); // Scope block
        utstring_printf(temp,"(");
        utstring_printf(temp,"{%d}", sym->ctype->size);
        write_cdb_type(temp, sym->ctype, 0);
        utstring_printf(temp,")");
        if ( sym->ctype->kind != KIND_FUNC ) {
            utstring_printf(temp,",E,0,0");
        } else {
            utstring_printf(temp,",C,0,%d",sym->ctype->funcattrs.params_offset);
        }
    } else if ( sym->storage == STATIK ) {
        if ( sym->ctype->kind != KIND_FUNC ) {
            utstring_printf(temp,"S:G$%s$%d_0$",sym->name, sym->level);
        } else {
            utstring_printf(temp,"F:G$%s$%d_0$",sym->name, sym->level);
        }
        utstring_printf(temp,"%d", sym->scope_block); // Scope block
        utstring_printf(temp,"(");
        utstring_printf(temp,"{%d}", sym->ctype->size);
        write_cdb_type(temp, sym->ctype, 0);
        utstring_printf(temp,")");
        if ( sym->ctype->kind != KIND_FUNC ) {
            utstring_printf(temp,",E,0,0");
        } else {
            utstring_printf(temp,",C,0,%d,0,0,0",sym->ctype->funcattrs.params_offset);
        }
    } else if ( sym->storage == STKLOC ) {
        utstring_printf(temp,"S:L%.*s.%s$%s$%d_0$",(int)strlen(Filename)-2,Filename+1,currfn->name,sym->name,sym->level);
        utstring_printf(temp,"%d", sym->scope_block); // Scope block
        utstring_printf(temp,"(");
        utstring_printf(temp,"{%d}", sym->ctype->size);
        write_cdb_type(temp, sym->ctype, 0);
        utstring_printf(temp,")");
        utstring_printf(temp,",B,1,%d",sym->offset.i);
    } else {
        return;
    }

    // Encode the cdbstring and output it as a defc
    utstring_printf(debug2_utstr, "; %s\n", utstring_body(temp));
    utstring_printf(debug2_utstr,"\tPUBLIC\t__CDBINFO__");
    encode_cdbstring(debug2_utstr, utstring_body(temp));
    utstring_printf(debug2_utstr,"\n");
    utstring_printf(debug2_utstr,"\tdefc\t__CDBINFO__");
    encode_cdbstring(debug2_utstr, utstring_body(temp));
    utstring_printf(debug2_utstr," = 1\n");

    utstring_concat(debug_utstr, temp);
    utstring_free(temp);
    utstring_printf(debug_utstr,"\n");
}

void debug_write_type(Type *type)
{
    int i;
    UT_string *temp;


    utstring_new(temp);

    if ( type->kind == KIND_STRUCT) {
        utstring_printf(temp,"T:F%.*s$%s",(int)strlen(Filename)-2,Filename+1,type->name);
        utstring_printf(temp,"[");
        for ( i = 0; i < array_len(type->fields); i++) {
            Type *f = array_get_byindex(type->fields, i);
            utstring_printf(temp,"({%d}S:S$%s$0_0$0({%d}",(int)f->offset,f->name,f->size);
            write_cdb_type(temp, f,0);
            utstring_printf(temp,"),Z,0,0)");
        }
        utstring_printf(temp,"]");
    }

    if ( utstring_len(temp) > 0 ) {
        // Encode the cdbstring and output it as a defc
        utstring_printf(debug2_utstr, "; %s\n", utstring_body(temp));
        utstring_printf(debug2_utstr,"\tPUBLIC\t__CDBINFO__");
        encode_cdbstring(debug2_utstr, utstring_body(temp));
        utstring_printf(debug2_utstr,"\n");
        utstring_printf(debug2_utstr,"\tdefc\t__CDBINFO__");
        encode_cdbstring(debug2_utstr, utstring_body(temp));
        utstring_printf(debug2_utstr," = 1\n");

        utstring_concat(debug_utstr, temp);
        utstring_free(temp);
        utstring_printf(debug_utstr,"\n");
    }
} 

void write_cdb_type(UT_string *output, Type *type,int comma)
{
    if ( type->ptr ) {
        if ( type->kind == KIND_ARRAY ) {
            utstring_printf(output,"%sDA%dx", comma ? "," : "",type->len);
        } else {
            utstring_printf(output,"%sDG", comma ? "," : "");
        }
        write_cdb_type(output, type->ptr, 1);
        return;
    }

    switch ( type->kind ) {
    case KIND_NONE:
        return;
    case KIND_VOID:
        utstring_printf(output,"%sDV",comma ? "," : "");
        break;
    case KIND_CHAR:
        utstring_printf(output,"%sSC:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_SHORT:
        utstring_printf(output,"%sSI:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_INT:
        utstring_printf(output,"%sSI:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_LONG:
        utstring_printf(output,"%sSL:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_LONGLONG:
        // This is wrong, but so is sdcc
        utstring_printf(output,"%sSI:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_FLOAT:
    case KIND_DOUBLE:    
        utstring_printf(output,"%sSF:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_FLOAT16:
        utstring_printf(output,"%sS6:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_ARRAY:
        utstring_printf(output,"%sDA%d", comma ? "," : "", type->size);
        break;
    case KIND_PTR:
        break;
    case KIND_CPTR:
       // utstring_printf(output,"*__far ");
        break;
    case KIND_STRUCT:
        utstring_printf(output,"%sST%s:S", comma ? "," : "", type->tag ? type->tag->name : type->name);
        break;
    case KIND_FUNC:
        utstring_printf(output,"%sDF", comma ? "," : "");
        write_cdb_type(output,type->return_type, 1);
        return;
    case KIND_ELLIPSES:
        return;
    case KIND_PORT8:
    case KIND_PORT16:
    case KIND_ENUM:
    case KIND_CARRY:
        break;
    }
    return;

}



/*
    char tail[100];
    int  i;

    tail[0] = 0;

    if ( type->ptr )
        type_describe(type->ptr,output);

    if ( type->namespace ) {
        utstring_printf(output,"%s ", type->namespace);
    }

    if ( type->isconst ) {
        utstring_printf(output,"const ");
    }
   
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
    case KIND_FLOAT16:
        utstring_printf(output,"_Float16 ");
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

*/
