int sumar(int a, int b) {
  int resultado = a + b;
  return resultado;
}

int main() {
  int x = 3, y = 4, z;
  z = sumar(x, y);
  if (z > 5) {
    z = z * 2;
  } else {
    z = 0;
  }
  return z;
}
