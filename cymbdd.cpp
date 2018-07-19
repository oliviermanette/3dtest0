#include "cymbdd.h"

CymBDD::CymBDD(QObject *parent) : QObject(parent)
{
    db.setHostName("35.189.107.44");
    db.setUserName("root");
    db.setDatabaseName("Cymbalum_demo");
    db.setPassword("things2care");
    if(db.open()){
        qDebug()<<"Database opened!";
    }
    else{
        qDebug() << "ERROR";//db.lastError().text();
    }
}

CymBDD::~CymBDD()
{
    db.close();
    qDebug()<<"Database closed!";
}

bool CymBDD::addNewSite(QString strNom, double dblLatitude, double dblLongitude, QString strCommentaire)
{
    if (!db.open()){
        return false;
    }
    else{
        QString lstQuery = "INSERT INTO sites (sites.nom,sites.latitude,sites.longitude,sites.description) VALUES ('"+
                strNom+"', '"+ QString::number(dblLatitude)+"', '"+QString::number(dblLongitude)+"', '"+strCommentaire+"')";
        qDebug() << lstQuery;
        QSqlQuery nquery(db);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request correctly executed";
            return true;
        }
        else{
            qDebug()<<"an error occured while executing the request";
            return false;
        }


    }
}
