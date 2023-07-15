#include <stdio.h>
#include <string.h>
#include "terminal_user_input.h"

#define LOOP_COUNT 60

int main()
{
  my_string name;
  int index;
 
  name = read_string("What is your name? ");

  printf("Your name is: %s\n is a ", name.str);

  // Move the following code into a procedure
  // ie:  void print_silly_name(my_string name)

  for(index=0;index<LOOP_COUNT;index++) {


    printf("silly, ");

  }
  printf("\nname!\n");

  return 0;
}
