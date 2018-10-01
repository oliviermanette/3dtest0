#include "flod3d.h"

flod3D::flod3D(QObject *parent) : QObject(parent)
{
    initBaseColor();
}

flod3D::flod3D(QString strFilename)
{
    initBaseColor();
    readFile(strFilename);
}

bool flod3D::readFile(QString strFilename)
{
    QFile file(strFilename);
    if (!file.open(QIODevice::ReadOnly))
        return false;
    gbaBuffer = file.readAll();
    normBuffer.resize(0);
    file.close();
    if (gbaBuffer.size())
        return true;
    else
        return false;
}

flod3D::FILEFORMAT flod3D::detectFileType()
{
    gFormat=static_cast<FILEFORMAT>(3);
    if (gbaBuffer.length()>5){
        if (gbaBuffer.left(5)=="solid")
            gFormat= STLA;
        else
            gFormat=STLB;
        qDebug()<< "TEST FLOD3D: "<<((gFormat==STLA)?"ASCII":"BINARY");
    }
    return gFormat;
}

uint flod3D::readSTLB()
{
    if (gFormat!=STLB)
        return 0;
    guintSize = *reinterpret_cast<uint*>((gbaBuffer.data()+80)); 
    gbaBuffer.remove(0,84);
    for (int i=0;i<static_cast<int>(guintSize);i++){
        normBuffer.append(gbaBuffer.mid(i*9* static_cast<int>(sizeof (float)),3*static_cast<int>(sizeof(float))));
        gbaBuffer.remove(i*(9*static_cast<int>(sizeof (float))),3*static_cast<int>(sizeof (float)));
        gbaBuffer.remove((i+1)*(9*static_cast<int>(sizeof (float))),2);
    }
    guintSize *=3;
    for (int i=static_cast<int>(guintSize);i>0;i--)
        gbaBuffer.insert(i*(3*static_cast<int>(sizeof (float))),reinterpret_cast<char*>(&gBaseColor),3*sizeof (float));

    gByteStride = 6*sizeof (float);
    return guintSize;
}

uint flod3D::readSTLA()
{
    if (gFormat!=STLA)
        return 0;
    QList<QByteArray> lListLines = gbaBuffer.split('\n');
    //qDebug()<<"Number of Lines : V+N : "<<lListLines.size();
    gbaBuffer.resize(0);
    normBuffer.resize(0);
    int lintSize = lListLines.size();
    uint luintNbVertex=0, luinNbFacets=0;
    QList<QByteArray> lwords;
    float lfltTemp=0.0f;
    for (int i=0;i<lintSize;i++){
         lwords = lListLines[i].split(' ');
         if (lwords.size()>5){
             if (lwords[1]=="facet"){
                 for (int j=3;j<6;j++){
                     lfltTemp = lwords[j].toFloat();
                     normBuffer.append(reinterpret_cast<char*>(&lfltTemp),sizeof (float));
                 }
                 luinNbFacets++;
             }
             else if (lwords[3]=="vertex") {
                 luintNbVertex++;
                 for (int j=4;j<7;j++){
                     lfltTemp = lwords[j].toFloat();
                     gbaBuffer.append(reinterpret_cast<char*>(&lfltTemp),sizeof (float));

                 }
                 gbaBuffer.append(reinterpret_cast<char*>(&gBaseColor),3*static_cast<int>(sizeof(float)));
             }
         }
    }

    guintSize = luintNbVertex;
    qDebug()<<"FLOD3D first vertex : "<<*reinterpret_cast<float*>(gbaBuffer.data());
    qDebug()<<"FLOD3D: number of facet "<<luinNbFacets;
    qDebug()<<"FLOD3D: number of vertex "<<luintNbVertex;
    qDebug()<<"FLOD3D: size of buffer "<<gbaBuffer.size();
    gByteStride = 6*sizeof (float);
    return guintSize;
}

uint flod3D::readSTL()
{
    if (gFormat==STLA)
        return readSTLA();
    else if (gFormat==STLB)
        return readSTLB();
    else
        return 0;
}

void flod3D::initBaseColor()
{
    gBaseColor[0]=154.0f/255.0f;
    gBaseColor[1]=219.0f/255.0f;
    gBaseColor[2]=217.0f/255.0f;
}

QVector3D flod3D::getVertexPos(uint i)
{
    QVector3D lvec3;
    lvec3.setX(*reinterpret_cast<float*>((gbaBuffer.data()+i*gByteStride)));
    lvec3.setY(*reinterpret_cast<float*>((gbaBuffer.data()+i*gByteStride+sizeof (float))));
    lvec3.setZ(*reinterpret_cast<float*>((gbaBuffer.data()+i*gByteStride+2*sizeof (float))));
    return lvec3;
}

QVector3D flod3D::getVertexColor(uint i)
{
    QVector3D lvec3;
    lvec3.setX(*reinterpret_cast<float*>((gbaBuffer.data()+i*gByteStride+3*sizeof (float))));
    lvec3.setY(*reinterpret_cast<float*>((gbaBuffer.data()+i*gByteStride+4*sizeof (float))));
    lvec3.setZ(*reinterpret_cast<float*>((gbaBuffer.data()+i*gByteStride+5*sizeof (float))));
    return lvec3;
}

void flod3D::setVertexColor(int i, QVector3D lvec3)
{
    float lfltValue = lvec3.x();
    gbaBuffer.replace(i*static_cast<int>(gByteStride),sizeof (float),reinterpret_cast<char*>(&lfltValue));
    lfltValue = lvec3.y();
    gbaBuffer.replace(i*static_cast<int>(gByteStride),sizeof (float),reinterpret_cast<char*>(&lfltValue));
    lfltValue = lvec3.z();
    gbaBuffer.replace(i*static_cast<int>(gByteStride),sizeof (float),reinterpret_cast<char*>(&lfltValue));
}

uint flod3D::getNbVertex()
{
    return guintSize;
}

QVector3D flod3D::getBarycenter()
{
    QVector3D lvec3;
    for (uint i=0;i<getNbVertex();i++){
        lvec3 += getVertexPos(i);
    }
    lvec3/=getNbVertex();
    return lvec3;
}
