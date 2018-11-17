#include <stdio.h>
#include <math.h>
#include <stdio.h> 

void aBinaro(int n, int i) {
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
        unsigned int fraccion: 32;
        unsigned : 0;
        unsigned int fraccion2: 20;
        unsigned int exponente : 11;
        unsigned int signo : 1;
    } campo;
} doubleieee;

int main() {
	printf("%d", sizeof(floatieee));
	printf("%d", sizeof(doubleieee));
	printf("%d", sizeof(double));

   	floatieee f;
    printf("Ingrese un numero de punto flotante: ");
	scanf("%f",&f.num_original);
	printf("\n");
	printf("Numero en formato simple: %d ",f.campo.signo);
	aBinaro(f.campo.exponente, 8);
  	printf(" ");
  	aBinaro(f.campo.fraccion, 23);
   	printf("\n");

   	doubleieee d;
   	printf("Ingrese de nuevo el numero: ");
	scanf("%lf", &d.num_original);
	printf("\n");
   	printf("Numero en formato doble: %d ",d.campo.signo);
   	aBinaro(d.campo.exponente, 11);
  	printf(" ");
  	aBinaro(d.campo.fraccion2, 20);
  	aBinaro(d.campo.fraccion, 32);
   	printf("\n");

   	return 0;
}