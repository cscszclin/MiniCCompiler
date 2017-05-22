%{
    union UNION {int num; char* id; struct A_stm_* stm; struct A_exp_* exp; struct A_expList_* expList; struct A_fun_* fun;};
    #define YYSTYPE union UNION
    #include <stdio.h>
    #include <stdlib.h>
    #include <string>
    #include <iostream>
    #include "lex.yy.c"
    using namespace std;
    //typedef char* YYSTYPE;
    typedef struct A_fun_* A_fun;
    typedef struct A_stm_* A_stm;
    typedef struct A_exp_* A_exp;
    typedef struct A_expList_* A_expList;

    int yyparse(void);
    int yyerror(string s)
    {
        cout << endl << "Error is " << s << endl;
        cout << "Error position is here:" << yytext << " at line " << linenumber << endl;
        return 0;
    }
    
    struct A_fun_ {
        enum {
            A_compoundFun,
            A_singleFun
        } kind;
        union {
            struct {A_fun fun1, fun2;} compound;
            struct {int type; char* id; A_stm stm1, stm2;} single;
        } u;
    };
    A_fun A_CompoundFun (A_fun fun1, A_fun fun2) {
        A_fun result = (A_fun)malloc(sizeof(struct A_fun_));
        result -> kind = A_fun_::A_compoundFun;
        result -> u.compound.fun1 = fun1;
        result -> u.compound.fun2 = fun2;
        return result;
    }
    A_fun A_SingleFun (int type, char* id, A_stm stm1, A_stm stm2) {
        A_fun result = (A_fun)malloc(sizeof(struct A_fun_));
        result -> kind = A_fun_::A_singleFun;
        result -> u.single.type = type;
        result -> u.single.id = (char*)malloc((strlen(id) + 1) * sizeof(char));
        strcpy (result -> u.single.id, id);
        printf("%s\n", result -> u.single.id);
        result -> u.single.stm1 = stm1;
        result -> u.single.stm2 = stm2;
        return result;
    }

    struct A_stm_ {
        enum {
            A_compoundStm,
            A_assignStm,
            A_printStm,
            A_returnStm, 
            A_ifStm,
            A_whileStm,
            A_forStm,
            A_defineStm,
        } kind;
        
        union {
            struct {A_stm stm1,stm2;} compound;
            struct {char* id; A_exp exp;} assign;
            struct {A_expList exps;} print;
            struct {A_expList expList;} _return;
            struct {A_exp exp; A_stm stm1, stm2;} _if;
            struct {A_exp exp; A_stm stm;} _while;
            struct {A_exp exp; A_stm stm1, stm2, stm3;} _for;
            struct {int type; A_expList expList;} _define;

        } u;
    };
    
    A_stm A_CompoundStm (A_stm stm1, A_stm stm2) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_compoundStm;
        result -> u.compound.stm1 = stm1;
        result -> u.compound.stm2 = stm2;
        return result;
    }
    A_stm A_AssignStm (char* id, A_exp exp) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_assignStm;
        result -> u.assign.id = (char*)malloc((strlen(id) + 1) * sizeof(char));
        strcpy (result -> u.assign.id, id);
        result -> u.assign.exp = exp;
        return result;
    }
    A_stm A_PrintStm (A_expList expList) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_printStm;
        result -> u.print.exps = expList;
        return result;
    }
    A_stm A_ReturnStm (A_expList expList) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_returnStm;
        result -> u._return.expList = expList;
        return result;
    }
    A_stm A_IfStm (A_exp exp, A_stm stm1, A_stm stm2) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_ifStm;
        result -> u._if.exp = exp;
        result -> u._if.stm1 = stm1;
        result -> u._if.stm2 = stm2;
        return result;
    }
    A_stm A_WhileStm (A_exp exp, A_stm stm) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_whileStm;
        result -> u._while.exp = exp;
        result -> u._while.stm = stm;
        return result;
    }
    A_stm A_ForStm (A_stm stm1, A_exp exp, A_stm stm2, A_stm stm3) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_forStm;
        result -> u._for.exp = exp;
        result -> u._for.stm1 = stm1;
        result -> u._for.stm2 = stm2;
        result -> u._for.stm3 = stm3;
        return result;
    }
    A_stm A_DefineStm (int type, A_expList expList) {
        A_stm result = (A_stm)malloc(sizeof(struct A_stm_));
        result -> kind = A_stm_::A_defineStm;
        result -> u._define.type = type;
        result -> u._define.expList = expList;
        return result;
    }
    

    struct A_exp_ {
        enum {
            A_compoundExp,
            A_const,
            A_variable,
            A_arrayVar,
            A_call
        } kind;
        
        union uu{
            struct {A_exp exp1, exp2; int op;} compound;
            struct consts{char* value; enum Vkind{A_int, A_double, A_char } vkind;} _const;
            struct {char* id;} variable;
            struct {A_exp exp; char* id;} assign;
            struct {char* id; char* num;} _array;
            struct {char* id; A_expList expList;} call;
        } u;
    };
    A_exp A_IntExp (char* con) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_const;
        result -> u._const.value = (char*)malloc((strlen(con) + 1) * sizeof(char));
        strcpy (result -> u._const.value, con);
        result -> u._const.vkind = A_exp_::uu::consts::A_int;
        return result;
    }
    A_exp A_DoubleExp (char* con) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_const;
        result -> u._const.value = (char*)malloc((strlen(con) + 1) * sizeof(char));
        strcpy (result -> u._const.value, con);
        result -> u._const.vkind = A_exp_::uu::consts::A_double;
        return result;
    }
    A_exp A_CharExp (char* con) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_const;
        result -> u._const.value = (char*)malloc((strlen(con) + 1) * sizeof(char));
        strcpy (result -> u._const.value, con);
        result -> u._const.vkind = A_exp_::uu::consts::A_char;
        return result;
    }
    A_exp A_IdExp (char* id) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_variable;
        result -> u.variable.id = (char*)malloc((strlen(id) + 1) * sizeof(char));
        strcpy (result -> u.variable.id, id);
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
    A_exp A_ArrayExp (char* id, char* num) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_arrayVar;
        result -> u._array.id = (char*)malloc((strlen(id) + 1) * sizeof(char));
        strcpy (result -> u._array.id, id);
        result -> u._array.num = num;
        return result;
    }
    A_exp A_CallExp (char* id, A_expList expList) {
        A_exp result = (A_exp)malloc(sizeof(struct A_exp_));
        result -> kind = A_exp_::A_call;
        result -> u.call.id = (char*)malloc((strlen(id) + 1) * sizeof(char));
        strcpy (result -> u.call.id, id);
        result -> u.call.expList = expList;
        return result;
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

%union {int num; char* id; struct A_stm_* stm; struct A_exp_* exp; struct A_expList_* expList; struct A_fun_* fun;}
%token
ASSIGN  LT      EQ      GT      LE      GE      NE      IF      ELSE 	NUMBER 	PLUS 	MINUS 	TIMES 	DIVIDE
FOR 	WHILE 	LP      RP      LB      RB      LBB 	RBB     EQUAL   HEAD    VOID   
SEMI    COMMA   PRINT   INT     DOUBLE  CHAR    END     BREAK   RETURN  DPLUS   DMINUS
%token <id> ID INTIN DOUBLEIN CHARIN 
%type <stm> stm para
%type <exp> exp exp1 exp2 exp3
%type <expList> exps
%type <fun> fun prog
%start prog
%%
prog: fun {printf("Syntax tree created!\n");};
fun : fun fun {$$=A_CompoundFun($1,$2);};

fun : INT ID LP para RP LBB stm RBB {$$=A_SingleFun(0,$2,$4,$7);}
    | DOUBLE ID LP para RP LBB stm RBB {$$=A_SingleFun(1,$2,$4,$7);}
    | CHAR ID LP para RP LBB stm RBB {$$=A_SingleFun(2,$2,$4,$7);}
    | VOID ID LP para RP LBB stm RBB {$$=A_SingleFun(3,$2,$4,$7);}
    | INT ID LP RP LBB stm RBB {$$=A_SingleFun(0,$2,NULL,$6);}
    | DOUBLE ID LP RP LBB stm RBB {$$=A_SingleFun(1,$2,NULL,$6);}
    | CHAR ID LP RP LBB stm RBB {$$=A_SingleFun(2,$2,NULL,$6);};
    | VOID ID LP RP LBB stm RBB {$$=A_SingleFun(3,$2,NULL,$6);};

para: para COMMA para {$$=A_CompoundStm($1,$3);}
    | INT exp {A_expList explist=A_ExpList($2,NULL); $$=A_DefineStm(0,explist);}
    | DOUBLE exp {A_expList explist=A_ExpList($2,NULL); $$=A_DefineStm(1,explist);}
    | CHAR exp {A_expList explist=A_ExpList($2,NULL); $$=A_DefineStm(2,explist);};

stm : LBB stm RBB {$$=$2;};
stm : stm SEMI stm {$$=A_CompoundStm($1,$3);}
    | stm stm {$$=A_CompoundStm($1,$2);};
stm : ID ASSIGN exp {$$=A_AssignStm($1,$3);};
stm : PRINT exps{$$=A_PrintStm($2);};
stm : RETURN exps {$$=A_ReturnStm($2);};
exp : ID LP exps RP {$$=A_CallExp($1,$3);}
    | ID LP RP {$$=A_CallExp($1,NULL);};


stm : IF LP exp RP LBB stm RBB {$$=A_IfStm($3,$6,NULL);}
    | IF LP exp RP LBB stm RBB ELSE LBB stm RBB {$$=A_IfStm($3,$6,$10);};
stm : WHILE LP exp RP LBB stm RBB {$$=A_WhileStm($3,$6);};
stm : FOR LP stm SEMI exp SEMI stm RP LBB stm RBB {$$=A_ForStm($3,$5,$7,$10);};

stm : INT exps {$$=A_DefineStm(0,$2);};
stm : DOUBLE exps {$$=A_DefineStm(1,$2);};
stm : CHAR exps {$$=A_DefineStm(2,$2);};
stm : SEMI {$$=NULL;};

exps: exp {$$=A_ExpList($1,NULL);};
exps: exp COMMA exps {$$=A_ExpList($1,$3);};

exp1 : INTIN {$$=A_IntExp($1);};
exp1 : DOUBLEIN {$$=A_DoubleExp($1);};
exp1 : CHARIN {$$=A_CharExp($1);};
exp1 : ID {$$=A_IdExp($1);}
     | ID LB INTIN RB {$$=A_ArrayExp($1,$3);};
exp2 : exp2 PLUS exp2 {$$=A_OpExp($1,0,$3);};
exp2 : exp2 MINUS exp2 {$$=A_OpExp($1,1,$3);};
exp1 : exp1 TIMES exp1 {$$=A_OpExp($1,2,$3);};
exp1 : exp1 DIVIDE exp1 {$$=A_OpExp($1,3,$3);};
exp3 : exp3 EQ exp3 {$$=A_OpExp($1,4,$3);};
exp3 : exp3 NE exp3 {$$=A_OpExp($1,5,$3);};
exp3 : exp3 GT exp3 {$$=A_OpExp($1,6,$3);};
exp3 : exp3 LT exp3 {$$=A_OpExp($1,7,$3);};
exp3 : exp3 GE exp3 {$$=A_OpExp($1,8,$3);};
exp3 : exp3 LE exp3 {$$=A_OpExp($1,9,$3);};
exp  : stm COMMA exp {$$=A_EseqExp($1,$3);};
exp1 : LP exp RP {$$=$2;};
exp2 : exp1 {$$=$1;};
exp3 : exp2 {$$=$1;};
exp  : exp3 {$$=$1;};

