// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import Qt.labs.settings // Deprecated since 6.5, I should use QSettings instead
import QtCharts
import contactlist

ApplicationWindow {
    id: window

    x: settings.x
    y: settings.y
    width: settings.width
    height: settings.height
    visible: true
    title: qsTr("Contact List")

    Settings {
        id: settings
        category: 'window'
        property int x: 150
        property int y: 150
        property int width: 320
        property int height: 480
        property int page: 0
    }

    function storeSettings() {
        settings.x = window.x
        settings.y = window.y
        settings.width = window.width
        settings.height = window.height
        settings.page = swipeView.currentIndex
    }

    onClosing: storeSettings()

    SwipeView {
        id: swipeView

        currentIndex: settings.page
        anchors.fill: parent

        Item {
            id: contactPage
            property int currentContact: -1

            ContactDialog {
                id: contactDialog
                onFinished: function(fullName, address, city, number, company, positionX, positionY) {
                    // TODO: convert positionl
                    var tempPosition = Qt.point(positionX, positionY)
                    if (contactPage.currentContact === -1)
                        contactView.model.append(fullName, address, city, number, company, tempPosition)
                    else
                        contactView.model.set(contactPage.currentContact, fullName, address, city, number, company, tempPosition)
                }
            }

            ConfirmDeletionDialog {
                id: confirmDeletionDialog
                onAccepted: function() {
                    contactView.model.remove(contactPage.currentContact)
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
                    text: contactPage.currentContact >= 0 ? contactView.model.get(contactPage.currentContact).fullName : ""
                }
                MenuItem {
                    text: qsTr("Edit...")
                    onTriggered: contactDialog.editContact(contactView.model.get(contactPage.currentContact))
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
                    contactPage.currentContact = index
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
                    contactPage.currentContact = -1
                    contactDialog.createContact()
                }
            }
        }
        Item {
            id: secondPage

            Label {
                anchors.centerIn: parent
                text: "Current window size is: " + window.height + "x" + window.width
                    + "\nCurrent window position is: " + window.x + ":" + window.y
            }
        }
        Item {
            id: thirdPage

            Component.onCompleted: loadSeries()

            ChartView {
                title: "Positions"
                anchors.fill: parent
                antialiasing: true

                ValueAxis {
                    id: axisX
                    min: 0
                    max: 10
                    tickCount: 5
                }

                ValueAxis {
                    id: axisY
                    min: -0.5
                    max: 1.5
                }

                ScatterSeries {
                    id: series
                    axisX: axisX
                    axisY: axisY
                }
            }
        }
    }

    PageIndicator {
        id: indicator

        count: swipeView.count
        currentIndex: swipeView.currentIndex

        anchors.bottom: swipeView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }


    RoundButton {
        text: qsTr("S")
        highlighted: true
        anchors.margins: 10
        anchors.right: parent.right
        anchors.top: parent.top
        onClicked: {
            swipeView.currentIndex = 1
        }
    }

    ContactModel {
            id: contactModel

            onRowsRemoved: console.log("REMOVED")
            onDataChanged: console.log("CHANGED")
    }

    function loadSeries() {
        console.log("Model length: " + contactModel.rowCount());
        var xmax = -2147483648;
        var xmin = 2147483647;
        var ymax = -2147483648;
        var ymin = 2147483647;
        for (var i = 0; i < contactModel.rowCount(); i++) {
            var position = contactModel.get(i).position;
            series.append(position.x, position.y);

            if(position.x > xmax)
                xmax = position.x;
            if(position.x < xmin)
                xmin = position.x;
            if(position.y > ymax)
                ymax = position.y;
            if(position.y < ymin)
                ymin = position.y;

            axisX.max = xmax;
            axisX.min = xmin;
            axisY.max = ymax;
            axisY.min = ymin;
        }
    }
}
