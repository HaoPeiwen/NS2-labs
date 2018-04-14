#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

int main()
{
	srand(time(NULL));
	int num = rand()%10000+1;
	cout<<num<<endl;
	return 0;
}