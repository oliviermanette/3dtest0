/*#include <QApplication>

#include <QQmlEngine>

*/
#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "cymbdd.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QScopedPointer<CymBDD> cymBdd(new CymBDD);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("cymBdd", cymBdd.data());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));



    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
