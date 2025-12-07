/* calc.l */
%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"

void yyerror(const char *s);

/* Flaga kontekstu: 1 jeśli spodziewamy się operanda (liczby), 0 jeśli operatora */
int expect_operand = 1;

/* Stała P do przeliczania ujemnych liczb bezpośrednio w lekserze */
#define P 1234577
%}

%%

^#.* { /* Ignoruj komentarze */ }
\\\n            { /* Ignoruj sklejanie linii */ }
[ \t]           { /* Ignoruj białe znaki */ }

\-[0-9]+        {
                    /* Specjalna obsługa minusa przy liczbie */
                    if (expect_operand) {
                        /* Kontekst unarny (np. na początku, po operatorze) -> To jest liczba ujemna */
                        long long val = atoll(yytext);
                        /* Normalizacja w miejscu */
                        val = val % P;
                        if (val < 0) val += P;
                        
                        yylval = val;
                        expect_operand = 0; /* Po liczbie spodziewamy się operatora */
                        return NUM;
                    } else {
                        /* Kontekst binarny (np. po liczbie "2-3") -> To jest operator MINUS */
                        /* Cofamy wczytanie cyfr, zwracamy tylko minus */
                        yyless(1); 
                        expect_operand = 1; /* Po operatorze spodziewamy się liczby */
                        return MINUS;
                    }
                }

[0-9]+          {
                    yylval = atoll(yytext);
                    expect_operand = 0; /* Po liczbie spodziewamy się operatora */
                    return NUM;
                }

\+              { expect_operand = 1; return PLUS; }
\-              { expect_operand = 1; return MINUS; }
\* { expect_operand = 1; return MUL; }
\/              { expect_operand = 1; return DIV; }
\^              { expect_operand = 1; return POW; }
\(              { expect_operand = 1; return LPAREN; }
\)              { expect_operand = 0; return RPAREN; } /* Po nawiasie zamykającym jest jak po liczbie */
\n              { expect_operand = 1; return EOL; } /* Nowa linia resetuje oczekiwanie */

.               { yyerror("Nieznany znak"); }

%%