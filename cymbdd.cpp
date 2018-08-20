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
        uintSiteOwner = getOwnerIDByLogin("FLOD","Finger1nZeNose");
        UpdateSitesFromCloud();
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

bool CymBDD::UpdateSitesFromCloud(QString strSearchKey)
{
    // Charge tous les sites de la base de donnée dans la limite de MAXSITES_LM
    QString lstQuery = "";
    if (strSearchKey.length()==0)
        lstQuery = "SELECT idsites, nom, latitude, longitude, description FROM sites where sites.owner="+QString::number(uintSiteOwner);
    else
        lstQuery = "SELECT idsites, nom, latitude, longitude, description FROM sites where sites.owner="+QString::number(uintSiteOwner) +
                " and (description like '%"+strSearchKey+"%' or nom like '%"+strSearchKey+"%')";
    if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'Update Sites' correctly executed on cloud";
            //qDebug()<< lstQuery;
            unsigned int lintCurrentValue = 0;
            while ((nquery.next())  && (lintCurrentValue<MAXSITES_LM))
            {
                //return nquery.value(0).toInt();
                dataSite[lintCurrentValue].m_uintIdSite = nquery.value(0).toUInt();
                dataSite[lintCurrentValue].m_dblLatitude = nquery.value(2).toDouble();
                dataSite[lintCurrentValue].m_dblLongitude = nquery.value(3).toDouble();
                dataSite[lintCurrentValue].m_strDescription = nquery.value(4).toString();
                dataSite[lintCurrentValue].m_strNomSite = nquery.value(1).toString();
                lintCurrentValue++;
            }
            uintGNbSites = lintCurrentValue;
            qDebug()<<QString::number(lintCurrentValue) + " found";
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

CymBDD::CymBDD(QObject *parent) : QObject(parent)
{
    isCloudDbOpened = false;
    isLocalDbOpened = false;

    uintGNbSites = 0;
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
            qDebug()<<"request addNewSite correctly executed locally";
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
            qDebug()<<"request addNewSite correctly executed on cloud";
            // Ajout localement également
            QSqlQuery nquery(localDb);
            if (nquery.exec(lstQuery)){
                qDebug()<<"request addNewSite correctly duplicated locally";
                return true;
            }
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
            qDebug()<<"request delSite correctly executed locally";
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
            qDebug()<<"request delSite correctly executed on cloud";
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
            qDebug()<<"request addNewSurface correctly executed locally";
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
            qDebug()<<"request addNewSurface correctly executed on cloud";
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
            qDebug()<<"request addNewSensor correctly executed locally";
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
            qDebug()<<"request addNewSensor correctly executed on cloud";
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
            qDebug()<<"request 'addNewRecording' correctly executed locally";
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
            qDebug()<<"request 'addNewRecording' correctly executed on cloud";
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

unsigned int CymBDD::getNbSites(int intOwner)
{
    QString lstQuery = "SELECT count(*) FROM sites where sites.owner="+QString::number(intOwner);
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'get Nb Sites' correctly executed locally";
            if (nquery.first())
            {
                return nquery.value(0).toUInt();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else if (isCloudDbOpened){
        if (uintGNbSites)
            return uintGNbSites;
        }
    return false;
}

QString CymBDD::getSiteName(int intIndex, int intOwner)
{
    //SELECT nom FROM sites limit 1,1;
    QString lstQuery = "SELECT nom FROM sites where sites.owner="+QString::number(intOwner)+" limit "+QString::number(intIndex)+",1";
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'get site name' correctly executed locally";
            if (nquery.first())
            {
                return nquery.value(0).toString();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            return "false";
        }
    }
    else if (isCloudDbOpened){
        if (uintGNbSites)
            return dataSite[intIndex].m_strNomSite;
    }
    return "false";
}

double CymBDD::getSiteLatitude(int intIndex, int intOwner)
{
    QString lstQuery = "SELECT latitude FROM sites where sites.owner="+QString::number(intOwner)+" limit "+QString::number(intIndex)+",1";
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request getSiteLatitude correctly executed locally";
            if (nquery.first())
            {
                return nquery.value(0).toDouble();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else if (isCloudDbOpened){
        if (uintGNbSites)
            return dataSite[intIndex].m_dblLatitude;
    }
    return false;
}

double CymBDD::getSiteLongitude(int intIndex, int intOwner)
{
    QString lstQuery = "SELECT longitude FROM sites where sites.owner="+QString::number(intOwner)+" limit "+QString::number(intIndex)+",1";
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request getSiteLongitude correctly executed locally";
            if (nquery.first())
            {
                return nquery.value(0).toDouble();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else if (isCloudDbOpened){
        if (uintGNbSites)
            return dataSite[intIndex].m_dblLongitude;        
    }
    return false;
}

bool CymBDD::filterSitesByND(QString strToken)
{
    return UpdateSitesFromCloud(strToken);
}

unsigned int CymBDD::getOwnerIDByLogin(QString strLoginOrEMail, QString strPasswd)
{
    if (isCloudDbOpened){
        QString lstQuery = "SELECT idowner FROM Cymbalum_demo.owners where (OwnerName='"+strLoginOrEMail+
                "' or email='"+strLoginOrEMail+"') and pass=SHA1('"+strPasswd+"')";
        qDebug()<<lstQuery;
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'login' correctly executed on cloud";
            //qDebug()<< lstQuery;
            if (nquery.first())
                return nquery.value(0).toUInt();
        }
        else{
            qDebug()<<"an error occured while executing the login request";
            return 0;
        }
    }
    return 0;
}


