#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL", "psyched-bee-204709:europe-west2:flod-cymbalum"); // VERY IMPORTANT INSERT QODBC3 AND NOT QODBC
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

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
