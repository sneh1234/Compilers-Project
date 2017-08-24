%{
#include "AST.h"
#include<bits/stdc++.h>
using namespace std;
ofstream myFile, File;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
void yyerror(const char *s);
%}

//Datatype used in parser
%union
{
	int ival;
	char cval;
	char *strval;
	bool bval;
	
	ASTProgram *Program;
	ASTFieldDecl *FieldDecl;
	vector<ASTFieldDecl*> *FieldDecls;
	Datatype type;
	vector<idList *> * id_List;
	ASTParameter *Parameter;
	vector<ASTParameter *> *Parameters;
	ASTMethod *Method;
	vector<ASTMethod*> *Methods;
	Block *block;
	ASTDeclaration *Declaration;
	vector<ASTDeclaration*> *Declarations;
	vector<string > *variables;
}


// It will map terminal tokens with it's datatype
//Exported from Lexical Analyzer 
%token <ival> INT_LITERAL
%token <strval> STRING_LITERAL RELOP AND OR EQOP ID VOID CONT BREAK RETURN FOR IF ELSE ASSIGNOP ARITHOP BO BC 
%token <cval> CHAR_LITERAL
%token <bval> BOOL_LITERAL
%type <Program>  program
%type <FieldDecl> field_decl
%type <FieldDecls> field_decls
%type <type> type
%type <id_List> field_decl_mult field_decl_inner
%type <Parameter> parameter_decl;
%type <Parameters> parameter_decls;
%type <Method> method_decl
%type <Methods> method_decls
%type <block> block
%type <variables> var_decl_mult
%type <Declaration> var_decl
%type <Declarations> var_decls
//Terminal Token without mapprogramping with datatype
%token CALLOUT CLASS INT_DECLARATION BOOLEAN_DECLARATION



//Priority assigned to operator
//Priorities increases as going form top to down
%left OR
%left AND
%left EQOP
%left RELOP
%left '+' '-' 
%left '*' '/' '%'
%nonassoc '!'


//Priority for preventing shift and reduce conflict
%nonassoc "location_priority"
%nonassoc BO


//Priority for preventing reduce reuce conflict
%nonassoc "reduce1"
%nonassoc "reduce2"


//Terminal written in Uppercase character
//Non terminal present in Lowercase character
%% 

program: CLASS '{' field_decls method_decls '}'
	{
		$$ = new ASTProgram($3, $4);
	}
	|CLASS '{' field_decls'}'
	{
		$$ = new ASTProgram($3, NULL);
	};

field_decls: 
	field_decls field_decl { $1 -> push_back($2); $$ = $1; }
	| empty { $$ = new std::vector<ASTFieldDecl *>(); }
	;

field_decl: 
	type field_decl_mult ';' { $$ = new ASTFieldDecl($1, $2); } ;




field_decl_mult : 
	ID field_decl_inner { $2 -> push_back(new ASTVarIdentifier($1)); $$=$2;}
	| 
	ID '[' INT_LITERAL ']' field_decl_inner { $5 -> push_back(new ASTArrayIdentifier($1,$3)); $$=$5;}
	;

field_decl_inner : 
		{ $$ = new std::vector<idList*>();}
	| 
	',' ID field_decl_inner { $3 -> push_back(new ASTVarIdentifier($2)); $$=$3;}
	| 
	',' ID '[' INT_LITERAL ']' field_decl_inner { $6 -> push_back(new ASTArrayIdentifier($2,$4)); $$=$6;}
	;




type : 
	INT_DECLARATION
	{
		$$ = Datatype::int_type;
	}
	| BOOLEAN_DECLARATION 
	{
		$$ = Datatype::bool_type;
	}
	;

empty: ;

method_decls: 
	method_decls method_decl {$1->push_back($2); $$ = $1;}
	| method_decl {$$ = new vector<ASTMethod*> (); $$->push_back($1);}
	;

method_decl: 
	type ID BO parameter_decls  BC block { $$ = new ASTMethod($1, $2, $4);}
	| VOID ID BO parameter_decls BC block { $$ = new ASTMethod(Datatype::void_type, $2, $4);}
	;

parameter_decls: 
	parameter_decls ',' parameter_decl {$1->push_back($3); $$ = $1;}
	| parameter_decl {$$ = new vector<ASTParameter*> (); $$->push_back($1);}
	;

parameter_decl: 
	type ID {$$ = new ASTParameter($1, $2);}

block: 
	'{' var_decls statements '}' { $$ = new Block($2);}
	|'{' statements '}'{$$ = new Block(new vector<ASTDeclaration*> ());}
	|'{' var_decls '}'{$$ = new Block($2);}
	|'{''}' {$$ = new Block(new vector<ASTDeclaration*> ());}
	;

var_decls: 
	var_decls var_decl {$1->push_back($2);}
	| var_decl {$$ = new vector<ASTDeclaration*> (); $$->push_back($1);}
	;

	
var_decl: 
	type var_decl_mult ';' {$$ = new ASTDeclaration($1, $2);}
	;

var_decl_mult:
	var_decl_mult ',' ID {$1->push_back($3); $$ = $1;}
	| ID {$$ = new vector<string> (); $$->push_back($1);}
	;

statements : statements statement 
	| statement;


statement: location ASSIGNOP expr ';'
	{
		myFile << "ASSIGNMENT OPERATION ENCOUNTERED " << endl; 
	}
	| method_call ';'
	| IF BO expr BC block
	| IF BO expr BC block ELSE block
	| FOR ID ASSIGNOP expr ',' expr block
	| RETURN ';'
	| RETURN expr ';'
	| BREAK ';'
	| CONT ';'
	| block
	;

location: 
	ID %prec "location_priority"
	{
		myFile << "LOCATION ENCOUNTERED = " << $1 << endl; 
	}
	| ID '[' expr ']'
	{
		myFile << "LOCATION ENCOUNTERED = " << $1 << endl; 
	}
	;

expr: 
	location 					
	| literal
	|method_call									
	|arith_expr 	 						
	|rel_expr 					              
	|equal_expr 						       
	|condition_expr 					
	|'-' expr %prec "reduce1" 							
	|'!' expr 								
	|BO expr BC;
	;

arith_expr:					
	expr '*' expr
	{
		myFile << "MULTIPLICATION ENCOUNTERED " << endl;
	}								
	|expr '/' expr 
	{
		myFile << "DIVISION ENCOUNTERED " << endl;
	} 								
	|expr '+' expr 	
	{
		myFile << "ADDITION ENCOUNTERED" << endl;
	}							
	|expr '-' expr
	{
		myFile << "SUBTRACTION ENCOUNTERED " << endl;
	}								
	|expr '%' expr
	{
		myFile << "MOD ENCOUNTERED " << endl;
	}
	;							

rel_expr:					
	expr RELOP expr
	{
	    if($2[0] == '<' &&  $2[1] != '=')
	    	myFile << "LESS THAN ENCOUNTERED " << endl;
	    else if($2[0] == '>' &&  $2[1] != '=')
		myFile << "GREATER THAN ENCOUNTERED" << endl;
	}
 	;					

equal_expr:					
	expr EQOP expr;						

condition_expr:				
	expr AND expr 								
	|expr OR expr ;


method_call:
	ID BO exprs BC
	| CALLOUT BO STRING_LITERAL BC 
	{
		myFile << "CALLOUT TO " << $3 << " ENCOUNTERED  " << endl; 
	}
	| CALLOUT BO STRING_LITERAL ',' callout_args BC
	{
		myFile << "CALLOUT TO " << $3 << " ENCOUNTERED  "<< endl; 
	}
	;


exprs:
	exprs expr %prec "reduce2"
	| expr 	%prec "reduce2"
	;

callout_args:
	callout_args ',' callout_arg
	| callout_arg
	;

callout_arg:
	expr
	| STRING_LITERAL
	;


literal:
	INT_LITERAL
	{
		myFile << "INT ENCOUNTERED = " << $1 << endl; 

	}
	| CHAR_LITERAL
	{
		myFile << "CHAR ENCOUNTERED = " << $1 << endl; 
	}
	| BOOL_LITERAL
	{
		myFile << "BOOLEAN ENCOUNTERED = " << $1 << endl; 
	}
	;

%%


int main(int argc, char** argv) {

	
	char *file =  argv[1];
	myFile.open ("test_output");
	File.open("flex_output.txt");
	FILE *myfile = fopen(file, "r");

	// make sure it's valid:
	if (!myfile) {
		cout << "I can't open test_program!" << endl;
		return -1;
	}
		// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more
	do {
		yyparse();
	} while (!feof(yyin));

	cout << "Success" << endl;
}

//Error Handling
void yyerror(const char *s) {
	cout << "Syntax Error" << endl;
	//Exit as error is present
	exit(-1);
}
