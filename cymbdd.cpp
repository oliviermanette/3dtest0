#include "cymbdd.h"

bool CymBDD::OpenCloudDB()
{
    cloudDb.setHostName("35.189.107.44");
    cloudDb.setUserName("root");
    cloudDb.setDatabaseName("Cymbalum_demo");
    cloudDb.setPassword("things2care");

    if(cloudDb.open()){
        qDebug()<<"Google Cloud Database Opened!";
        isCloudDbOpened = true;
        return true;
    }
    else{
        qDebug() << "ERROR Cannot Open Google Cloud DB";//db.lastError().text();
        return false;
    }
}

bool CymBDD::OpenLocaleDB()
{
    localDb.setHostName("127.0.0.1");
    localDb.setUserName("root");
    localDb.setDatabaseName("Cymbalum_demo");
    localDb.setPassword("Things2care");

    if(localDb.open()){
        qDebug()<<"Locale Database Opened!";
        isLocalDbOpened = true;
        return true;
    }
    else{
        qDebug() << "ERROR Cannot Open Locale DB";//db.lastError().text();
        return false;
    }
}

CymBDD::CymBDD(QObject *parent) : QObject(parent)
{
    isCloudDbOpened = false;
    isLocalDbOpened = false;
#ifndef QT_NO_CONCURRENT
        QFuture<bool> cloudDbThread = QtConcurrent::run(this, &CymBDD::OpenCloudDB);
        QFuture<bool> localDbThread = QtConcurrent::run(this, &CymBDD::OpenLocaleDB);
#endif
}

CymBDD::~CymBDD()
{
    if (isCloudDbOpened){
        cloudDb.close();
        qDebug()<<"Cloud Database closed!";
        isCloudDbOpened = false;
    }
    if (isLocalDbOpened){
        localDb.close();
        qDebug()<<"Locale Database closed!";
        isLocalDbOpened = false;
    }
}

bool CymBDD::addNewSite(QString strNom, double dblLatitude, double dblLongitude, QString strCommentaire)
{
    QString lstQuery = "INSERT INTO sites (sites.nom,sites.latitude,sites.longitude,sites.description) VALUES ('"+
            strNom+"', '"+ QString::number(dblLatitude)+"', '"+QString::number(dblLongitude)+"', '"+strCommentaire+"')";
    qDebug() << lstQuery;
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request correctly executed";
            return true;
        }
        else{
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request correctly executed";
            return true;
        }
        else{
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else
        return false;
}


