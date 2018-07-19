#ifndef CYMBDD_H
#define CYMBDD_H

#include <QObject>

class CymBDD : public QObject
{
    Q_OBJECT
public:
    explicit CymBDD(QObject *parent = nullptr);

signals:

public slots:
};

#endif // CYMBDD_H