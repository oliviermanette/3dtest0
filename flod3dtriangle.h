#ifndef FLOD3DTRIANGLE_H
#define FLOD3DTRIANGLE_H

#include <flodvec3.h>
class flodVec3;

class flod3DTriangle
{

public:
    //flod3DTriangle():m_sommet1(0),m_sommet2(0),m_sommet3(0){}
    flod3DTriangle(flodVec3* p1, flodVec3* p2, flodVec3* p3);
private:
    flodVec3* m_sommet1;
    flodVec3* m_sommet2;
    flodVec3* m_sommet3;
};

#endif // FLOD3DTRIANGLE_H
