#pragma once
class LoadingMenu
{
public:
	LoadingMenu();

	void loadingScreen(); //Teow Jirapa
	void welcomeMessage(); //Teow Jirapa
	void displayMenu(); 
	void gotoxy(int x, int y); //http://www.cplusplus.com/forum/general/33846/
	void instructions();
	void credits(); 
	void displayScore();

private:
	int repeatBar;
	char progress;
};
