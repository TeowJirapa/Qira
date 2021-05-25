#pragma once 
#include "Mazes.h"
#include "LoadingMenu.h"
#include <string>  
using namespace std;


class GameLogic
{
public:
	GameLogic(string filename);   
	void playGame();            //Teow Jirapa
	void playerMovement();      //Teow Jirapa
	void saveScore(); //________  save to textfile called highScores.txt
	void displayHighscore(); //____________ read in from highScores.txt

private:
	Mazes _maze;
	Player _player;
	LoadingMenu _loadmenu;
};

