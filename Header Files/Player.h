#pragma once //declarations goes here
class Player
{
public:
	Player();

	void setPosition(int x, int y); //Teow Jirapa
	void getPosition(int &x, int &y); //Teow Jirapa. taking memory address of xy

private:
	//Position of player
	int _x;
    int _y;
};

