// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#ifndef CONTACTMODEL_H
#define CONTACTMODEL_H

#include <QAbstractListModel>
#include <QQmlEngine>
#include <QPoint>

class ContactModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum ContactRole {
        FullNameRole = Qt::DisplayRole,
        AddressRole = Qt::UserRole,
        CityRole,
        NumberRole,
        CompanyRole,
        PositionRole
    };
    Q_ENUM(ContactRole)

    ContactModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void append(const QString &fullName, const QString &address, const QString  &city, const QString &number, const QString &company = "", const QPoint &position = {});
    Q_INVOKABLE void set(int row, const QString &fullName, const QString &address, const QString  &city, const QString &number, const QString &company = "", const QPoint &position = {});
    Q_INVOKABLE void remove(int row);

private:
    struct Contact {
        QString fullName;
        QString address;
        QString city;
        QString number;
        QString company;
        QPoint position;
    };

    QList<Contact> m_contacts;
};

#endif // CONTACTMODEL_H
