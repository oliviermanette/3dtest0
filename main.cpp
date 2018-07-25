/*#include <QApplication>



*/
//#include <QQmlEngine>

#include <QCoreApplication>
#include <QGuiApplication>
//#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QQuickView>

#include "cymbdd.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QScopedPointer<CymBDD> cymBdd(new CymBDD);

    /*QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("cymBdd", cymBdd.data());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    */
    QQuickView view;

    view.resize(1280, 768);
    view.rootContext()->setContextProperty("cymBdd", cymBdd.data());
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:/main.qml"));
    view.show();
/*
    if (engine.rootObjects().isEmpty())
        return -1;
*/
    return app.exec();
}
