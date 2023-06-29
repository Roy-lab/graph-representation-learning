#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <string>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
using namespace std;

vector<string> methods;
typedef map<int,double> DBLMAP;
typedef map<int,double>::iterator DBLMAP_ITER;

typedef map<string,DBLMAP*>  SCORESET;
typedef map<string,DBLMAP*>::iterator  SCORESET_ITER;

map<string,SCORESET*> scores;

int populateMethods(char*);
int populateScores(char*);
int readScores(const char*);
int writeOutScores(const char*);

int main(int argc, const char** argv)
{
	if(argc!=3)
	{
		cout <<"Usage: convert scores outputfile " << endl;
		return 0;
	}
	readScores(argv[1]);
	writeOutScores(argv[2]);
	return 0;
}


int
populateMethods(char* buffer)
{
	char* tok=strtok(buffer,"\t");
	int tokCnt=0;
	while(tok!=NULL)
	{
		if(tokCnt>1)
		{
			string methodName(tok);
			methods.push_back(tok);
		}
		tok=strtok(NULL,"\t");
		tokCnt++;
	}
	return 0;
}

int 
populateScores(char* buffer)
{
	char* tok=strtok(buffer,"\t");
	int tokCnt=0;
	string cellline;
	int cid=-1;
	while(tok!=NULL)
	{
		if(tokCnt==0)
		{
			cellline.append(tok);
		}
		else if(tokCnt==1)
		{
			cid=atoi(tok);
		}
		else if(tokCnt>1)
		{
			string& method=methods[tokCnt-2];
			double score=atof(tok);
			SCORESET* methodscore=NULL;
			DBLMAP* scoreforcids=NULL;
			if(scores.find(method)==scores.end())
			{
				methodscore=new SCORESET;
				scores[method]=methodscore;
			}
			else
			{
				methodscore=scores[method];
			}
			if(methodscore->find(cellline)==methodscore->end())
			{
				scoreforcids=new DBLMAP;
				(*methodscore)[cellline]=scoreforcids;
			}	
			else
			{
				scoreforcids=(*methodscore)[cellline];
			}
			(*scoreforcids)[cid]=score;
			
		}
		tokCnt++;
		tok=strtok(NULL,"\t");
	}

	return 0;
}

int 
writeOutScores(const char* outFName)
{
	ofstream oFile(outFName);
	oFile<<"Method\tCID\tCellline\tScore"<< endl;
	//scores stores the results by method->celline->cid
	for(map<string,SCORESET*>::iterator aIter=scores.begin();aIter!=scores.end();aIter++)
	{
		SCORESET* ss=aIter->second;
		for(SCORESET_ITER sIter=ss->begin();sIter!=ss->end();sIter++)	
		{
			DBLMAP* scorepercid=sIter->second;
			for(DBLMAP_ITER dIter=scorepercid->begin();dIter!=scorepercid->end();dIter++)
			{
				oFile<< aIter->first.c_str() << "\t"<< dIter->first << "\t" << sIter->first << "\t"<< dIter->second << endl;
			}
		}
	}
	
	oFile.close();
	return 0;

}

int
readScores(const char* aFName)
{
	ifstream inFile(aFName);
	char buffer[8196];
	int lineCnt=0;
	while(inFile.good())
	{
		inFile.getline(buffer,8195);
		if(strlen(buffer)<=0)
		{
			continue;
		}
		if(lineCnt==0)
		{
			populateMethods(buffer);

		}
		else
		{
			if(strstr(buffer,"cluster_num")!=NULL)
			{
				lineCnt++;
				continue;
			}
			populateScores(buffer);
		}
		lineCnt++;
	}
	inFile.close();
	return 0;
}
