#pragma once
class LoadingMenu
{
public:
	LoadingMenu();

	void loadingScreen(); //Teow Jirapa
	void welcomeMessage(); //Teow Jirapa
	void displayMenu(); //Kimberly
	void gotoxy(int x, int y); //http://www.cplusplus.com/forum/general/33846/
	void instructions();//Kimberly
	void credits(); //Darren 
	void displayScore(); //Sherwyn

private:
	int repeatBar;
	char progress;
};