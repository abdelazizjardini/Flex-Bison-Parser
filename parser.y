%{
#include <stdio.h>
#include <stdlib.h>
#include "semantics/ast.h"
#include "semantics/semantic.h"

extern int yylineno;
extern char *yytext;
int yylex(void);
void yyerror(const char *s);
AST *root = NULL;
%}

%union {
    char *str;
    struct AST *ast;
}

%token AUTOMATE ALPHABET ETATS K_INITIAL FINAUX TRANSITIONS VERIFIER
%token ACC_OUV ACC_FER PV EGAL DEUXP FLECHE VIRG
%token <str> ID SYM CHAINE

%type <ast> programme sections section liste_symboles liste_etats liste_transitions transition commands command

%%

programme:
      AUTOMATE ID ACC_OUV sections ACC_FER commands {
          root = nvNoeud(AST_PROGRAMME, $4, NULL);
          root->nom = $2;
          
          if (verifierSemantique(root)) {
              AST *cmd = $6;
              while (cmd) {
                  if (cmd->type == AST_COMMAND) {
                       AST *wordNode = cmd->droite;
                       if (wordNode && wordNode->nom) {
                           executerAutomate(root, wordNode->nom);
                       }
                  }
                  cmd = cmd->suivant;
              }
          }
      }
    ;

commands:
      /* empty */ { $$ = NULL; }
    | commands command { 
         if ($1 == NULL) {
             $$ = $2;
         } else {
             $$ = $1;
             ajouterSuivant($$, $2);
         }
      }
    ;

command:
      VERIFIER ID CHAINE PV {
           // Create a command node. 
           // Left = ID (automaton name), Right = CHAINE (word)
           // We can reuse nvNoeud.
           // ID is $2 (string), CHAINE is $3 (string).
           // Need to wrap them in AST nodes? Or just use 'nom' for one?
           // Let's wrap: Left=ID node, Right=CHAINE node.
           AST *idNode = nvFeuille(AST_ID, $2);
           AST *wordNode = nvFeuille(AST_CHAINE, $3);
           $$ = nvNoeud(AST_COMMAND, idNode, wordNode);
      }
    ;

sections:
      section { $$ = $1; }
    | sections section {
          $$ = $1;
          ajouterSuivant($$, $2);
    }
    ;

section:
      ALPHABET EGAL ACC_OUV liste_symboles ACC_FER PV { $$ = nvNoeud(AST_ALPHABET, $4, NULL); }
    | ETATS EGAL ACC_OUV liste_etats ACC_FER PV { $$ = nvNoeud(AST_ETATS, $4, NULL); }
    | K_INITIAL EGAL ID PV { $$ = nvFeuille(AST_INITIAL, $3); }
    | FINAUX EGAL ACC_OUV liste_etats ACC_FER PV { $$ = nvNoeud(AST_FINAUX, $4, NULL); }
    | TRANSITIONS EGAL ACC_OUV liste_transitions ACC_FER PV { $$ = nvNoeud(AST_TRANSITION, $4, NULL); }
    ;

liste_symboles:
      SYM { $$ = nvFeuille(AST_SYMBOLE, $1); }
    | SYM VIRG liste_symboles {
         $$ = nvFeuille(AST_SYMBOLE, $1);
         $$->suivant = $3;
    }
    ;

liste_etats:
      ID { $$ = nvFeuille(AST_ID, $1); }
    | ID VIRG liste_etats {
          $$ = nvFeuille(AST_ID, $1);
          $$->suivant = $3;
    }
    ;


liste_transitions:
      transition { $$ = $1; }
    | transition liste_transitions {
         $$ = $1;
         $$->suivant = $2;
    }
    ;

transition:
      liste_etats DEUXP SYM FLECHE ID PV {
           $$ = nvNoeud(AST_TRANSITION, $1, nvFeuille(AST_ID, $5));
           $$->nom = $3; 
      }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur syntaxique ligne %d près de '%s' : %s\n", yylineno, yytext, s);
}

int main(int argc, char **argv) {
    printf("[INFO] Ameliorations Flex/Parser chargees.\n");
    return yyparse();
}
