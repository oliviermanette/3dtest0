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

bool CymBDD::delSite(unsigned int unintSiteRefID)
{
    //DELETE FROM sites WHERE idsite=unintSiteRefID;
    QString lstQuery = "DELETE FROM sites WHERE idsite="+ QString::number(unintSiteRefID);
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

bool CymBDD::addNewSurface(QString strNom, unsigned int uintSiteRefID, QString strPosition)
{
    //INSERT INTO surfaces (surfaces.nom, surfaces.site, surfaces.position_ref)  values ("toto", 1,ST_GeomFromText('POINT(0 0)'));
    QString lstQuery = "INSERT INTO surfaces (surfaces.nom, surfaces.site, surfaces.position_ref)  values ('" +
            strNom+"', '"+ QString::number(uintSiteRefID)+"', ST_GeomFromText('POINT("+strPosition+")'))";
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

//position, SN, surface
bool CymBDD::addNewSensor(QString strPosition, QString strSerialNo, unsigned int uintSurfRefID)
{
    //INSERT INTO capteurs (capteurs.position, capteurs.sn, capteurs.surface)  values (ST_GeomFromText('POINT(0 0)'), 'toto', 1);
    QString lstQuery = "INSERT INTO capteurs (capteurs.position, capteurs.sn, capteurs.surface) values (ST_GeomFromText('POINT(" +
            strPosition+")'), '" + strSerialNo + "', " + QString::number(uintSurfRefID) +")";
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

bool CymBDD::addNewRecording(unsigned int uintSensorRefID, QString strDateTime, unsigned int uintDuration, double fltFreqMoy, double fltPuissMoy)
{
    //INSERT INTO enregistrements (enregistrements.capteur, enregistrements.dateHeure, enregistrements.duration, enregistrements.freqMoyenne, enregistrements.puissanceMoyenne)
    //values (1, '2018-12-24 13:32:48', 300000,50.1,12.3);
    QString lstQuery = "INSERT INTO enregistrements (enregistrements.capteur, enregistrements.dateHeure, enregistrements.duration, enregistrements.freqMoyenne, enregistrements.puissanceMoyenne) values (" +
            QString::number(uintSensorRefID)+", '" + strDateTime + "', " + QString::number(uintDuration) + ", " + QString::number(fltFreqMoy) + ", " + QString::number(fltPuissMoy) + ")";
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


