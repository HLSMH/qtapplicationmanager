/****************************************************************************
**
** Copyright (C) 2015 Pelagicore AG
** Contact: http://www.qt.io/ or http://www.pelagicore.com/
**
** This file is part of the Pelagicore Application Manager.
**
** $QT_BEGIN_LICENSE:GPL3-PELAGICORE$
** Commercial License Usage
** Licensees holding valid commercial Pelagicore Application Manager
** licenses may use this file in accordance with the commercial license
** agreement provided with the Software or, alternatively, in accordance
** with the terms contained in a written agreement between you and
** Pelagicore. For licensing terms and conditions, contact us at:
** http://www.pelagicore.com.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU General Public License version 3 requirements will be
** met: http://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/

#pragma once

#include <QVector>
#include <QMap>
#include <QHash>

#include "dbus-utilities.h"

class WindowManagerPrivate
{
public:
    int findWindowByApplication(const Application *app) const;
    int findWindowBySurfaceItem(QQuickItem *quickItem) const;

#if !defined(AM_SINGLE_PROCESS_MODE)
    int findWindowByWaylandSurface(QWaylandSurface *waylandSurface) const;

    WaylandCompositor *waylandCompositor = nullptr;
#endif

    QHash<int, QByteArray> roleNames;
    QVector<Window *> windows;

    bool watchdogEnabled = false;

    QMap<QByteArray, DBusPolicy> dbusPolicy;
    QList<QQuickView *> views;
};