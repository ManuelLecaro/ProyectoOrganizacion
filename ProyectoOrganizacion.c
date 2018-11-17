#include<stdio>
#include <math.h>
#include<stdio.h> 

int aBinaro(int n, int i) {
    int k;
    for (i--; i >= 0; i--) {
    k = n >> i;
  	if (k & 1)
      	printf("1");
  	else
     	printf("0");
    }
}

typedef union {
    float num_original;
  	struct {
        unsigned int fraccion : 23;
        unsigned int exponente : 8;
        unsigned int signo : 1;
    } campo;
} floatieee;

typedef union {
    double num_original;
  	struct {
        unsigned int fraccion : 52;
        unsigned int exponente : 11;
        unsigned int signo : 1;
    } campo;
} doubleieee;

int main() {
   	floatieee f;
   	doubleieee d;
    printf("Ingrese un numero de punto flotante: ");
	scanf("%f%lf",&f.num_original, &d.num_original);
	printf("")
	printf("Numero en formato simple: %d ",f.campo.signo);
	aBinaro(f.campo.exponente, 8);
  	printf(" ");
  	aBinaro(f.campo.fraccion, 23);
   	printf("\n");

   	printf("Numero en formato doble: \n",d.campo.signo);
   	aBinaro(d.campo.exponente, 11);
  	printf(" ");
  	aBinaro(d.campo.fraccion, 52);
   	printf("\n");

   	return 0;
}