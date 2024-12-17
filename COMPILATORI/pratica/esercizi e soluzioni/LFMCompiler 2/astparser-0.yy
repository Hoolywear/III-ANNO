%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.2"
%defines

%define api.token.constructor
//%define api.location.file none
%define api.value.type variant
%define parse.assert
%define parse.trace
%define parse.error verbose

%code requires {
//# include <string>
//#include <exception>
}

//%locations

%define api.token.prefix {TOK_}
%token
  EOF  0  "end of file"
  COLON      ":"
  SEMICOLON  ";"
  COMMA      ","
  MINUS      "-"
  PLUS       "+"
  STAR       "*"
  SLASH      "/"
  MOD        "%"
  LPAREN     "("
  RPAREN     ")"
  ALT        "|"
  LE         "<="
  LT         "<"
  EQ         "=="
  NEQ        "<>"
  GE         ">="
  GT         ">"
  BIND       "="
  TRUE       "true"
  FALSE      "false"
  EXTERN     "external"
  DEF        "function"
  IF         "if"
  AND        "and"
  OR         "or"
  NOT        "not"
  LET        "let"
  IN         "in"
  END        "end"
;

%token <std::string> IDENTIFIER "id"
%token <int> NUMBER "number"
%%

%start startsymb;

startsymb:
  lfmprog               { };

lfmprog:
  deflist main          { };

deflist:
  def deflist           { }
| %empty                { };

def:
  extdef                { }
| funcdef               { };

extdef:
  "external" prototype  { };

funcdef:
  "function" prototype expr "end"  { };

prototype:
  "id" "(" params ")"   { };

params:
  %empty                { }
| "id" params           { };
 
main:
  expr                  { }
| %empty                { };

%nonassoc "<" "==" "<>" "<=" ">" ">=";
%left "+" "-";
%left "*" "/" "%";
%nonassoc UMINUS;
%left "or";
%left "and";
%nonassoc NEGATE;

expr:
  expr "+" expr          { }
| expr "-" expr          { }
| expr "*" expr          { }
| expr "/" expr          { }
| expr "%" expr          { }
| "-" expr %prec UMINUS  { }
| "(" expr ")"           { }
| "id"                   { }
| "id" "(" arglist ")"   { }
| "number"               { }
| condexpr               { }
| letexpr                { };
  
arglist: 
  %empty                 { }
| args                   { };

args:
  expr                   { }
| expr "," args          { };

condexpr:
 "if" pairs "end"        { };
 
pairs:
  pair                   { }
| pair ";" pairs           { };

pair: 
  boolexpr ":" expr      { };
  
boolexpr:
  boolexpr "and" boolexpr { }
| boolexpr "or" boolexpr  { }
| "not" boolexpr  %prec NEGATE { }
| literal                 { }
| relexpr                 { };

literal:
  "true"                  { }
| "false"                 { };

relexpr:
  expr "<"  expr          { }
| expr "==" expr          { }
| expr "<>" expr          { }
| expr "<=" expr          { }
| expr ">"  expr          { }
| expr ">=" expr          { }

letexpr: 
  "let" bindings "in" expr "end" {};

bindings:
  binding                 { }
| binding "," bindings    { };
  
binding:
  "id" "=" expr           { };
 
%%


