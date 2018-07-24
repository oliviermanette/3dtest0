#ifndef CYMBDD_H
#define CYMBDD_H

#include <QObject>
#include <QtSql>
#include <QSqlQuery>
#include <QSqlDatabase>
#include <QString>
#include <QDebug>

#include <qtconcurrentrun.h>
#include <QThread>


class CymBDD : public QObject
{
    Q_OBJECT
public:
    explicit CymBDD(QObject *parent = nullptr);

    ~CymBDD();

    Q_INVOKABLE bool addNewSite(QString strNom, double dblLatitude, double dblLongitude, QString strCommentaire);

signals:

public slots:


private:
    QSqlDatabase cloudDb = QSqlDatabase::addDatabase("QMYSQL", "psyched-bee-204709:europe-west2:flod-cymbalum");
    QSqlDatabase localDb = QSqlDatabase::addDatabase("QMYSQL", "localhost");

    bool isCloudDbOpened;
    bool isLocalDbOpened;

    bool OpenCloudDB();
    bool OpenLocaleDB();


};


#endif // CYMBDD_H
