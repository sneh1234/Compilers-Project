/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_DECAF_TAB_H_INCLUDED
# define YY_YY_DECAF_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INT_LITERAL = 258,
    STRING_LITERAL = 259,
    RELOP = 260,
    AND = 261,
    OR = 262,
    EQOP = 263,
    ID = 264,
    VOID = 265,
    CONT = 266,
    BREAK = 267,
    RETURN = 268,
    FOR = 269,
    IF = 270,
    ELSE = 271,
    ASSIGNOP = 272,
    ARITHOP = 273,
    BO = 274,
    BC = 275,
    CHAR_LITERAL = 276,
    BOOL_LITERAL = 277,
    CALLOUT = 278,
    CLASS = 279,
    INT_DECLARATION = 280,
    BOOLEAN_DECLARATION = 281
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 16 "decaf.y" /* yacc.c:1909  */

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

#line 102 "decaf.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_DECAF_TAB_H_INCLUDED  */
