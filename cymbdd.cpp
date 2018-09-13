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
        // uintSiteOwner = getOwnerIDByLogin("FLOD","Finger1nZeNose");
        guintSiteOwner = 0; // initialize at 0 ==> no user
        //qDebug()<<"should emit the signal just here";
        emit loginRequired();
        // UpdateSitesFromCloud(); // TODO just after user signed in
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
    if (!guintSiteOwner){
        qDebug()<<"login Required !"; //uintSiteOwner
        emit loginRequired();
        return false;
    }
    // Charge tous les sites de la base de donnée dans la limite de MAXSITES_LM
    QString lstQuery = "SELECT idsites, nom, latitude, longitude, description, multisites, linkstruct FROM sites where sites.owner="+QString::number(guintSiteOwner);
    if (strSearchKey.length()>0)
        lstQuery += " and (description like '%"+strSearchKey+"%' or nom like '%"+strSearchKey+"%')";
    lstQuery += " LIMIT "+QString::number(MAXSITES_LM);
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
                dataSite[lintCurrentValue].multisites = nquery.value(5).toUInt();
                dataSite[lintCurrentValue].linkstruct = nquery.value(6).toUInt();
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

bool CymBDD::checkCachesFolders()
{
    //Vérifie l'existence des folders
    QDir filename;
    QString lstrChemin = filename.currentPath();
    lstrChemin.remove("Cymbalum.app/Contents/MacOS"); //Spécifique MacOS
    filename.setCurrent(lstrChemin); //working directory
    if (!filename.exists("structuretypes")){
        if (!filename.mkdir("structuretypes"))
            return false;
    }
    filename.setCurrent(lstrChemin+"/structuretypes");
    if (!filename.exists("icon")){
        if (!filename.mkdir("icon"))
            return false;
    }
    if (!filename.exists("stl")){
        if (!filename.mkdir("stl"))
            return false;
    }
    filename.setCurrent(lstrChemin);

    return true;
}

void CymBDD::pleaseEmitSiteOpened(uint lintSiteID)
{
    //qDebug()<<"Je vais émettre le signal depuis C++";
    //qDebug()<<lintSiteID;
    updateStructList(lintSiteID);
    emit siteOpened(lintSiteID);
}

void CymBDD::pleaseEmitStructOpened(QString lstrName)
{
    emit structOpened(lstrName);
}

void CymBDD::pleaseEmitStructDeleted(uint uinStructID)
{
    emit structDeleted(uinStructID);
}

void CymBDD::pleaseEmitSTypeSelected(uint uinSTypeID, QString strSTypeName)
{
    emit sTypeSelected(uinSTypeID,strSTypeName);
}

int CymBDD::getStructIconFromIndex(int lintPosX, int lintPosY)
{
    for (uint i=0; i<guintNbStructures;i++){
        if (dataStructures[i].intPosX == lintPosX)
            if (dataStructures[i].intPosY == lintPosY)
                return dataStructures[i].intSTypeID;
    }

    return 0;
}

QString CymBDD::getStructNameFromIndex(int lintPosX, int lintPosY)
{
    for (uint i=0; i<guintNbStructures;i++){
        if (dataStructures[i].intPosX == lintPosX)
            if (dataStructures[i].intPosY == lintPosY)
                return dataStructures[i].strName;
    }
    return "";
}

uint CymBDD::getStructIDFromPos(int lintPosX, int lintPosY)
{
    for (uint i=0; i<guintNbStructures;i++){
        if (dataStructures[i].intPosX == lintPosX)
            if (dataStructures[i].intPosY == lintPosY)
                return dataStructures[i].uintStructID;
    }
    return 0;
}

uint CymBDD::updatePipelineList(/*double ldblLat1, double ldblLong1, double ldblLat2, double ldblLong2*/)
{
    /*SELECT
     * T1.idsites as id1, T2.idsites as id2, T1.latitude AS lat1, T1.longitude AS long1, T2.latitude AS lat2, T2.longitude AS long2
     * FROM
     * sites AS T1, sites AS T2
     * WHERE T1.multisites=T2.idsites AND T1.owner=1
     *
     */
    if (!guintSiteOwner){
        qDebug()<<"login Required !"; //uintSiteOwner
        emit loginRequired();
        return false;
    }
    uint luintNbPipeline = 0;
    QString lstrQuery = "SELECT T1.idsites as id1, T2.idsites as id2, T1.latitude AS lat1, T1.longitude AS long1, T2.latitude AS lat2, T2.longitude AS long2 FROM sites AS T1, sites AS T2 WHERE T1.multisites=T2.idsites";
    lstrQuery += " AND T1.owner="+QString::number(guintSiteOwner);

    if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstrQuery)){
            qDebug()<<"request 'updateStructList' correctly executed on cloud";
            while ((nquery.next())  && (luintNbPipeline<MAXSITES_LM))
            {
                dataPipelines[luintNbPipeline].SiteID1 = nquery.value(0).toUInt();
                dataPipelines[luintNbPipeline].SiteID2 =nquery.value(1).toUInt();
                dataPipelines[luintNbPipeline].dblLat1 = nquery.value(2).toDouble();
                dataPipelines[luintNbPipeline].dblLong1 = nquery.value(3).toDouble();
                dataPipelines[luintNbPipeline].dblLat2 = nquery.value(4).toDouble();
                dataPipelines[luintNbPipeline].dblLong2 = nquery.value(5).toDouble();
                luintNbPipeline++;
            }
        }
    }

    guintNbPipelines = luintNbPipeline;
    return guintNbPipelines;
}

uint CymBDD::getPipelineNb()
{
    return guintNbPipelines;
}

uint CymBDD::getLineSiteID1(int lintIndex)
{
    return  dataPipelines[lintIndex].SiteID1;
}

uint CymBDD::getLineSiteID2(int lintIndex)
{
    return  dataPipelines[lintIndex].SiteID2;
}

double CymBDD::getLineSiteLat1(int lintIndex)
{
    return  dataPipelines[lintIndex].dblLat1;
}

double CymBDD::getLineSiteLat2(int lintIndex)
{
    return  dataPipelines[lintIndex].dblLat2;
}

double CymBDD::getLineSiteLong1(int lintIndex)
{
    return  dataPipelines[lintIndex].dblLong1;
}

double CymBDD::getLineSiteLong2(int lintIndex)
{
    return  dataPipelines[lintIndex].dblLong2;
}

bool CymBDD::delPipeline(int lintIndex)
{
    //UPDATE `Cymbalum_demo`.`sites` SET `multisites`='' WHERE `idsites`='15';
    if (!guintSiteOwner){
        qDebug()<<"login Required !"; //uintSiteOwner
        emit loginRequired();
        return false;
    }
    QString lstQuery = "UPDATE sites SET multisites=NULL WHERE idsites="+QString::number(dataPipelines[lintIndex].SiteID1)
            + " AND multisites="+QString::number(dataPipelines[lintIndex].SiteID2)
            +" AND owner="+QString::number(guintSiteOwner);

    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed locally";
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request locally";
            qDebug()<<lstQuery;
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"delete pipeline correctly executed on cloud";
            qDebug()<<lstQuery;
            updatePipelineList();
            UpdateSitesFromCloud();
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request on the cloud";
            qDebug()<<lstQuery;
        }
    }
    return false;
}

bool CymBDD::addFileExtension(QString filename)
{
    QFile toto(filename);
    return toto.rename(filename+".stl");
}

bool CymBDD::removeFileExtension(QString filename)
{
    QFile toto(filename);
    QString lstrTemp = filename.split(".")[0];
    qDebug()<<lstrTemp;
    return toto.rename(lstrTemp);
}

bool CymBDD::updateStructList(uint intSiteID)
{
    QString lstQuery = "SELECT nom, ST_AsText(position_ref), type, idSurface FROM Cymbalum_demo.surfaces where site="+QString::number(intSiteID);
    if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'updateStructList' correctly executed on cloud";
            unsigned int lintCurrentValue = 0;
            while ((nquery.next())  && (lintCurrentValue<MAXSITES_LM))
            {
                dataStructures[lintCurrentValue].strName = nquery.value(0).toString();
                dataStructures[lintCurrentValue].intSTypeID = nquery.value(2).toInt();
                qDebug()<<dataStructures[lintCurrentValue].strName;
                lstQuery = nquery.value(1).toString();
                lstQuery.remove("POINT(");
                dataStructures[lintCurrentValue].intPosX = lstQuery.split(" ")[0].toInt();
                qDebug()<<lstQuery;
                qDebug()<<dataStructures[lintCurrentValue].intPosX;
                lstQuery.remove(")");
                qDebug()<<lstQuery;
                dataStructures[lintCurrentValue].intPosY = lstQuery.split(" ")[1].toInt();
                qDebug()<<dataStructures[lintCurrentValue].intPosY;
                dataStructures[lintCurrentValue].uintStructID = nquery.value(3).toUInt();
                dataStructures[lintCurrentValue].intSiteID = intSiteID;
                lintCurrentValue++;
            }
            guintNbStructures = lintCurrentValue;
            qDebug()<<QString::number(lintCurrentValue) + " structure found";
            return true;
        }
        else{
            qDebug()<<"an error occured while executing the request:";
            qDebug()<<lstQuery;
            return false;
        }
    }
    return false;
}

bool CymBDD::updateSType(QString strSearchKey)
{
    QString lstQuery = "SELECT idstype, typename, description FROM structuretypes where structuretypes.owner="+QString::number(guintSiteOwner);
    if (strSearchKey.length()>0)
        lstQuery = lstQuery +" and (description like '%"+strSearchKey+"%' or typename like '%"+strSearchKey+"%')";
    if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'UpdateSType' correctly executed on cloud";
            unsigned int lintCurrentValue = 0;
            while ((nquery.next())  && (lintCurrentValue<MAXSITES_LM))
            {
                dataSType[lintCurrentValue].uintSTypeID = nquery.value(0).toUInt();
                dataSType[lintCurrentValue].strName = nquery.value(1).toString();
                dataSType[lintCurrentValue].strDescription = nquery.value(2).toString();
                lintCurrentValue++;
            }
            uintGNbSites = lintCurrentValue;
            qDebug()<<QString::number(lintCurrentValue) + " SType found";
            return true;
        }
        else{
            qDebug()<<"an error occured while executing the request:";
            qDebug()<<lstQuery;
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
    guintNbSType = 0;
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
    if (!guintSiteOwner){
        qDebug()<<"login Required !"; //uintSiteOwner
        emit loginRequired();
        return false;
    }

    QString lstQuery = "INSERT INTO sites (sites.nom,sites.latitude,sites.longitude,sites.description, sites.owner) VALUES ('"+
            strNom+"', '"+ QString::number(dblLatitude)+"', '"+QString::number(dblLongitude)+"', '"+strCommentaire+"', '"+QString::number(guintSiteOwner)+"')";
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
    QString lstQuery = "DELETE FROM sites WHERE idsites="+ QString::number(unintSiteRefID)+ " AND owner="+QString::number(guintSiteOwner);
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
            qDebug()<<"request delete Site correctly executed on cloud";
            UpdateSitesFromCloud();
            return true;
        }
        else{
            qDebug()<<"an error occured while executing the request";
            qDebug()<<lstQuery;
            return false;
        }
    }
    else
        return false;
}

bool CymBDD::delStructure(uint luinStructID)
{
    /*
    DELETE surfaces FROM surfaces INNER JOIN sites ON surfaces.site=sites.idsites WHERE sites.owner=1 AND surfaces.idSurface=10 */
    QString lstQuery = "DELETE surfaces FROM surfaces INNER JOIN sites ON surfaces.site=sites.idsites WHERE sites.owner="+QString::number(guintSiteOwner)
            + " AND surfaces.idSurface="+QString::number(luinStructID);
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request delStructure correctly executed locally";
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
            qDebug()<<"request delete Structure correctly executed on cloud";
            emit structDeleted(luinStructID);
            return true;
        }
        else{
            qDebug()<<"an error occured while executing the request";
            qDebug()<<lstQuery;
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

unsigned int CymBDD::addNewStructType(QString strName, QString strDescription)
{
    //INSERT INTO structuretypes (typename,description,owner) values ('test2','oui oui oui')
    //SELECT idstype FROM structuretypes WHERE typename=$var and owner=$uintSiteOwner
        if (!guintSiteOwner){
            emit loginRequired();
            return 0;
        }

    QString lstQuery = "INSERT INTO structuretypes (typename,description,owner) values ('"+strName+"','"+strDescription+"',"+QString::number(guintSiteOwner)+")";
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'addNewStructType' correctly executed locally";
            lstQuery="SELECT idstype FROM structuretypes WHERE typename='"+strName+"' and owner="+QString::number(guintSiteOwner);
            if(nquery.exec(lstQuery)){
                qDebug()<<"request 'get type ID' correctly executed on cloud";
                if (nquery.first())
                {
                    return nquery.value(0).toUInt();
                }
            }
            return false;
        }
        else{
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'addNewStructType' correctly executed on cloud";
            lstQuery="SELECT idstype FROM structuretypes WHERE typename='"+strName+"' and owner="+QString::number(guintSiteOwner);
            if(nquery.exec(lstQuery)){
                qDebug()<<"request 'get type ID' correctly executed on cloud";
                if (nquery.first())
                {
                    return nquery.value(0).toUInt();
                }
            }

            return false;
        }
        else{
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else
        return false;
}

bool CymBDD::addNewStruct(QString strName, QString lintX, QString lintY, QString strSType, int intSiteID)
{
    if (!guintSiteOwner){
        emit loginRequired();
        return 0;
    }
    //INSERT INTO surfaces(nom,site) VALUES('toto',(SELECT idstype from structuretypes WHERE typename='Cuicui'));
    QString lstQuery = "INSERT INTO surfaces(nom,site,position_ref,type) VALUES('"+
            strName+"',"+QString::number(intSiteID)+", ST_GeomFromText('POINT("+lintX+" "+lintY+")')"
            +", (SELECT idstype from structuretypes WHERE typename='"+strSType+"' and owner="+QString::number(guintSiteOwner)+"))";
    if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'add New Structure' correctly executed on cloud";
            updateStructList(intSiteID);
            return true;
        }
        else{
            qDebug()<<"request Add New Structure failed :";
            qDebug()<<lstQuery;
            return false;
        }
    }
    return false;
}

unsigned int CymBDD::getNbSites(unsigned int intOwner)
{
    intOwner = guintSiteOwner;
    if (!intOwner){
        qDebug()<<"emit here again !"; //uintSiteOwner
        emit loginRequired();
        return 0;
    }

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

unsigned int CymBDD::getNbSTypes()
{
    if (!guintSiteOwner){
        emit loginRequired();
        return 0;
    }
    QString lstQuery = "SELECT count(*) FROM Cymbalum_demo.structuretypes where owner="+QString::number(guintSiteOwner);
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'getNbSTypes' correctly executed locally";
            if (nquery.first())
            {
                guintNbSType = nquery.value(0).toUInt();
                return guintNbSType;
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            qDebug()<<lstQuery;
            return 0;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'getNbSTypes' correctly executed on cloud";
            if (nquery.first())
            {
                guintNbSType = nquery.value(0).toUInt();
                return guintNbSType;
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            qDebug()<<lstQuery;
            return 0;
        }
    }
    return 0;
}

unsigned int CymBDD::getNbStructures()
{
    return guintNbStructures;
}

int CymBDD::getStructureStypeID(unsigned int luintIndex)
{
    return dataStructures[luintIndex].intSTypeID;
}

int CymBDD::getStructurePosY(unsigned int luintIndex)
{
    return dataStructures[luintIndex].intPosY;
}

int CymBDD::getStructurePosX(unsigned int luintIndex)
{
    return dataStructures[luintIndex].intPosX;
}

uint CymBDD::getStructureID(unsigned int luintIndex)
{
    return dataStructures[luintIndex].uintStructID;
}

uint CymBDD::getStructureSiteID(unsigned int luintIndex)
{
    return dataStructures[luintIndex].intSiteID;
}

QString CymBDD::getStructureName(unsigned int luintIndex)
{
    return dataStructures[luintIndex].strName;
}

QString CymBDD::getSiteName(int intIndex, unsigned int intOwner)
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

QString CymBDD::getSTypeName(int intIndex)
{
    return dataSType[intIndex].strName;
}

QString CymBDD::getSTypeDescription(int intIndex)
{
    return  dataSType[intIndex].strDescription;
}

unsigned int CymBDD::getSTypeID(int intIndex)
{
    return dataSType[intIndex].uintSTypeID;
}

QString CymBDD::getSiteDescription(int intIndex, unsigned int intOwner)
{
    QString lstQuery = "SELECT description FROM sites where sites.owner="+QString::number(intOwner)+" limit "+QString::number(intIndex)+",1";
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'get site description' correctly executed locally";
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
            return dataSite[intIndex].m_strDescription;
    }
    return "false";
}

double CymBDD::getSiteLatitude(int intIndex, unsigned int intOwner)
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

unsigned int CymBDD::getSiteID(int intIndex, unsigned int intOwner)
{
    QString lstQuery = "SELECT idsites FROM sites where sites.owner="+QString::number(intOwner)+" limit "+QString::number(intIndex)+",1";
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request getSiteLatitude correctly executed locally";
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
            return dataSite[intIndex].m_uintIdSite;
    }
    return false;
}

unsigned int CymBDD::getSiteLinked(int intIndex, unsigned int intOwner)
{
    QString lstQuery = "SELECT multisites FROM sites where sites.owner="+QString::number(intOwner)+" limit "+QString::number(intIndex)+",1";
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request getSiteLatitude correctly executed locally";
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
            return dataSite[intIndex].multisites;
    }
    return false;
}

unsigned int CymBDD::getSiteLinkStruct(int intIndex, unsigned int intOwner)
{
    QString lstQuery = "SELECT linkstruct FROM sites where sites.owner="+QString::number(intOwner)+" limit "+QString::number(intIndex)+",1";
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request getSiteLatitude correctly executed locally";
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
            return dataSite[intIndex].linkstruct;
    }
    return false;
}



double CymBDD::getSiteLongitude(int intIndex, unsigned int intOwner)
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

unsigned int CymBDD::getSiteScale(int intIndex)
{
    QString lstQuery = "SELECT scale FROM sites where sites.owner="+QString::number(guintSiteOwner)+" AND idsites="+QString::number(intIndex);
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request getSiteScale correctly executed locally";
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
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            //qDebug()<<"request getSiteScale correctly executed on cloud";
            if (nquery.first())
            {
                return nquery.value(0).toUInt();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request getSiteScale on cloud";
            qDebug()<< lstQuery;
            return false;
        }
    }
    return false;
}

int CymBDD::sendFileToCloud(QString strfilename, QString strDestination, int intIndex)
{
    QString lstrCommand = "gsutil cp " + strfilename + " gs://cymbalum_files/"+strDestination+"/"+QString::number(intIndex);
    lstrCommand = "/Users/oliviermanette/google-cloud-sdk/bin/gsutil";
    //lstrCommand = "/bin/ls";
    qDebug() << lstrCommand;
    QStringList arguments;
    arguments << "cp" << strfilename << "gs://cymbalum_files/"+strDestination+"/"+QString::number(intIndex);
    //arguments <<"-lah"<<"/Users/oliviermanette";
    QProcess process;
    process.setProgram(lstrCommand);
    process.setArguments(arguments);

    process.startDetached();
    process.waitForFinished(-1);
    QString output(process.readAllStandardOutput());
    qDebug()<<output;
    return 0;
}

bool CymBDD::downloadFileFromCloud(QString strPath, QString strFilename)
{
    QProcess process;
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    //GOOGLE_CLOUD_PROJECT="psyched-bee-204709"
    env.insert("GOOGLE_CLOUD_PROJECT", "psyched-bee-204709"); // Add an environment variable
    //GOOGLE_APPLICATION_CREDENTIALS="/Users/oliviermanette/Downloads/Cymbalum-iot-26e6a1b6a592.json"
    env.insert("GOOGLE_APPLICATION_CREDENTIALS", "/Users/oliviermanette/Downloads/Cymbalum-iot-26e6a1b6a592.json");
    process.setProcessEnvironment(env);
    //./bucketucl -o=cymbalum_files/structuretypes/icon:1 read >structuretypes/icon/1
    process.setProgram("bucketucl");
    QStringList arguments;
    arguments << "-o=cymbalum_files/"+strPath+":"+strFilename <<"read" << strPath+"/" +strFilename;
    process.setArguments(arguments);
    process.startDetached();

    process.waitForFinished(-1);
    QString output(process.readAllStandardOutput());
    qDebug()<<output;
    return false;
}

bool CymBDD::isFileExist(QString strFilename)
{
    QDir filename;
    QString lstrChemin = filename.currentPath();
    lstrChemin.remove("Cymbalum.app/Contents/MacOS"); //Spécifique MacOS
    lstrChemin.remove("structuretypes"); //au cas où il s'y trouve à cause du cache
    //qDebug() << lstrChemin;
    lstrChemin += strFilename;
    qDebug() << lstrChemin;
    return filename.exists(lstrChemin);
}

QString CymBDD::getLocalPath()
{
    QDir filename;
    QString lstrChemin = filename.currentPath();
    lstrChemin.remove("Cymbalum.app/Contents/MacOS");
    return  lstrChemin;
}

QString CymBDD::fileNameFromPath(const QString &filePath)
{
    return QFileInfo(filePath).fileName();
}

unsigned int CymBDD::getSiteSizeX(int intIndex)
{
    //SELECT ST_AsText(geometrie) from sites where idsites=16;
    QString lstQuery = "SELECT ST_AsText(geometrie) from sites where idsites="+QString::number(intIndex)+
            " AND owner="+QString::number(guintSiteOwner);
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request getSiteSizeX correctly executed locally";
            if (nquery.first())
            {
                lstQuery = nquery.value(0).toString();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            if (nquery.first())
            {
                lstQuery = nquery.value(0).toString();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    if ((lstQuery.length()==0)||(lstQuery.length()>12))
        return 0;
    else{
        QString lstResult=lstQuery.split('(')[1];
        return lstResult.split(' ')[0].toUInt();
    }
}

unsigned int CymBDD::getSiteSizeY(int intIndex)
{
    //SELECT ST_AsText(geometrie) from sites where idsites=16;
    QString lstQuery = "SELECT ST_AsText(geometrie) from sites where idsites="+QString::number(intIndex)+
            " AND owner="+QString::number(guintSiteOwner);
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request getSiteSizeX correctly executed locally";
            if (nquery.first())
            {
                lstQuery = nquery.value(0).toString();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            if (nquery.first())
            {
                lstQuery = nquery.value(0).toString();
            }
        }
        else {
            qDebug()<<"an error occured while executing the request";
            return false;
        }
    }
    if ((lstQuery.length()==0)||(lstQuery.length()>12))
        return 0;
    else{
        QString lstResult=lstQuery.split('(')[1];
        lstResult.remove(')');
        return lstResult.split(' ')[1].toUInt();
    }
}

bool CymBDD::setSiteSize(int intIndex, QString lintX, QString lintY, QString lintScale)
{
    //UPDATE sites SET geometrie=ST_GeomFromText('POINT(3 5)') WHERE idsites=15
    QString lstQuery = "UPDATE sites SET geometrie=ST_GeomFromText('POINT("+lintX+" "+lintY+
            ")'), scale="+lintScale
            +" WHERE idsites="+QString::number(intIndex)+" AND owner="+QString::number(guintSiteOwner);

    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed locally";
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request locally";
            qDebug()<<lstQuery;
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed on cloud";
            qDebug()<<lstQuery;
            UpdateSitesFromCloud();
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request on the cloud";
            qDebug()<<lstQuery;
        }
    }
    return false;
}

bool CymBDD::setUpdateStruct(uint uintStructID, uint uintSiteID, uint uintPosX, uint uintPosY, QString strName, uint uintSTypeID)
{
    //UPDATE surfaces SET position_ref=ST_GeomFromText('POINT(0 0)'), nom="toto" WHERE idSurface=11 AND site=11
    QString lstQuery = "UPDATE surfaces SET position_ref=ST_GeomFromText('POINT("+QString::number(uintPosX) +" "+
            QString::number(uintPosY)+")'), nom='"+ strName+"' ";
    if (uintSTypeID)
        lstQuery+=", type="+QString::number(uintSTypeID);
    lstQuery+=" WHERE idSurface="+QString::number(uintStructID)+" AND site="+QString::number(uintSiteID);

    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed locally";
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request locally";
            qDebug()<<lstQuery;
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed on cloud";
            qDebug()<<lstQuery;
            UpdateSitesFromCloud();
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request on the cloud";
            qDebug()<<lstQuery;
        }
    }
    return false;
}

bool CymBDD::setUpdateSite(unsigned int uintSiteID, QString strName, QString strDescription, QString dblLatitude, QString dblLongitude)
{
    //UPDATE `Cymbalum_demo`.`sites` SET `description`='Pendant 2 an, nous y étions' WHERE `idsites`='4';
    QString lstQuery = "UPDATE `Cymbalum_demo`.`sites` SET `description`='"+
            strDescription+
            "', nom='"+
            strName+
            "', latitude="+
            dblLatitude+
            ", longitude="+
            dblLongitude +
            " WHERE idsites="+
            QString::number(uintSiteID)+
            " AND owner="+QString::number(guintSiteOwner);
    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed locally";
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request locally";
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed on cloud";
            qDebug()<<lstQuery;
            UpdateSitesFromCloud();
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request on the cloud";
            qDebug()<<lstQuery;
        }

    }
    return false;
}

bool CymBDD::addLinkToSites(uint uinSiteID1, uint uinSiteID2, uint uintSTypeID)
{
    QString lstQuery = "UPDATE `Cymbalum_demo`.`sites` SET multisites="+ QString::number(uinSiteID2);
    if (uintSTypeID)
        lstQuery += ", linkstruct="+ QString::number(uintSTypeID);
    lstQuery +=" WHERE idsites="+ QString::number(uinSiteID1)+ " AND owner="+QString::number(guintSiteOwner);

    if ((!isCloudDbOpened)&&isLocalDbOpened){
        QSqlQuery nquery(localDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed locally";
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request locally";
            return false;
        }
    }
    else if (isCloudDbOpened){
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"update site correctly executed on cloud";
            qDebug()<<lstQuery;
            UpdateSitesFromCloud();
            updatePipelineList();
            return true;
        }
        else {
            qDebug()<<"an error occured while executing the request on the cloud";
            qDebug()<<lstQuery;
        }
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
        QSqlQuery nquery(cloudDb);
        if (nquery.exec(lstQuery)){
            qDebug()<<"request 'login' correctly executed on cloud";
            if (nquery.first()){
                guintSiteOwner = nquery.value(0).toUInt();
                UpdateSitesFromCloud();
                updatePipelineList();
                return guintSiteOwner;
            }
        }
        else{
            qDebug()<<"an error occured while executing the login request";
            return 0;
        }
    }
    return 0;
}

unsigned int CymBDD::getOwnerID()
{
    return guintSiteOwner;
}

bool CymBDD::signOut()
{
    guintSiteOwner = 0;
    return true;
}

void CymBDD::toto()
{
    emit loginRequired();
}


