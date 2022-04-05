void greaterThanZero(int x)
{
  int i;
  if(x > 0)
  {
    std::cout << "X is greater than 0." << std::endl;
    i = 1;
  }
}

int foo(int x, int y)
{
  return x + y;
}

int main()
{
  int a = 1;
  int b = 2;
  int c = 3;
  foo(a, c);

  return 0;
}
