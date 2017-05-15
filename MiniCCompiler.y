%{
    union UNION {int num; char* id; struct A_stm_* stm; struct A_exp_* exp; struct A_expList_* expList;};
    #define YYSTYPE union UNION
    #include <stdio.h>
    #include <stdlib.h>
    #include <string>
    #include <iostream>
    #include "lex.yy.c"
    using namespace std;
    //typedef char* YYSTYPE;
    
    typedef struct A_stm_* A_stm;
    typedef struct A_exp_* A_exp;
    typedef struct A_expList_* A_expList;
    
    int yyparse(void);
    int yyerror(string s)
    {
        cout << endl << "Error is " << s << endl;
        return 0;
    }
    
    struct A_stm_ {
        enum {
            A_compoundStm,
            A_assignStm,
            A_printStm
        } kind;
        
        union {
            struct {A_stm stm1,stm2;} compound;
            struct {char* id; A_exp exp;} assign;
            struct {A_expList exps; } print;
        } u;
    };
    
    A_stm A_CompoundStm (A_stm stm1,A_stm stm2) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_compoundStm;
        result -> u.compound.stm1 = stm1;
        result -> u.compound.stm2 = stm2;
        return result;
    }
    A_stm A_AssignStm (char* id, A_exp exp) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_assignStm;
        result -> u.assign.id = id;
        result -> u.assign.exp = exp;
        return result;
    }
    A_stm A_PrintStm (A_expList expList) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_printStm;
        result -> u.print.exps = expList;
        return result;
    }
    
    
    struct A_exp_ {
        enum {
            A_compoundExp,
            A_const,
            A_variable
        } kind;
        
        union uu{
            struct {A_exp exp1, exp2; int op;} compound;
            struct consts{char* value; enum Vkind{A_int, A_double, A_char } vkind;} _const;
            struct {char* id;} variable;
        } u;
    };
    A_exp A_IntExp (char* con) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_const;
        result -> u._const.value = con;
        result -> u._const.vkind = A_exp_::uu::consts::A_int;
        return result;
    }
    A_exp A_DoubleExp (char* con) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_const;
        result -> u._const.value = con;
        result -> u._const.vkind = A_exp_::uu::consts::A_double;
        return result;
    }
    A_exp A_CharExp (char* con) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_const;
        result -> u._const.value = con;
        result -> u._const.vkind = A_exp_::uu::consts::A_char;
        return result;
    }
    A_exp A_IdExp (char* id) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_variable;
        result -> u.variable.id = id;
        return result;
    }
    A_exp A_OpExp (A_exp exp1, int op, A_exp exp2) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_compoundExp;
        result -> u.compound.exp1 = exp1;
        result -> u.compound.exp2 = exp2;
        result -> u.compound.op = op;
        return result;
    }
    A_exp A_EseqExp (A_stm stm, A_exp exp) {
        return exp;
    }
    
    
    struct A_expList_ {
        A_exp exp;
        A_expList next;
    };
    A_expList A_ExpList (A_exp exp, A_expList explist) {
        A_expList result = (A_expList)malloc(sizeof(struct A_expList_));
        result -> exp = exp;
        result -> next = explist;
        return result;
    }
    
    
    
    int yywrap(void)
    {
        return 1;
    }
    
    int main()
    {
        
        FILE *fp = fopen("Test.txt", "r");
        if (fp == NULL) {
            printf("File not exist!");
            exit(0);
        }

        yyin = fp;
       
        yylex();
        yyparse();
        fclose(fp);

        return 0;
    }
%}

%union {int num; char* id; struct A_stm_* stm; struct A_exp_* exp; struct A_expList_* expList;}
%token
ASSIGN  LT      EQ      GT      IF      ELSE 	NUMBER 	PLUS 	MINUS 	TIMES 	DIVIDE
FOR 	WHILE 	LP      RP      LB      RB      LBB 	RBB     EQUAL
NEQUAL	SEMI    COMMA   PRINT   INT   DOUBLE    CHAR    END     BREAK
%token <id> ID INTIN DOUBLEIN CHARIN
%type <stm> stm prog
%type <exp> exp
%type <expList> exps
%start prog
%%
prog: stm {printf("Syntax tree created!\n");};
stm : LBB stm RBB {$$=$2;};
stm : stm SEMI stm {$$=A_CompoundStm($1,$3);};
stm : ID ASSIGN exp {$$=A_AssignStm($1,$3);};
stm : PRINT exps {$$=A_PrintStm($2);};
exps: exp {$$=A_ExpList($1,NULL);};
exps: exp COMMA exps {$$=A_ExpList($1,$3);};
exp : INTIN {$$=A_IntExp($1);};
exp : DOUBLEIN {$$=A_DoubleExp($1);};
exp : CHARIN {$$=A_CharExp($1);};
exp : ID {$$=A_IdExp($1);};
exp : exp PLUS exp {$$=A_OpExp($1,0,$3);};
exp : exp MINUS exp {$$=A_OpExp($1,1,$3);};
exp : exp TIMES exp {$$=A_OpExp($1,2,$3);};
exp : exp DIVIDE exp {$$=A_OpExp($1,3,$3);};
exp : stm COMMA exp {$$=A_EseqExp($1,$3);};
exp : LP exp RP {$$=$2;};


