#pragma once
#include <vector>
#include <string>
#include <iomanip>
#include "Player.h"

using namespace std;

class Mazes
{
public:
	Mazes();

	void load(string filename, Player &player); //Teow Jirapa
	void mazeLoader();                         
	void movePlayer(char input, Player &player); //Teow Jirapa

	void saveScore();
	//Getters, accessor
	char getTile(int x, int y); //Teow Jirapa
	//Setters, mutator
	void setTile(int x, int y, char tile);  //Teow Jirapa

private:
	vector <string> _mazeData;
	void processMovement(Player &player, int targetX, int targetY); //Teow Jirapa
};

