#include <iostream>
#include <conio.h>
#include "GameLogic.h"
#include "Mazes.h"

GameLogic::GameLogic(string filename)
{
	//_loadmenu.loadingScreen();
	//_loadmenu.welcomeMessage();
	_maze.load(filename, _player);   
}  


void GameLogic::playGame()
{
	bool gameisDone = false;

	while (gameisDone == false)
	{
		_maze.mazeLoader();
		playerMovement();
	}
} //loops game 






void GameLogic::playerMovement()
{
	printf("\nEnter (w/s/a/d) to move your player '@': ");
	char input = _getch(); //get character, returns immediately
    _maze.movePlayer(input, _player);
}
