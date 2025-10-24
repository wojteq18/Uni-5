//krotki program zwracajacy macheps w jezyku C
#include <stdio.h>
#include <float.h>
int main() {
    printf("Macheps (machine epsilon) for float: %e\n", FLT_EPSILON);
    printf("Macheps (machine epsilon) for double: %e\n", DBL_EPSILON);
    printf("Macheps (machine epsilon) for long double: %Le\n", LDBL_EPSILON);
    return 0;
}