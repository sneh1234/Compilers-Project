#ifndef _AST_H
#define _AST_H

#include<bits/stdc++.h>
using namespace std;

class idList;
class ASTVarIdentifier;
class ASTArrayIdentifier;

enum class Datatype : char {
    int_type,
    bool_type,
    void_type
};

class ASTFieldDecl{
protected:
	Datatype type;
	vector<idList*> *idlist;

public: 
	ASTFieldDecl(Datatype type, vector<idList*> *idList){
		this->type = type;
		this->idlist = idList;
	};
};

class idList{

    public:
        bool isArray;
        int num_elements;
        string name;
};

class ASTVarIdentifier : public idList
{

public:
	ASTVarIdentifier(string IdName){
		this->name = IdName;
		isArray = false;
	};

};

class ASTArrayIdentifier : public idList
{
public:
	ASTArrayIdentifier(string IdName, int size){
		this->name = IdName;
		this->isArray = true;
		this->num_elements = size;
	};
};

class ASTDeclaration {
public:
	Datatype type;
	vector<string> *ids;
	ASTDeclaration(Datatype type, vector<string> *ids) {
		this->type = type;
		this->ids = ids;
	}
};

class ASTExpression {
public:
	ASTExpression();
};


class ASTLiteral : ASTExpression {
	public:
		ASTLiteral() {}
};

class ASTIntegerLiteral : ASTLiteral {
	public:
		int value;
		ASTIntegerLiteral(int value) {
			this->value = value;
		}
};

class ASTBooleanLiteral : ASTLiteral {
	public:
		bool value;
		ASTBooleanLiteral(bool value) {
			this->value = value;
		}
};

class ASTCharLiteral : ASTLiteral {
	public:
		char value;
		ASTCharLiteral(char value) {
			this->value = value;
		};
};

class ASTLocation : ASTExpression {
	public:
		string ID;
		ASTExpression *expr;
		ASTLocation(string ID, ASTExpression *expr) {
			this->ID = ID;
			this->expr = expr;
		}
};



class ASTStatement {
	public:
	ASTStatement(){}
};




class ASTAssignment : ASTStatement {
	public:

};


class Block {
public:
	vector<ASTDeclaration*> *var_decls;

	Block(vector<ASTDeclaration*> *var_decls) {
		this->var_decls = var_decls;
	}
};


class ASTParameter
{
	public:
		Datatype type;
		string name;
		ASTParameter(Datatype type, string name) {
			this->type = type;
			this->name = name;
		}
};


class ASTMethod 
{
	public:
		Datatype returnType;
		string functionName;
		vector <ASTParameter*> *parameters;
		ASTMethod(Datatype returnType, string functionName, vector<ASTParameter*> *parameters) {
			this->returnType = returnType;
			this->functionName = functionName;
			this->parameters = parameters;
		}
};


class ASTProgram {
protected:
	vector <ASTFieldDecl*> *field_decls;
 	vector <ASTMethod*> *method_decls;

public: 
	ASTProgram(vector <ASTFieldDecl*> *field_decls ,vector <ASTMethod*> *method_decls) {
		this->field_decls = field_decls;
		this->method_decls = method_decls;
	}

};





#endif
