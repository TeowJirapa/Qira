#include "Mazes.h"

#include <fstream> 
#include <iostream>
#include <Windows.h>
#include <ctime>
#include <cstdlib>
#include <conio.h>
#include <iomanip>

using namespace std;

int score = 0;

Mazes::Mazes()
{	
}

//Opens file
void Mazes::load(string filename, Player &player)
{
	//Loads level

	ifstream inFile;
	inFile.open(filename);

	if(inFile.fail())
	{
		perror ("The following error has occured");
		cout << "Please ensure that there is a textfile named \"" << filename << "\" located in the same directory." << endl;
		Sleep(7000);
		exit(1);
	}

	else 
	{
		string line; //<--

		while (getline(inFile, line))
		{
			_mazeData.push_back(line); //pushback increases size of vector similar to array.
		}

		//Process maze
		char tile;

		for (int row = 0; row < signed (_mazeData.size()); row++)  //loops through  row, y coord
		{ 
			for (int column = 0; column < signed (_mazeData[row].size()); column++)  //loops thorugh letter, x coordinate
			{ 
				tile = _mazeData[row][column]; //yx coord. vector of strings each element of the vector is the the rows from 0.

				if (tile == '@')
					player.setPosition(column,row);  //set xy coord of player
			}
		}
	}
		inFile.close();
}

//Loads file
void Mazes::mazeLoader() //prints maze
{
	system("CLS");//cout << string(15, '\n');

	for (int i = 0; i < signed (_mazeData.size()); i++)
	{
	printf("%s\n", _mazeData[i].c_str()); //cout << _levelData[i] << endl;
	}

    printf("\n@ = Player     # = Lava     F=Goal     C=Coins \n"); //cout << endl << "@ = Player" << "     # = Lava" << "     F=Goal" << "     C=Coins" << endl;
	printf("\nYour score is: %i\n", score); //cout << endl << "Your score: " << score << endl;
}




void Mazes::movePlayer(char input, Player &player)
{

	int playerX;
	int playerY;
	player.getPosition(playerX, playerY);

	switch (input)
	{
	case 'w':  //up
	case 'W':
		processMovement(player, playerX, playerY-1);
		break;
	case 's': //down
	case 'S':
		processMovement(player, playerX, playerY+1);
		break;
	case 'a': //left
	case 'A':
		processMovement(player, playerX-1, playerY);
		break;
	case 'd': //right
	case 'D':
		processMovement(player, playerX+1, playerY);	
		break;
	default:
		cout << "Wrong/Invalid input!" << endl;
		system("pause");
		break;
	}
}

char Mazes::getTile(int x, int y)
{
	return _mazeData[y][x];
} //Teow Jirapa

void Mazes::setTile(int x, int y, char tile)
{
	_mazeData[y][x] = tile;
}

void Mazes::processMovement(Player &player, int targetX, int targetY) 
{
	int playerX;
	int playerY;
	player.getPosition(playerX, playerY);

	char moveTile = getTile(targetX, targetY);


	if (moveTile == '#') //When player steps on '#'
	{
		setTile(playerX, playerY, 'X');
		mazeLoader();
		cout << endl << endl << "You touched the lava! End of game, you lose!" << endl << endl;
		cout << "Your final score is : " << score << endl << endl;
		saveScore();
		system("pause");
		exit(2);
	}
	

	else if (moveTile == '.')    //When player steps on '.'
	{
		player.setPosition(targetX,targetY);
		setTile(playerX, playerY, '.');
		setTile(targetX, targetY, '@');
	}

	else if (moveTile == 'C')                   //When player steps on 'C'
	{
		player.setPosition(targetX,targetY);
		setTile(playerX, playerY, '.');
		setTile(targetX, targetY, '@');
		score+=5;
	}

	else if (moveTile == 'F')   //When player steps on 'F'
	{
		cout << endl << "Congrats you won with a score of " << score << endl;
		system("pause");
		exit(1);
	}

	else if (moveTile == 'G')
	{
		srand(unsigned (time(NULL)));
		int answer;
		int randomNumber = rand()%(12+0-1)+1;
		int randomNumber2 = rand()%(12+0-1)+1;

		int randomConversation = rand()%(2+1-1)+1;

		string conversationOne = "As your approached the guard, he bestows you a question";
		string conversationTwo = "";




		if (randomConversation = 1);

		else if (randomConversation = 2);







		cout << endl << "What's " << randomNumber << "*" <<  randomNumber2 << " = ?" << endl;
		cin >> answer;


		if (answer != randomNumber*randomNumber2)
		{
		
			cout << "Wrong! Try again!" << endl;
			score -= 5;
			_getch();

		}
		else if (answer == randomNumber*randomNumber2)
		{
			cout << "Correct! Well done!" << endl;
			score +=10;
			system("pause");
			player.setPosition(targetX,targetY);
		    setTile(playerX, playerY, '.');
			setTile(targetX, targetY, '@');
		}

	}
} 

void Mazes::saveScore()
{
	fstream myFile;
	string name;
	cout<<"Enter your name: ";
	cin>>name;
	myFile.open("Score.txt",fstream::app);
	if (!myFile)
		cout<<"Unable to Open File under App Mode";
	else
	{
		cout<<endl;
		cout<<left<<setw(25)<<name<<score<<endl;
		myFile<<setw(25)<<name<<score<<endl;
		if (myFile.fail())
			cout<<"Error encountered while adding data!\n";
		else
			cout<<"Score saved!\n";
	}
	myFile.close();
}