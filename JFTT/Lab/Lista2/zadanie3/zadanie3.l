%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int keep_doxygen_comments = 0;
int last_emitted_char = 0;

static void emit_text(const char *s, int len) {
    for (int i = 0; i < len; ++i) {
        int c = (unsigned char)s[i];
        putchar(c);
        last_emitted_char = c;
    }
}

static int is_wordchar(int c) { return c && (isalnum(c) || c == '_'); }
%}

%x H_NAME
%x Q_H_NAME
%x ML_COMMENT
%x STRING
%x CHAR

%option noyywrap
%option yylineno

%%
<INITIAL>^[ \t]*#include[ \t]*<    { emit_text(yytext, yyleng); BEGIN(H_NAME); }
<H_NAME>[^>]+                      { emit_text(yytext, yyleng); }
<H_NAME>">"                        { emit_text(yytext, yyleng); BEGIN(INITIAL); }

<INITIAL>^[ \t]*#include[ \t]*\"   { emit_text(yytext, yyleng); BEGIN(Q_H_NAME); }
<Q_H_NAME>[^"]+                    { emit_text(yytext, yyleng); }
<Q_H_NAME>"\""                     { emit_text(yytext, yyleng); BEGIN(INITIAL); }

<INITIAL>"/**"                     { if (keep_doxygen_comments) emit_text(yytext, yyleng); BEGIN(ML_COMMENT); }
<INITIAL>"/*!"                     { if (keep_doxygen_comments) emit_text(yytext, yyleng); BEGIN(ML_COMMENT); }
<INITIAL>"/*"                      { BEGIN(ML_COMMENT); }

<ML_COMMENT>"*/"                    {
    if (keep_doxygen_comments) {
        emit_text(yytext, yyleng);
    } else {
        int c = yyinput();
        if (c != EOF) {
            if (is_wordchar(last_emitted_char) && is_wordchar(c)) {
                putchar(' ');
                last_emitted_char = ' ';
            }
            unput(c);
        }
    }
    BEGIN(INITIAL);
}
<ML_COMMENT>.|\n                    { if (keep_doxygen_comments) emit_text(yytext, yyleng); }

<INITIAL>"///".*                    { if (keep_doxygen_comments) emit_text(yytext, yyleng); }
<INITIAL>"//!".*                    { if (keep_doxygen_comments) emit_text(yytext, yyleng); }
<INITIAL>"//".*                     { }

<INITIAL>\"                        { emit_text(yytext, yyleng); BEGIN(STRING); }
<STRING>\\.?                       { emit_text(yytext, yyleng); }
<STRING>\"                         { emit_text(yytext, yyleng); BEGIN(INITIAL); }
<STRING>[^\\"]+                    { emit_text(yytext, yyleng); }

<INITIAL>\'                        { emit_text(yytext, yyleng); BEGIN(CHAR); }
<CHAR>\\.?                         { emit_text(yytext, yyleng); }
<CHAR>\'                           { emit_text(yytext, yyleng); BEGIN(INITIAL); }
<CHAR>[^\\']+                      { emit_text(yytext, yyleng); }

<INITIAL>\n                        { emit_text(yytext, yyleng); }
<INITIAL>.                         { emit_text(yytext, yyleng); }

%%

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Użycie: %s <sciezkadopliku> <flaga Y lub N>\n", argv[0]);
        return 1;
    }
    if (strcmp(argv[2], "Y") == 0 || strcmp(argv[2], "y") == 0) {
        keep_doxygen_comments = 1;
        fprintf(stderr, "[INFO] Komentarze dokumentacyjne Doxygen zostaną zachowane.\n");
    } else if (strcmp(argv[2], "N") == 0 || strcmp(argv[2], "n") == 0) {
        keep_doxygen_comments = 0;
        fprintf(stderr, "[INFO] Wszystkie komentarze zostaną usunięte.\n");
    } else {
        fprintf(stderr, "Błąd: Nieprawidłowa flaga. Użyj 'Y' lub 'N'.\n");
        return 1;
    }
    FILE *file = fopen(argv[1], "r");
    if (!file) { perror(argv[1]); return 1; }
    yyin = file;
    yylex();
    fclose(file);
    return 0;
}