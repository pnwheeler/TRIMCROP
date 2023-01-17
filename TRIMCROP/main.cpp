#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QProcess>
#include <QVariant>
#include <QIcon>
#include <QQmlContext>

class Process : public QProcess
{
    Q_OBJECT

public:
    Process(QObject *parent = 0) : QProcess(parent) { }
    virtual ~Process() = default;

    Q_INVOKABLE QByteArray readAll() {
        return QProcess::readAll();
    }

    Q_INVOKABLE QByteArray readAllStandardError(){
        return QProcess::readAllStandardError();
    }

    Q_INVOKABLE QByteArray readAllStandardOutput(){
        return QProcess::readAllStandardOutput();
    }

    Q_INVOKABLE QProcess::ProcessState state(){
        return QProcess::state();
    }

    Q_INVOKABLE void start(const QString &program, const QVariantList &arguments)
    {
        QStringList args;
        for (int i = 0; i < arguments.length(); i++)
            args << arguments[i].toString();
        QProcess::start(program, args);
    }
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<Process>("Process", 1, 0, "Process");
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/TRIMCROP/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}

#include "main.moc"
