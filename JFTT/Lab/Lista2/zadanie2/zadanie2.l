%{

%}

/* Definicja stanów startowych dla komentarzy wieloliniowych */
%x DQ_COMMENT
%x SQ_COMMENT

%option noyywrap 
%option yylineno 

%%
<INITIAL>"\"\"\""          { BEGIN(DQ_COMMENT); /* Rozpocznij komentarz potrójnego cudzysłowu */ }
<DQ_COMMENT>"\"\"\""        { BEGIN(INITIAL);    /* Zakończ komentarz */ }
<DQ_COMMENT>.|\n          { /* Ignoruj wszystkie znaki wewnątrz komentarza */ }

<INITIAL>"'''"            { BEGIN(SQ_COMMENT); /* Rozpocznij komentarz potrójnego apostrofu */ }
<SQ_COMMENT>"'''"          { BEGIN(INITIAL);    /* Zakończ komentarz */ }
<SQ_COMMENT>.|\n            { /* Ignoruj wszystkie znaki wewnątrz komentarza */ }

<INITIAL>"#".*           { /* Ignoruj komentarze jednoliniowe (do końca linii) */ }

<INITIAL>\n               { ECHO; /* Zachowaj znaki nowej linii dla struktury kodu */ }
<INITIAL>.                { ECHO; /* Drukuj wszystkie inne znaki */ }

%%

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        /* Ustaw yyin (wejście dla Flexa) na ten plik */
        yyin = file;
    }

    /* Uruchom analizę leksykalną */
    yylex();

    return 0;
}