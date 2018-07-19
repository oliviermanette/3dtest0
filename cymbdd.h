#ifndef CYMBDD_H
#define CYMBDD_H

#include <QObject>
#include <QtSql>
#include <QSqlQuery>
#include <QSqlDatabase>
#include <QString>
#include <QDebug>

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
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL", "psyched-bee-204709:europe-west2:flod-cymbalum"); // VERY IMPORTANT INSERT QODBC3 AND NOT QODBC
};

#endif // CYMBDD_H
