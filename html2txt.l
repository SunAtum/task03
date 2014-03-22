%{
#include <stdio.h>
#include <string.h>
FILE *hyplink;
int lastchar; /* if last output char is newline */
int deep=0;
%}
ntag ("<"[^(([sS][cC][rR][iI][pP][tT])|(!--[sS][cC][rR][iI][pP][tT])|([sS][tT][yY][lL][eE])|([Ff][oO][rR][Mm]))]*">")
ntage ("<"[^(([sS][cC][rR][iI][pP][tT])|(!--[sS][cC][rR][iI][pP][tT])|([sS][tT][yY][lL][eE])|([Ff][oO][rR][Mm]))">"]*"\>")

%x NONEED
%x FORM
%x LINK
%x SCPT
%x TAG
%x COMMENT
%x COMMENTLINE
%x COMMENTB
%%
("<"[sS][cC][rR][iI][pP][tT][^>]*">") 	 	BEGIN(SCPT);
("<"[sS][tT][yY][lL][eE][^>]*">") 		BEGIN(NONEED);
("<!--"[sS][cC][rR][iI][pP][tT][^>]*">") 	BEGIN(SCPT);
("<"[Ff][oO][rR][Mm][^>]*">") 			BEGIN(FORM);
("<--") BEGIN(COMMENT);
("-->") ;
("<"[^>]*"/">) ;
("<"[^/][^>]*) BEGIN(TAG);
("</"[^>]*) BEGIN(TAG); 
("//") BEGIN(COMMENTLINE);
("/*") BEGIN(COMMENTB);
("\r") ;
("&qot;") putchar('\'');
("&gt;") putchar('>');
("&lt;") putchar('<');
("&amp;") putchar('&');
("&nbsp;") putchar(' ');

<SCPT>("</"[sS][cC][rR][iI][pP][tT][^>]*">")  	BEGIN(INITIAL);
<SCPT>.|\n
<NONEED>.|\n
<NONEED>("</"[sS][tT][yY][lL][eE][^>]*">") 		BEGIN(INITIAL);
<FORM>.|\n
<FORM>("</"[Ff][oO][rR][Mm][^>]*">") 			BEGIN(INITIAL);
<TAG>">" BEGIN(INITIAL);
<COMMENTLINE>"\n" BEGIN(INITIAL);
<COMMENTB>("/"*("*"|[^*/]|[^*/]"/"*)*("*"|[^*/])) ;
<COMMENTB>"*/" BEGIN(INITIAL); 
<COMMENT>([\n\r]|([^-])|(-[^-])|(--[^>]))*
<COMMENT>"-->" BEGIN(INITIAL);
%%

int main(int  argc, char **argv )
{
  ++argv, --argc;
  if ( argc > 0 ) {
  if ((yyin = fopen( argv[0], "rb" )) == NULL) {
    printf("the file %s could'nt open!\n", argv[0]);
    exit (1);
    }
   }
 else
   yyin = stdin;
 if ((hyplink = fopen("hyplink.txt", "w")) == NULL) {
   printf("coud'nt create hyperlink file!\n");
   exit(1);
 }
 yylex();
 fclose(yyin);
 fclose(hyplink);
 return 0;
}

int yywrap()
{  
  return 1;
}

