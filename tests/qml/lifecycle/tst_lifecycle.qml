/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Application Manager.
**
** $QT_BEGIN_LICENSE:LGPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or (at your option) the GNU General
** Public license version 3 or any later version approved by the KDE Free
** Qt Foundation. The licenses are as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL2 and LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-2.0.html and
** https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: LGPL-3.0
**
****************************************************************************/

import QtQuick 2.11
import QtTest 1.0
import QtApplicationManager 2.0
import QtApplicationManager.SystemUI 2.0

TestCase {
    id: testCase
    when: windowShown
    name: "LifeCycleTest"
    visible: true

    property var app: ApplicationManager.application("tld.test.lifecycle");


    WindowItem {
        id: chrome
        anchors.fill: parent
    }

    Connections {
        target: WindowManager
        onWindowAdded: chrome.window = window;
    }

    Connections {
        target: chrome.window
        onContentStateChanged: {
            if (chrome.window.contentState === WindowObject.NoSurface)
                chrome.window = null;
        }
    }


    SignalSpy {
        id: runStateChangedSpy
        target: ApplicationManager
        signalName: "applicationRunStateChanged"
    }

    SignalSpy {
        id: objectDestroyedSpy
        target: AmTest
        signalName: "objectDestroyed"
    }

    Timer {
        id: stopTimer
        interval: 1
        onTriggered: app.stop();
    }


    function cleanup() {
        objectDestroyedSpy.clear();
        var index = AmTest.observeObjectDestroyed(app.runtime);
        app.stop();
        while (app.runState !== ApplicationObject.NotRunning)
            runStateChangedSpy.wait();
        objectDestroyedSpy.wait();
        compare(objectDestroyedSpy.signalArguments[0][0], index);
    }


    // Start followed by quick stop/start in single-porcess mode caused an abort in the past
    function test_fast_stop_start() {
        app.start();
        runStateChangedSpy.wait();
        compare(app.runState, ApplicationObject.StartingUp);
        runStateChangedSpy.wait();
        compare(app.runState, ApplicationObject.Running);

        objectDestroyedSpy.clear();
        var index = AmTest.observeObjectDestroyed(app.runtime);

        app.stop();
        runStateChangedSpy.wait();
        compare(app.runState, ApplicationObject.ShuttingDown);
        runStateChangedSpy.wait();
        compare(app.runState, ApplicationObject.NotRunning);

        app.start();
        runStateChangedSpy.wait();
        compare(app.runState, ApplicationObject.StartingUp);
        runStateChangedSpy.wait();
        compare(app.runState, ApplicationObject.Running);

        objectDestroyedSpy.wait();
        compare(objectDestroyedSpy.signalArguments[0][0], index);
    }

    // Quick start/stop followd by start in single-process mode caused an abort in the past
    function test_fast_start_stop() {
        app.start();
        stopTimer.start();

        while (app.runState !== ApplicationObject.NotRunning)
            runStateChangedSpy.wait();

        app.start();
        while (app.runState !== ApplicationObject.Running)
            runStateChangedSpy.wait();
    }
}
