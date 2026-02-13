%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%option yylineno

iden      [a-zA-Z][a-zA-Z0-9]*
symbol    [a-zA-Z0-9]
chain     \"[^\"]*\"

%%

[aA][uU][tT][oO][mM][aA][tT][eE]        { return AUTOMATE; }
[aA][lL][pP][hH][aA][bB][eE][tT]       { return ALPHABET; }
[eE][tT][aA][tT][sS]                    { return ETATS; }
[iI][nN][iI][tT][iI][aA][lL]           { return K_INITIAL; }
[fF][iI][nN][aA][uU][xX]               { return FINAUX; }
[tT][rR][aA][nN][sS][iI][tT][iI][oO][nN][sS]? { return TRANSITIONS; }
[vV][eE][rR][iI][fF][iI][eE][rR]       { return VERIFIER; }

"{"        { return ACC_OUV; }
"}"        { return ACC_FER; }
";"        { return PV; }
"="        { return EGAL; }
":"        { return DEUXP; }
"->"       { return FLECHE; }
","        { return VIRG; }

{symbol}   { yylval.str = strdup(yytext); return SYM; }
{iden}     { yylval.str = strdup(yytext); return ID; }
{chain}    { 
    // Remove quotes
    yylval.str = strdup(yytext + 1); 
    yylval.str[strlen(yylval.str)-1] = '\0';
    return CHAINE; 
}

[ \t\n\r]+ {  }
"#".*      {  }
.          { printf("CARACTERE INATTENDU : %s\n", yytext); }

%%

int yywrap() { return 1; }
