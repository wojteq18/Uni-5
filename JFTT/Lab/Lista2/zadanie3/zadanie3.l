%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

int yywrap();
int yylex();

bool print_doc = false;
extern FILE *yyin;
%}

/* Definicje stanów dla różnych kontekstów */
%x IN_STRING
%x LINE_COMMENT
%x BLOCK_COMMENT
%x DOC_BLOCK_COMMENT

%%

<INITIAL>{
    /* --- Komentarze Dokumentacyjne --- */

    "/**"|"/\\*!"                { if (print_doc) ECHO; BEGIN(DOC_BLOCK_COMMENT); }
    "///"|"//!"                  { if (print_doc) { yyless(1); /* Drukuj całą linię, łącznie z "//" */ ECHO; } else { BEGIN(LINE_COMMENT); } }

    /* --- Komentarze Standardowe --- */

    "//"                        BEGIN(LINE_COMMENT);
    "/*"                        BEGIN(BLOCK_COMMENT);

    /* --- Ciągi znaków (stringi) --- */
    
    \"                          { ECHO; BEGIN(IN_STRING); }

    /* --- Wszystko inne --- */
    
    .|\n                        ECHO;
}



<IN_STRING>{
    \"                          { ECHO; BEGIN(INITIAL); }
    "\\\""                      ECHO; /* Cudzysłów w stringu */
    "\\\\"                      ECHO; /* Podwójny backslash */
    "\\\n"                      ECHO; /* Kontynuacja stringu w nowej linii */
    .|\n                        ECHO;
}

<LINE_COMMENT>{
    "\\\n"                      /* Ignoruj kontynuację w nowej linii */
    \n                          { BEGIN(INITIAL); /* Koniec komentarza - drukuj nową linię */ printf("\n"); }
    .                           /* Ignoruj znaki w komentarzu */
}

<BLOCK_COMMENT>{
    "*/"                        BEGIN(INITIAL);
    .|\n                        /* Ignoruj wszystko wewnątrz */
}

<DOC_BLOCK_COMMENT>{
    "*/"                        { if (print_doc) ECHO; BEGIN(INITIAL); }
    .|\n                        { if (print_doc) ECHO; }
}

%%

int yywrap() {
    return 1;
}

int main(int argc, char *argv[]) {
    FILE *input_file = NULL;
    char *input_filename = NULL;

    if (argc <= 1) {
        fprintf(stderr, "Błąd: Nie podano pliku wejściowego.\n");
        fprintf(stderr, "Użycie: %s [--doc] <nazwa_pliku>\n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--doc") == 0 || strcmp(argv[i], "-d") == 0) {
            print_doc = true;
        } else {
            input_filename = argv[i];
        }
    }
    
    if (input_filename == NULL) {
        fprintf(stderr, "Błąd: Nie podano pliku wejściowego.\n");
        return 1;
    }

    input_file = fopen(input_filename, "r");
    if (input_file == NULL) {
        perror("Błąd otwarcia pliku");
        return 1;
    }
    
    yyin = input_file;

    yylex();

    fclose(input_file);

    return 0;
}