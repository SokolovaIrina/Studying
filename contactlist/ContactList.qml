// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import Qt.labs.settings // Deprecated since 6.5, what should I use instead?

ApplicationWindow {
    id: window

    property int currentContact: -1

    x: settings.x
    y: settings.y
    width: settings.width
    height: settings.height
    visible: true
    title: qsTr("Contact List")

    Settings {
        id: settings
        category: 'window'
        property int x: 50
        property int y: 50
        property int width: 320
        property int height: 480
    }

    function storeSettings() {
        settings.x = window.x
        settings.y = window.y
        settings.width = window.width
        settings.height = window.height
    }

    onClosing: storeSettings()

    ContactDialog {
        id: contactDialog
        onFinished: function(fullName, address, city, number, company, position) {
            if (window.currentContact === -1)
                contactView.model.append(fullName, address, city, number, company, position)
            else
                contactView.model.set(window.currentContact, fullName, address, city, number, company, position)
        }
    }

    ConfirmDeletionDialog {
        id: confirmDeletionDialog
        onAccepted: function() {
            contactView.model.remove(window.currentContact)
        }
    }

    Menu {
        id: contactMenu
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        modal: true

        Label {
            padding: 10
            font.bold: true
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
            text: window.currentContact >= 0 ? contactView.model.get(window.currentContact).fullName : ""
        }
        MenuItem {
            text: qsTr("Edit...")
            onTriggered: contactDialog.editContact(contactView.model.get(window.currentContact))
        }
        MenuItem {
            text: qsTr("Remove")
            onTriggered: confirmDeletionDialog.open()
        }
    }

    ContactView {
        id: contactView
        anchors.fill: parent
        onPressAndHold: function(index) {
            window.currentContact = index
            contactMenu.open()
        }
    }

    RoundButton {
        text: qsTr("+")
        highlighted: true
        anchors.margins: 10
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        onClicked: {
            window.currentContact = -1
            contactDialog.createContact()
        }
    }

    RoundButton {
        text: qsTr("S")
        highlighted: true
        anchors.margins: 10
        anchors.right: parent.right
        anchors.top: parent.top
        onClicked: {
            // TODO: settings
        }
    }
}
