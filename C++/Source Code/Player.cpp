#include "Player.h"
//function definitions

Player::Player()
:_x(0), _y(0)
{}

void Player::setPosition(int x, int y) 
{
	_x = x;
	_y = y;
}

void Player::getPosition(int &x, int &y)
{
	x = _x;
	y = _y;
}

