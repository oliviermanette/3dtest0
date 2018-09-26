#include "flodvec3.h"

flodVec3::flodVec3(char* facet)
{
    char f1[4] = {facet[0],
    facet[1],facet[2],facet[3]};

    char f2[4] = {facet[4],
        facet[5],facet[6],facet[7]};

    char f3[4] = {facet[8],
        facet[9],facet[10],facet[11]};

    setX(*f1);
    setY(*f2);
    setZ(*f3);
}
