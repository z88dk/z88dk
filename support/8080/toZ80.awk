# toZ80.awk
# Convert any 8080 assembler source file to Z80 mnemonics
# Copyright (c) 2003 Douglas Beattie Jr.
# All rights reserved world-wide
#
# Re-arranged for Z88DK by Stefano Bodrato
#
# There's an experimental section specific for z80asm (labels); 
# remove the whole section for a more classic output
#


BEGIN {
 temp_xyz = "zyx"     # temporary replacement for Mnemonic
 temp_label = "zz" # temporary replacement for ^LABEL
 label = "?"          # storage for label during conversion
 label_reg_exp = "^[^; \t]+"
 instr_tabulator = "\t" # space between operator and operand on some converted

 # Record separator
 RS = "\r\n"		# CRLF ...comment out for newline only or alter as required
 #RS = "\n"		# CR only ...sometimes this is the right option

}

function save_label() {
    if (match($0,/^[^; \t]+/)) {
        label = substr($0,RSTART,RLENGTH)
        #printf("%d %d",RSTART,RLENGTH);
        sub(label_reg_exp,temp_label)
    }
  #save symbols
        sub(/@/,"czhzi");
        sub(/+/,"pzlzs");
        sub(/-/,"mzizn");
        sub(/*/,"mzuzl");  #*/  just to fix the colouring of some editor :o)
        sub("/","dzizv");
}


function restore_label() {
    if (label != "?") {
        sub(temp_label,label)
        label = "?"          # init for next label
    }
  #restore symbols
        sub("czhzi",/@/);
        sub("pzlzs","+");
        sub("mzizn","-");
        sub("mzuzl","*");
        sub("dzizv","/");
}


function get_operand(op_regexp,op_len) {
        regexp_str = op_regexp "[ \t]+[^ \t,]+([, \t]|$)"
        match($0,regexp_str);
        tmp_str = substr($0,(RSTART+op_len),(RLENGTH-(op_len)))
        match(tmp_str,/[^ \t,]+/);
        tmp_str = substr(tmp_str,(RSTART),(RLENGTH))
        return tmp_str
}


# Substitute BC for B, DE for D, or HL for H in operand field
function sub_bdh() {
    if (match(wkg_str,/[BbDdHh]/)) {
        if (match(wkg_str,/[Bb]/)) {
            sub(/[Bb]/,"BC");
        }
        else if (match(wkg_str,/[Dd]/)) {
            sub(/[Dd]/,"DE");
        }
        else if (match(wkg_str,/[Hh]/)) {
            sub(/[Hh]/,"HL");
        }
    }
}


#### Z80ASM label redefinition
#### EQU to "defc"
    (/^[^;]*[ \t]+[eE][qQ][uU][ \t]/) {
        match_counter=match($0,";");
        match_result="";
        if (match_counter>0) match_result=substr($0,match_counter);
        print "defc", $1, " = " ,$3, match_result;
        next
    }
    
#### db to "defm"
    (/^[^; \t]*[ \t]+([Dd][Bb])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/''/,"zpicettaz");

	sub(/'/,"\"");
	sub(/'/,"\"");
        sub(/[Dd][Bb]/,"defm");

        sub("zpicettaz","'");
        restore_label()
        print $0
        next
    }

#### ds to "defs"
    (/^[^; \t]*[ \t]+([Dd][Ss])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Dd][Ss]/,"defs");
        restore_label()
        print $0
        next
    }

#### dw to "defw"
    (/^[^; \t]*[ \t]+([Dd][Ww])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Dd][Ww]/,"defw");
        restore_label()
        print $0
        next
    }

#### Label section end


#### look for "r,M"
    (/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[mM]/) {
        sub(/,[mM]/,",(HL)");
    }

#### look for "M,r"
    (/^[^; \t]*[ \t]+[^; \t]+[ \t]+[mM],[^; \t]+([; \t]|$)/) {
        sub(/[mM],/,"(HL),");
    }

#### MOV
############################
    (/^[^; \t]*[ \t]+[Mm][Oo][Vv][ \t]/) {
        save_label()
        sub(/[Mm][Oo][Vv]/,"LD ");
        restore_label()
        print $0
        next
    }

#### MVI
############################
    (/^[^; \t]*[ \t]+[Mm][Vv][Ii][ \t]/) {
        save_label()
        sub(/[Mm][Vv][Ii]/,"LD ");
        restore_label()
        print $0
        next
    }

#### LDAX
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Aa][Xx])/) {
        save_label()

        wkg_str =  get_operand("[Ll][Dd][Aa][Xx]",4);

        if (match(wkg_str,/[Dd]/)) {
            sub(/[Ll][Dd][Aa][Xx]/,temp_xyz);
            sub(wkg_str,"A,(DE)");
            sub(temp_xyz,"LD");

            restore_label()
            print $0
            next
        }

        else if (match(wkg_str,/[Bb]/)) {
            sub(/[Ll][Dd][Aa][Xx]/,temp_xyz);
            sub(wkg_str,"A,(BC)");
            sub(temp_xyz,"LD");

            restore_label()
            print $0
            next
        }

    }


#### STAX
############################
    (/^[^; \t]*[ \t]+([Ss][Tt][Aa][Xx])/) {
        save_label()

        wkg_str =  get_operand("[Ss][Tt][Aa][Xx]",4);

        if (match(wkg_str,/[Dd]/)) {
            sub(/[Ss][Tt][Aa][Xx]/,temp_xyz);
            sub(wkg_str,"(DE),A");
            sub(temp_xyz,"LD");

            restore_label()
            print $0
            next
        }

        else if (match(wkg_str,/[Bb]/)) {
            sub(/[Ss][Tt][Aa][Xx]/,temp_xyz);
            sub(wkg_str,"(BC),A");
            sub(temp_xyz,"LD");

            restore_label()
            print $0
            next
        }

    }


### LDA word
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Aa])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[Ll][Dd][Aa]",3);
            sub(/[Ll][Dd][Aa]/,temp_xyz);
            sub(wkg_str,"A,(" wkg_str ")" );
            sub(temp_xyz,"LD");

        restore_label()
        print $0
        next

    }

### STA word
############################
    (/^[^; \t]*[ \t]+([Ss][Tt][Aa])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[Ss][Tt][Aa]",3);

            sub(/[Ss][Tt][Aa]/,temp_xyz);
            sub(wkg_str,"(" wkg_str "),A" );
            sub(temp_xyz,"LD");

        restore_label()
        print $0
        next

    }

###   LXI   B/D/H/SP,word
############################
    (/^[^; \t]*[ \t]+([Ll][Xx][Ii])/) {
        save_label()


        wkg_str =  get_operand("[Ll][Xx][Ii]",3);
        sub_bdh()
        sub(/[Ll][Xx][Ii]/,"LD");

        restore_label()
        print $0
        next
    }

### LHLD word
############################
    (/^[^; \t]*[ \t]+([Ll][Hh][Ll][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Hh][Ll][Dd]",4);

            sub(/[Ll][Hh][Ll][Dd]/,temp_xyz);
            sub(wkg_str,"HL,(" wkg_str ")" );
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### SHLD word
############################
    (/^[^; \t]*[ \t]+([Ss][Hh][Ll][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Ss][Hh][Ll][Dd]",4);

        sub(/[Ss][Hh][Ll][Dd]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),HL" );
        sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }


#### Simple replacements (no operand)
############################


###### SPHL
    (/^[^; \t]*[ \t]+([Ss][Pp][Hh][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Ss][Pp][Hh][Ll]/,"LD"instr_tabulator"SP,HL");
        restore_label()
        print $0
        next
    }

###### XCHG
    (/^[^; \t]*[ \t]+([Xx][Cc][Hh][Gg])([; \t]|$)/) {
        save_label()
        sub(/[Xx][Cc][Hh][Gg]/,"EX"instr_tabulator"DE,HL");
        restore_label()
        print $0
        next
    }

###### XTHL
    (/^[^; \t]*[ \t]+([Xx][Tt][Hh][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Xx][Tt][Hh][Ll]/,"EX"instr_tabulator"(SP),HL");
        restore_label()
        print $0
        next
    }

###### HLT
    (/^[^; \t]*[ \t]+([Hh][Ll][Tt])/) {
        save_label()
        sub(/[Hh][Ll][Tt]/,"HALT");
        restore_label()
        print $0
        next
    }

###### PCHL
    (/^[^; \t]*[ \t]+([Pp][Cc][Hh][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Pp][Cc][Hh][Ll]/,"JP"instr_tabulator"(HL)");
        restore_label()
        print $0
        next
    }

###### ADI ACI
############################
    (/^[^; \t]*[ \t]+[aA]([dD]|[cC])[iI][ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[aA]([dD]|[cC])[iI]",3);

        if (match($0,/[Aa][Dd][Ii]/)) {
            sub(/[Aa][Dd][Ii]/,temp_xyz);
            sub(wkg_str,"A," wkg_str );
            sub(temp_xyz,"ADD")
        }
        else if (match($0,/[Aa][Cc][Ii]/)) {
            sub(/[Aa][Cc][Ii]/,temp_xyz);
            sub(wkg_str,"A," wkg_str );
            sub(temp_xyz,"ADC")
        }

        restore_label()
        print $0;
        next
    }


###### SUI SBI
############################
    (/^[^; \t]*[ \t]+[sS]([uU]|[bB])[iI][ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Ss][Uu][Ii]/)) {
            sub(/[Ss][Uu][Ii]/,"SUB");
        }
        else if (match($0,/[Ss][Bb][Ii]/)) {
            sub(/[Ss][Bb][Ii]/,"SBC");
        }

        restore_label()
        print $0;
        next
    }

###### SBB
    (/^[^; \t]*[ \t]+[sS][bB][bB][ \t]+[^ \t]+([; \t]|$)/) {

        wkg_str =  get_operand("([Ss][Bb][Bb])",3);
        if (match(wkg_str,/^[^;]*[Mm]/)) {
            sub(/[Mm]/,"(HL)");
        }

        save_label()

        if (match($0,/[sS][bB][bB]/)) {
            sub(/[sS][bB][bB]/,"SBC");
        }

        restore_label()
        print $0;
        next
    }

###### SUB M
    (/^[^; \t]*[ \t]+[sS][uU][bB][ \t]+[^ \t]+([; \t]|$)/) {

        wkg_str =  get_operand("([Ss][Uu][Bb])",3);
        if (match(wkg_str,/^[^;]*[Mm]/)) {
            sub(/[Mm]/,"(HL)");
        }

        print $0;
        next
    }

###### ADD ADC
############################
    (/^[^; \t]*[ \t]+([aA][dD][dD]|[aA][dD][cC])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("([aA][dD][dD]|[aA][dD][cC])",3);

        if (match($0,/[Aa][Dd][Dd]/)) {
            sub(/[Aa][Dd][Dd]/,temp_xyz);
            sub(wkg_str,"A," wkg_str );
            sub(temp_xyz,"ADD")
        }
        else if (match($0,/[Aa][Dd][Cc]/)) {
            sub(/[Aa][Dd][Cc]/,temp_xyz);
            sub(wkg_str,"A," wkg_str );
            sub(temp_xyz,"ADC")
        }

        if (match(wkg_str,/^[^;]*[Mm]/)) {
            sub(/[Mm]/,"(HL)");
        }

        restore_label()
        print $0
        next
    }


###### DAD
############################

    (/^[^; \t]*[ \t]+([dD][aA][dD])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[dD][aA][dD]",3);
        sub(/[dD][aA][dD]/,temp_xyz);
        sub_bdh()
        sub(temp_xyz,"ADD")
        sub(/ADD[ \t]*/,"ADD"instr_tabulator"HL,")
        restore_label()
        print $0
        next
    }


###### INR DCR
############################
    (/^[^; \t]*[ \t]+([Ii][Nn][Rr]|[Dd][Cc][Rr])[ \t]/) {
        save_label()

        wkg_str =  get_operand("([Ii][Nn][Rr]|[Dd][Cc][Rr])",3);
        if (match(wkg_str,/^[^;]*[Mm]/)) {
            sub(/[Mm]/,"(HL)");
        }

        if (match($0,/[Ii][Nn][Rr]/)) {
            sub(/[Ii][Nn][Rr]/,"INC");
        }
        else if (match($0,/[Dd][Cc][Rr]/)) {
            sub(/[Dd][Cc][Rr]/,"DEC");
        }

        restore_label()
        print $0
        next
    }

###### INX DCX
############################
    (/^[^; \t]*[ \t]+([Ii][Nn][Xx]|[Dd][Cc][Xx])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("([Ii][Nn][Xx]|[Dd][Cc][Xx])",3);

        if (match($0,/[Ii][Nn][Xx]/)) {
            sub(/[Ii][Nn][Xx]/,temp_xyz);
            sub_bdh()
            sub(temp_xyz,"INC")
        }
        else if (match($0,/[Dd][Cc][Xx]/)) {
            sub(/[Dd][Cc][Xx]/,temp_xyz);
            sub_bdh()
            sub(temp_xyz,"DEC")
        }

        restore_label()
        print $0
        next
    }


###### CMA
############################
    (/^[^; \t]*[ \t]+([Cc][Mm][Aa])([; \t]|$)/) {
        save_label()
        sub(/[Cc][Mm][Aa]/,"CPL");
        restore_label()
        print $0
        next
    }

###### STC
############################
    (/^[^; \t]*[ \t]+([Ss][Tt][Cc])([; \t]|$)/) {
        save_label()
        sub(/[Ss][Tt][Cc]/,"SCF");
        restore_label()
        print $0
        next
    }

###### CMC
############################
    (/^[^; \t]*[ \t]+([Cc][Mm][Cc])([; \t]|$)/) {
        save_label()
        sub(/[Cc][Mm][Cc]/,"CCF");
        restore_label()
        print $0
        next
    }

###### RLC
############################
    (/^[^; \t]*[ \t]+([Rr][Ll][Cc])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Ll][Cc]/,"RLCA");
        restore_label()
        print $0
        next
    }

###### RRC
############################
    (/^[^; \t]*[ \t]+([Rr][Rr][Cc])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Rr][Cc]/,"RRCA");
        restore_label()
        print $0
        next
    }

###### RAL
############################
    (/^[^; \t]*[ \t]+([Rr][Aa][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Aa][Ll]/,"RLA");
        restore_label()
        print $0
        next
    }

###### RAR
############################
    (/^[^; \t]*[ \t]+([Rr][Aa][Rr])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Aa][Rr]/,"RRA");
        restore_label()
        print $0
        next
    }

###### ANI XRI ORI
############################
    (/^[^; \t]*[ \t]+([Aa][Nn][Ii]|[Xx][Rr][Ii]|[Oo][Rr][Ii])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Aa][Nn][Ii]/)) {
            sub(/[Aa][Nn][Ii]/,"AND");
        }
        else if (match($0,/[Xx][Rr][Ii]/)) {
            sub(/[Xx][Rr][Ii]/,"XOR");
        }
        else if (match($0,/[Oo][Rr][Ii]/)) {
            sub(/[Oo][Rr][Ii]/,"OR");
        }
        restore_label()
        print $0;
        next
    }

###### ANA XRA ORA
############################
    (/^[^; \t]*[ \t]+([Aa][Nn][Aa]|[Xx][Rr][Aa]|[Oo][Rr][Aa])[ \t]/) {
        save_label()

        wkg_str =  get_operand("([Aa][Nn][Aa]|[Xx][Rr][Aa]|[Oo][Rr][Aa])",3);
        if (match(wkg_str,/^[^;]*[Mm]/)) {
            sub(/[Mm]/,"(HL)");
        }

        if (match($0,/[Aa][Nn][Aa]/)) {
            sub(/[Aa][Nn][Aa]/,"AND");
        }
        else if (match($0,/[Xx][Rr][Aa]/)) {
            sub(/[Xx][Rr][Aa]/,"XOR");
        }
        else if (match($0,/[Oo][Rr][Aa]/)) {
            sub(/[Oo][Rr][Aa]/,"OR");
        }

        restore_label()
        print $0
        next
    }

###### CPI
############################
    (/^[^; \t]*[ \t]+([Cc][Pp][Ii])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Cc][Pp][Ii]/,"CP");

        restore_label()
        print $0;
        next
    }

###### CMP
############################
    (/^[^; \t]*[ \t]+([Cc][Mm][Pp])[ \t]/) {
        save_label()

        wkg_str =  get_operand("[Cc][Mm][Pp]",3);

        sub(/[Cc][Mm][Pp]/,temp_xyz);
        if (match(wkg_str,/^[^;]*[Mm]/)) {
            sub(/[Mm]/,"(HL)");
        }
        sub(temp_xyz,"CP")

        restore_label()
        print $0
        next
    }

###### JMP
############################
    (/^[^; \t]*[ \t]+([Jj][Mm][Pp])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Jj][Mm][Pp]/,"JP");

        restore_label()
        print $0;
        next
    }

###### JNZ JNC JPO JPE
############################
    (/^[^; \t]*[ \t]+[Jj]([Nn][Zz]|[Nn][Cc]|[Pp][Oo]|[Pp][Ee])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Jj][Nn][Zz][ \t]+/)) {
            sub(/[Jj][Nn][Zz][ \t]+/,"JP"instr_tabulator"NZ,");
        }
        else if (match($0,/[Jj][Nn][Cc][ \t]+/)) {
            sub(/[Jj][Nn][Cc][ \t]+/,"JP"instr_tabulator"NC,");
        }
        else if (match($0,/[Jj][Pp][Oo][ \t]+/)) {
            sub(/[Jj][Pp][Oo][ \t]+/,"JP"instr_tabulator"PO,");
        }
        else if (match($0,/[Jj][Pp][Ee][ \t]+/)) {
            sub(/[Jj][Pp][Ee][ \t]+/,"JP PE,");
        }

        restore_label()
        print $0;
        next
    }

###### JZ JC JP JM
############################
    (/^[^; \t]*[ \t]+[Jj]([Zz]|[Cc]|[Pp]|[Mm])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/^[^;]*[Jj][Zz][ \t]+/)) {
            sub(/[Jj][Zz][ \t]+/,"JP"instr_tabulator"Z,");
        }
        else if (match($0,/^[^;]*[Jj][Cc][ \t]+/)) {
            sub(/[Jj][Cc][ \t]+/,"JP"instr_tabulator"C,");
        }
        else if (match($0,/^[^;]*[Jj][Pp][ \t]+/)) {
            sub(/[Jj][Pp][ \t]+/,"JP"instr_tabulator"P,");
        }
        else if (match($0,/^[^;]*[Jj][Mm][ \t]+/)) {
            sub(/[Jj][Mm][ \t]+/,"JP"instr_tabulator"M,");
        }

        restore_label()
        print $0;
        next
    }




###### CNZ CNC CPO CPE
############################
    (/^[^; \t]*[ \t]+[Cc]([Nn]([Zz]|[Cc])|([Pp]([Oo]|[Ee])))[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Cc][Nn][Zz][ \t]+/)) {
            sub(/[Cc][Nn][Zz][ \t]+/,"CALL"instr_tabulator"NZ,");
        }
        else if (match($0,/[Cc][Nn][Cc][ \t]+/)) {
            sub(/[Cc][Nn][Cc][ \t]+/,"CALL"instr_tabulator"NC,");
        }
        else if (match($0,/[Cc][Pp][Oo][ \t]+/)) {
            sub(/[Cc][Pp][Oo][ \t]+/,"CALL"instr_tabulator"PO,");
        }
        else if (match($0,/[Cc][Pp][Ee][ \t]+/)) {
            sub(/[Cc][Pp][Ee][ \t]+/,"CALL"instr_tabulator"PE,");
        }

        restore_label()
        print $0;
        next
    }

###### CZ CC CP CM
############################
    (/^[^; \t]*[ \t]+[Cc]([Zz]|[Cc]|[Pp]|[Mm])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Cc][Zz][ \t]+/)) {
            sub(/[Cc][Zz][ \t]+/,"CALL"instr_tabulator"Z,");
        }
        else if (match($0,/[Cc][Cc][ \t]+/)) {
            sub(/[Cc][Cc][ \t]+/,"CALL"instr_tabulator"C,");
        }
        else if (match($0,/[Cc][Pp][ \t]+/)) {
            sub(/[Cc][Pp][ \t]+/,"CALL"instr_tabulator"P,");
        }
        else if (match($0,/[Cc][Mm][ \t]+/)) {
            sub(/[Cc][Mm][ \t]+/,"CALL"instr_tabulator"M,");
        }

        restore_label()
        print $0;
        next
    }

###### RNZ RNC RPO RPE
############################

    (/^[^; \t]*[ \t]+[Rr]([Nn]([Zz]|[Cc])|([Pp]([Oo]|[Ee])))/) {

        save_label()

        if (match($0,/[Rr][Nn][Zz]+/)) {
            sub(/[Rr][Nn][Zz]+/,"RET"instr_tabulator"NZ");
        }
        else if (match($0,/[Rr][Nn][Cc]+/)) {
            sub(/[Rr][Nn][Cc]+/,"RET"instr_tabulator"NC");
        }
        else if (match($0,/[Rr][Pp][Oo][ \t]+/)) {
            sub(/[Rr][Pp][Oo]+/,"RET"instr_tabulator"PO");
        }
        else if (match($0,/[Rr][Pp][Ee][ \t]+/)) {
            sub(/[Rr][Pp][Ee]+/,"RET"instr_tabulator"PE");
        }

        restore_label()
        print $0;
        next
    }

###### RZ RC RP RM
############################

    (/^[^; \t]*[ \t]+[Rr]([Zz]|[Cc]|[Pp]|[Mm])/) {
        save_label()

        if (match($0,/[Rr][Zz]+/)) {
            sub(/[Rr][Zz]+/,"RET"instr_tabulator"Z");
        }
        else if (match($0,/[Rr][Cc]+/)) {
            sub(/[Rr][Cc]+/,"RET"instr_tabulator"C");
        }
        else if (match($0,/[Rr][Pp]+/)) {
            sub(/[Rr][Pp]+/,"RET"instr_tabulator"P");
        }
        else if (match($0,/[Rr][Mm]+/)) {
            sub(/[Rr][Mm]+/,"RET"instr_tabulator"M");
        }

        restore_label()
        print $0;
        next
    }

###### RST 0..7
############################
    (/^[^; \t]*[ \t]+([Rr][Ss][Tt])[ \t]/) {
        save_label()

        wkg_str =  get_operand("[Rr][Ss][Tt]",3);

        if (match(wkg_str,/^[^;]*1/)) {
            sub(/1/,"08h");
        }
        else if (match(wkg_str,/^[^;]*2/)) {
            sub(/2/,"10h");
        }
        else if (match(wkg_str,/^[^;]*3/)) {
            sub(/3/,"18h");
        }
        else if (match(wkg_str,/^[^;]*4/)) {
            sub(/4/,"20h");
        }
        else if (match(wkg_str,/^[^;]*5/)) {
            sub(/5/,"28h");
        }
        else if (match(wkg_str,/^[^;]*6/)) {
            sub(/6/,"30h");
        }
        else if (match(wkg_str,/^[^;]*7/)) {
            sub(/7/,"38h");
        }

        restore_label()
        print $0
        next
    }

###### PUSH B/D/H/PSW
############################

    (/^[^; \t]*[ \t]+([Pp][Uu][Ss][Hh])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[Pp][Uu][Ss][Hh]",4);
        sub(/[Pp][Uu][Ss][Hh]/,temp_xyz);
        sub_bdh()
        if (match(wkg_str,/[Pp][Ss][Ww]/)) {
            sub(/[Pp][Ss][Ww]/,"AF");
        }
        sub(temp_xyz,"PUSH")

        restore_label()
        print $0
        next
    }

###### POP B/D/H/PSW
############################

    (/^[^; \t]*[ \t]+([Pp][Oo][Pp])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[Pp][Oo][Pp]",3);
        #sub(/[Pp][Oo][Pp]/,temp_xyz);
        sub_bdh()
        if (match(wkg_str,/[Pp][Ss][Ww]/)) {
            sub(/[Pp][Ss][Ww]/,"AF");
        }
        #sub(temp_xyz,"POP")

        restore_label()
        print $0
        next
    }

### OUT byte
############################
    (/^[^; \t]*[ \t]+([Oo][Uu][Tt])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Oo][Uu][Tt]",3);

        sub(/[Oo][Uu][Tt]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),A" );
        sub(temp_xyz,"OUT")

        restore_label()
        print $0
        next
    }

### IN byte
############################
    (/^[^; \t]*[ \t]+([Ii][Nn])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ii][Nn]",2);

            sub(/[Ii][Nn]/,temp_xyz);
            sub(wkg_str,"A,(" wkg_str ")" );
            sub(temp_xyz,"IN")

        restore_label()
        print $0
        next
    }

###### END
#    (/^[^; \t]*[ \t]+([Ee][Nn][Dd])/) {
#        save_label()
#        sub(/[Ee][Nn][Dd]/,";END of program");
#        restore_label()
#        print $0
#        next
#    }

###### Default
(/^.*/) {
    print $0
    next
}
