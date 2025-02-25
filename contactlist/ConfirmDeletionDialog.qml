// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls

Dialog {
    id: dialog

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    focus: true
    modal: true
    title: qsTr("Contact deletion")
    standardButtons: Dialog.Ok | Dialog.Cancel

    contentItem: Label {
        text: "Do you really want to delete the contact?"
    }
}
