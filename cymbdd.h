#ifndef CYMBDD_H
#define CYMBDD_H

#define MAXSITES_LM 100

#include <QObject>
#include <QtSql>
#include <QSqlQuery>
#include <QSqlDatabase>
#include <QString>
#include <QDebug>

#include <QProcess>
#include <QDir>

#include <qtconcurrentrun.h>
#include <QThread>

class CymBDD : public QObject
{
    Q_OBJECT
public:
    explicit CymBDD(QObject *parent = nullptr);

    ~CymBDD();

    Q_INVOKABLE bool addNewSite(QString strNom, double dblLatitude, double dblLongitude, QString strCommentaire);
    //Q_INVOKABLE
    Q_INVOKABLE bool delSite(unsigned int unintSiteRefID);
    //;https://flodnode.visualstudio.com/_git/untitled?path=%2Fgetaccinfo.cpp&version=GBmint_1_parme&line=380&lineStyle=plain&lineEnd=380&lineStartColumn=41&lineEndColumn=46
    Q_INVOKABLE bool addNewSurface(QString strNom,unsigned int uintSiteRefID, QString strPosition); //ID, nom, site,position_ref
    Q_INVOKABLE bool addNewSensor(QString strPosition,QString strSerialNo,unsigned int uintSurfRefID); //position, SN, surface
    //INSERT INTO enregistrements (enregistrements.capteur, enregistrements.dateHeure, enregistrements.duration, enregistrements.freqMoyenne, enregistrements.puissanceMoyenne) values (1, '2018-12-24 13:32:48', 300000,50.1,12.3);
    Q_INVOKABLE bool addNewRecording(unsigned int uintSensorRefID, QString strDateTime, unsigned int uintDuration, double fltFreqMoy, double fltPuissMoy); //YYYY-MM-DD HH:mm:SS.

    Q_INVOKABLE unsigned int addNewStructType(QString strName, QString strDescription);
    Q_INVOKABLE bool addNewStruct(QString strName, QString lintX, QString lintY, QString strSType, int intSiteID);

    Q_INVOKABLE unsigned int getNbSites(unsigned int intOwner=0);
    Q_INVOKABLE unsigned int getNbSTypes();
    Q_INVOKABLE QString getSiteName(int intIndex, unsigned int intOwner=0);

    Q_INVOKABLE bool updateSType(QString strSearchKey="");
    Q_INVOKABLE QString getSTypeName(int intIndex);
    Q_INVOKABLE QString getSTypeDescription(int intIndex);
    Q_INVOKABLE unsigned int getSTypeID(int intIndex);
    Q_INVOKABLE QString getSiteDescription(int intIndex, unsigned int intOwner=0);
    Q_INVOKABLE double getSiteLatitude(int intIndex, unsigned int intOwner=0);
    Q_INVOKABLE unsigned int getSiteID(int intIndex, unsigned int intOwner=0);
    Q_INVOKABLE double getSiteLongitude(int intIndex, unsigned int intOwner=0);
    Q_INVOKABLE unsigned int getSiteScale(int intIndex);

    Q_INVOKABLE int sendFileToCloud(QString strfilename, QString strDestination, int intIndex);
    Q_INVOKABLE bool isFileExist(QString strFilename); //i.e: exist locally

    Q_INVOKABLE unsigned int getSiteSizeX(int intIndex);
    Q_INVOKABLE unsigned int getSiteSizeY(int intIndex);

    Q_INVOKABLE bool setSiteSize(int intIndex, QString lintX, QString lintY, QString lintScale);

    Q_INVOKABLE bool setUpdateSite(unsigned int uintSiteID, QString strName, QString strDescription, QString dblLatitude, QString dblLongitude);

    Q_INVOKABLE bool filterSitesByND(QString strToken);

    Q_INVOKABLE unsigned int getOwnerIDByLogin(QString strLoginOrEMail, QString strPasswd);
    Q_INVOKABLE unsigned int getOwnerID();
    Q_INVOKABLE bool signOut();

    Q_INVOKABLE void toto();

signals:
    void loginRequired();

public slots:

private:
    QSqlDatabase cloudDb = QSqlDatabase::addDatabase("QMYSQL", "psyched-bee-204709:europe-west2:flod-cymbalum");
    QSqlDatabase localDb = QSqlDatabase::addDatabase("QMYSQL", "localhost");

    bool isCloudDbOpened;
    bool isLocalDbOpened;

    bool OpenCloudDB();
    bool OpenLocaleDB();
    bool UpdateSitesFromCloud(QString strSearchKey="");

    unsigned int uintSiteOwner;

    //Structure pour éviter de faire trop de requêtes sql et réseaux compte tenu du cloud
    struct strDataSite {
        double m_dblLatitude;
        double m_dblLongitude;
        unsigned int m_uintIdSite;
        QString m_strNomSite;
        QString m_strDescription;
    };
    strDataSite dataSite[MAXSITES_LM];
    unsigned int uintGNbSites;

    struct stcSType{
        QString strName;
        QString strDescription;
        unsigned int uintSTypeID;
    };
    stcSType dataSType[MAXSITES_LM];
    unsigned int guintNbSType;

    bool updateStructList(int intSiteID);

    struct stcStructures{
        QString strName;
        int intPosX;
        int intPosY;
        int intSTypeID;
        int intSiteID;
    };
    stcStructures dataStructures[MAXSITES_LM];
    unsigned int guintNbStructures;
};


#endif // CYMBDD_H
