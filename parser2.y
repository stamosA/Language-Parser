
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

FILE *yyin;
void yyerror(const char *s);
int yylex();
extern char* yytext();
extern int yylineno;

int err=0;
%}

%locations
%token IMPORT
%token PRINT
%token IF
%token ELSE
%token ELIF
%token IN
%token NOT
%token FOR
%token RANGE
%token NEWLINE
%token DEF
%token CLASS
%token RETURN 
%token IDENTIFIER
%token TEXT
%token NUMBER
%token FLOAT
%token STRING
%token AND
%token OR
%token NE
%token EQ
%token GE
%token LE
%token PEQ
%token SEQ
%token MEQ
%token DEQ
%token LAMBDA
%token BOOLEAN
%token FROM
%token TAB
%token FLOOR_DIV
%token POWER

%%

program: single_input
		| program single_input;

single_input:	NEWLINE 
		| import_cmd  
		| classes 
		| defs  
		|  print_cmd 
		| if 
		| elif
		| else
		| func_call
		| for 
		| assigns 
		| returns ;

import_cmd: 	FROM IDENTIFIER IMPORT text_more
				|IMPORT text_more ;

text_more: 	IDENTIFIER 
		| IDENTIFIER ',' text_more;

print_cmd: 	 PRINT '(' kati ')' 
			| PRINT '(' list_loop ')' 
			| PRINT '(' IDENTIFIER '(' kati ')' ')'
			| PRINT '(' dicts ')' 
			| PRINT '(' types '+' types ')'
			| PRINT '(' list_loop ',' kati ')';

list_loop: list
			| list logic_ops list_loop;

kati:       types
            | types ',' kati;

assigns: 	IDENTIFIER ass_symb expr
		| IDENTIFIER '=' lambda
		| IDENTIFIER ass_symb setdef;
		
ass_symb:     '='
            | PEQ 
		    | MEQ 
		    | SEQ 
		    | DEQ;

expr: 		types 
		| list 
		| dicts 
		| expr operator types 
		| '(' expr ')' ;
		

types: 		STRING 
		| IDENTIFIER 
		| NUMBER 
		| FLOAT 
		| BOOLEAN  ;

operator: 	'+' 
		| '-' 
		| '*' 
		| '/' 
		| FLOOR_DIV
		| POWER
		| '%';

classes: 	CLASS IDENTIFIER ':' NEWLINE single_input;

if:		 IF '(' cond ')' ':'
		|IF cond ':';

else:  ELSE ':';

elif: 	ELIF cond ':'
		|ELIF '(' cond ')' ':';

cond: 	  types
		| list_loop
		| types logic_ops cond
		| types NOT IN list
		| types IN list;

defs:  	DEF IDENTIFIER '(' ')' ':' NEWLINE single_input
		| DEF IDENTIFIER '(' text_more ')' ':' NEWLINE single_input;

func_call:    IDENTIFIER '(' ')'
			| IDENTIFIER '(' kati ')';

for: 	 FOR IDENTIFIER IN RANGE '(' for_range ')' ':' NEWLINE single_input
		|FOR IDENTIFIER IN IDENTIFIER ':' NEWLINE single_input 
		|FOR IDENTIFIER IN STRING ':' NEWLINE single_input
		|FOR IDENTIFIER IN list ':' NEWLINE single_input;

for_range:   NUMBER
			|NUMBER ',' NUMBER
			|NUMBER ',' NUMBER ',' NUMBER;

returns:  	RETURN expr;

lambda:		LAMBDA text_more ':' expr;

list: 		'[' kati ']';

dicts: 		'{' vals '}';

vals:		types ':'  types 
		| types ':' list
		| types ':' list ',' vals
		|  types ':'  types ','  vals;

logic_ops:  '>' 
		| '<' 
		| NE 
		| EQ 
		| GE
		| AND
		| OR
		| LE ;

setdef:  IDENTIFIER '(' ')'
		| IDENTIFIER '(' kati ')';



%% 

void yyerror(const char *str)
{
	fprintf(stderr,"Error | Line: %d\n%s\n",yylineno,str);
	err++;
}

int main(int argc, char* argv[]) {
	FILE *f;
	if (argc>1)
	{
		f = fopen(argv[1], "r");
		if (!f) {
			printf("Error file %s \n",argv[1]);
			exit(1);
		}
		yyin = f;

	}
    yyparse();
	if (err==0) 
    {
        printf("--------------------\n");
		printf(" No syntax errors ""\n");
		printf("--------------------");	
    }
}



