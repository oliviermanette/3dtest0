#ifndef FLODVEC3_H
#define FLODVEC3_H

#include <QVector3D>
#include <QObject>

class flodVec3 : public QVector3D
{
    Q_OBJECT
public:
    flodVec3(char* facet);

signals:

public slots:
};

#endif // FLODVEC3_H
