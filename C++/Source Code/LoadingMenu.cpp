#include "LoadingMenu.h"
#include "GameLogic.h"
#include <Windows.h>
#include <ctime>
#include <cstdlib>
#include <string>
#include <iostream>
#include <fstream>
#include <iomanip>
using namespace std;

LoadingMenu::LoadingMenu()
	:repeatBar(0), progress(255)
{
	displayMenu();
}

void LoadingMenu::gotoxy(int x, int y)
{
	COORD coord;
    coord.X = x; 
    coord.Y = y;
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
}

void LoadingMenu::loadingScreen()
{
	srand(time(0));
	string load;
	load = "Loading...";
	system("color 07");

	cout << left;
	cout << "\n\n\n\n\n\n\n\n\n\n\n\n\t\t\t\t\t\t"<< "      " << load << endl;        //Centralise the "Loading...";
	cout << "\t\t\t\t       ---------------------------------------" << endl;
	cout << "\t\t\t               -                                     -" << endl;
	cout << "\t\t\t\t       ---------------------------------------" << endl;
	cout << "\t\t\t\t\t"; //For 'progress bar' to sit perfectly;

	int randomNumber = rand()%(4-3+1)+3;

	gotoxy(40,14);
	for (int i = 0; i < 36; i++) //number of bars to display
	{
		cout << progress;
	    Sleep(50);		

		if (repeatBar < randomNumber)
		{
			if (i == 34)
			{
				i=0;
				cout << "\r";
				cout << "\t\t\t\t\t ";
				repeatBar++;
			}
		}
	}

	gotoxy(50,12);
	cout << "Loading Completed.";
	Sleep(2000);
	system("CLS");
}

void LoadingMenu::welcomeMessage()
{
	gotoxy(40,12);
	char smile=1;
	string message = "Welcome! Please select your choice";
	int len = message.length();

	for (int pos = 0; pos<len; pos++)
	{
		cout << message.substr(pos,1);
		Sleep(75);
	
	} 
}



void LoadingMenu::displayMenu()
{
	gotoxy(50,13);
	cout<<"(1)Start game"<<endl;
	gotoxy(50,14);
	cout<<"(2)Instructions"<<endl;
	gotoxy(50,15);
	cout<<"(3)Credits" <<endl;
	gotoxy(50,16);
	cout<<"(4)Highscores"<<endl;
	gotoxy(50,17);
	cout<<"(5)Exit"<<endl;
	gotoxy(58,17);
	int option;
	cin>>option;

	while (option>=6 || option<=0)
	{
		gotoxy(42,18);cout<<"Invalid input, please try again";
		gotoxy(76,12);
		cin>>option;
	}
	if (option==1)
	{
	}
	if (option==2)
	{
		system("CLS");
		instructions(); 
		system ("pause");
		system("CLS");
		displayMenu();
	}
	else if (option==3)
	{
		system("CLS");
		credits (); 
		system ("pause");
	}
	else if (option==4)
	{
		system("CLS");
		displayScore();
		system ("pause");
		system("CLS");
		displayMenu();

	}
		

	else if (option==5)
		exit(1);
}


void LoadingMenu::instructions()
	{
		cout<<"===============INSTRUCTIONS==============="<<endl;
		cout<<"Collect as many points as possible and set the highscore!"<<endl;
		cout<<"Answer all the questions and earn points."<<endl;
		cout<<""<<endl;
		cout<<"\n"; 
		cout<<"==================SYMBOLS================="<<endl;
		cout<<"'#' represents lava. Be careful not to touch it, or it will be game over!"<<endl;
		cout<<"'@' represents your character. Move it around!"<<endl;
		cout<<"'C' represents coins. Collect coins to earn score!"<<endl;
		cout<<"'.' represents the steps that you are allowed to move."<<endl;
		cout<<"'F' represents the finish line."<<endl;
		cout<<"'G' represents the mathematical questions."<<endl;
		cout<<"\n"; 
		cout<<"================HOW TO MOVE==============="<<endl;
		cout<<"Use the keyboard w to move one step upwards."<<endl;
		cout<<"Use the keyboard a to move one step left."<<endl;
		cout<<"Use the keyboard s to move one step down."<<endl;
		cout<<"Use the keyboard d to move one step right"<<endl;
	}

void LoadingMenu::credits()
	{
		gotoxy(56,9);
		cout<<"CREDITS"<<endl;
		gotoxy(49,10);
		cout<<"Singapore Polytechnic"<<endl;
		gotoxy(57,11);
		cout<<"Year 1"<<endl;
		gotoxy(54,12);
		cout<<"DCEP MAE 03"<<endl;
		gotoxy(54,13);
		cout<<"Teow Jirapa"<<endl;
		gotoxy(47,17);
		cout<<"--------------------------"<<endl;
		gotoxy(47,18);
	}

void LoadingMenu::displayScore()
{
	string name;
	int score;
	ifstream inFile;
	inFile.open("Score.txt");
	if (!inFile)
		cout<<"Unable to open file"<<endl;
	else
		cout<<left<<setw(25)<<"Name"<<"Score"<<endl;
	while (!inFile.eof())
	{
		inFile>>name>>score;
		if(inFile.fail())
			break;
		else
		{
			cout<<setw(25)<<name<<score<<endl;
		}

	}
	inFile.close();
}

