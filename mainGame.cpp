#include <iostream>
#include <string>
#include "GameLogic.h"
#include "LoadingMenu.h"

using namespace std;

int main()
{

	GameLogic gameLogic("Maze2.0.txt"); 
	gameLogic.playGame();

}