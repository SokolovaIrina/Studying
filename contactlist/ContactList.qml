// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import Qt.labs.settings // Deprecated since 6.5, what should I use instead?
import QtCharts

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
            id: firstPage
            property int currentContact: -1

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

            ChartView {
                title: "Line Chart"
                anchors.fill: parent
                antialiasing: true

                LineSeries {
                    name: "Line"
                    XYPoint { x: 0; y: 0 }
                    XYPoint { x: 1.1; y: 2.1 }
                    XYPoint { x: 1.9; y: 3.3 }
                    XYPoint { x: 2.1; y: 2.1 }
                    XYPoint { x: 2.9; y: 4.9 }
                    XYPoint { x: 3.4; y: 3.0 }
                    XYPoint { x: 4.1; y: 3.3 }
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
}
