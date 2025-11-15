%{
#include <stdio.h>

int line_count = 0;      /* Ilość znalezionych lini */
int word_count = 0;      /* Ilość znalezionych słów */
int content_in_line = 0; /* Pomaga w identyfikacji pustych linii */
%}

/* Opcje dla Flex'a */
%option noyywrap
%option yylineno

%%
^[ \t]+                  { /* Ignoruj białe znaki na początku linii */ }

[ \t]+                  {
                            /* Zmień jeden lub więcej ciągów spacji i tabulatorów na jedną spację */
                            fputc(' ', yyout);
                            content_in_line = 1; /* Spacja to też "zawartość" */
                        }

[^ \t\n]+               {
                            /* Dopasuj słowo (ciąg znaków nie będących znakami białymi) */
                            word_count++;        /* Zwiększ licznik słów */
                            content_in_line = 1; /* Mamy treść w linii */
                            ECHO;                /* Wypisz dopasowane słowo */
                        }   
                        
\n                      {
                            /* Obsłuż koniec linii */
                            /* Jeśli w linii była jakakolwiek treść... */
                            if (content_in_line) {
                                line_count++;      /* Policz tę linię */
                                fputc('\n', yyout); /* i dodaj znak nowej linii. */
                            }
                            /* Niezależnie od wszystkiego, zresetuj flagę dla nowej linii. */
                            content_in_line = 0;
                        }
%%

int main(int argc, char *argv[]) {
    if (argc > 1) { 
        FILE *file = fopen(argv[1], "r"); 
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }

    yylex(); /* Uruchom analizę */

    if (content_in_line) {
        line_count++;
        fputc('\n', yyout); 
    }
    
    fprintf(stderr, "\n--------------------\n");
    fprintf(stderr, "Liczba linii: %d\n", line_count);
    fprintf(stderr, "Liczba słów: %d\n", word_count);

    return 0;
}