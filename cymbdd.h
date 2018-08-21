#ifndef CYMBDD_H
#define CYMBDD_H

#define MAXSITES_LM 100

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
    //Q_INVOKABLE
    Q_INVOKABLE bool delSite(unsigned int unintSiteRefID);
    //;https://flodnode.visualstudio.com/_git/untitled?path=%2Fgetaccinfo.cpp&version=GBmint_1_parme&line=380&lineStyle=plain&lineEnd=380&lineStartColumn=41&lineEndColumn=46
    Q_INVOKABLE bool addNewSurface(QString strNom,unsigned int uintSiteRefID, QString strPosition); //ID, nom, site,position_ref
    Q_INVOKABLE bool addNewSensor(QString strPosition,QString strSerialNo,unsigned int uintSurfRefID); //position, SN, surface
    //INSERT INTO enregistrements (enregistrements.capteur, enregistrements.dateHeure, enregistrements.duration, enregistrements.freqMoyenne, enregistrements.puissanceMoyenne) values (1, '2018-12-24 13:32:48', 300000,50.1,12.3);
    Q_INVOKABLE bool addNewRecording(unsigned int uintSensorRefID, QString strDateTime, unsigned int uintDuration, double fltFreqMoy, double fltPuissMoy); //YYYY-MM-DD HH:mm:SS.

    Q_INVOKABLE unsigned int getNbSites(unsigned int intOwner=0);
    Q_INVOKABLE QString getSiteName(int intIndex, unsigned int intOwner=0);
    Q_INVOKABLE double getSiteLatitude(int intIndex, unsigned int intOwner=0);
    Q_INVOKABLE double getSiteLongitude(int intIndex, unsigned int intOwner=0);

    Q_INVOKABLE bool filterSitesByND(QString strToken);

    Q_INVOKABLE unsigned int getOwnerIDByLogin(QString strLoginOrEMail, QString strPasswd);

    Q_INVOKABLE void toto();


    //Structure accessible depuis QML pour éviter de faire trop de requêtes sql et réseaux compte tenu du cloud
    struct strDataSite {
        unsigned int m_uintIdSite;
        double m_dblLatitude;
        double m_dblLongitude;
        QString m_strDescription;
        QString m_strNomSite;
    };
    strDataSite dataSite[MAXSITES_LM];
    unsigned int uintGNbSites;

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

};


#endif // CYMBDD_H
