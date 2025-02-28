// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "AppSettings.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName("MySoft");
    QCoreApplication::setApplicationName("QML investigation");

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    auto staticSettings = new AppSettings;
    context->setContextProperty("windowsettings", staticSettings);
    engine.loadFromModule("contactlist", "ContactList");

    return app.exec();
}
