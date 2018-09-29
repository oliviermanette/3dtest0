#ifndef FLOD3D_H
#define FLOD3D_H

#include <QObject>
#include <QByteArray>
#include <QFile>
#include <QVector3D>

#include <Qt3DRender/QAttribute>
#include <Qt3DRender/QBuffer>
#include <Qt3DRender/QGeometry>
#include <Qt3DRender/QGeometryRenderer>

class flod3D : public QObject
{
    Q_OBJECT
public:
    explicit flod3D(QObject *parent = nullptr);
    flod3D(QString strFilename);
    bool readFile(QString strFilename);
    enum FILEFORMAT {STLA, STLB, NONE};
    FILEFORMAT detectFileType();
    uint readSTLB();
    void initBaseColor();

    QVector3D getVertexPos(uint i);
    QVector3D getVertexColor(uint i);
    void setVertexColor(int i,QVector3D);
    inline uint getNbVertex();
    QVector3D getBarycenter();

private:
    FILEFORMAT gFormat;
    QByteArray gbaBuffer, normBuffer;

    Qt3DRender::QAttribute gVertexAttBuffer;
    Qt3DRender::QBuffer* gOGLBuffer;
    Qt3DRender::QGeometry* gOGLGeometry;
    Qt3DRender::QGeometryRenderer* gOGLGeomRenderer;

    float gBaseColor[3];
    uint guintSize;
    uint gByteStride;

signals:

public slots:
};

#endif // FLOD3D_H
