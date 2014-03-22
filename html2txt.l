%{
#include <stdio.h>
#include <string.h>
FILE *hyplink;
int lastchar; /* if last output char is newline */
%}
%x NONEED
%x FORM
%x LINK
%x SCPT
%x TAG
%x COMMENT
%%
("<"[sS][cC][rR][iI][pP][tT][^>]*">") 	 	BEGIN(SCPT);
"<"[sS][tT][yY][lL][eE][^>]*">" 		BEGIN(NONEED);
("<!--"[sS][cC][rR][iI][pP][tT][^>]*">") 	BEGIN(SCPT);
("<"[Ff][oO][rR][Mm][^>]*">") 			BEGIN(FORM);

<SCPT>("</"[sS][cC][rR][iI][pP][tT][^>]*">")  	BEGIN(INITIAL);
<SCPT>[.\n]
<NONEED>[.\n]
<NONEED>("</"[sS][tT][yY][lL][eE][^>]*">") 		BEGIN(INITIAL);
<FORM>[.\n]
<FORM>("</"[Ff][oO][rR][Mm][^>]*">") 			BEGIN(INITIAL);

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

