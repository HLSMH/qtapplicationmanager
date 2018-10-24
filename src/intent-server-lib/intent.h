/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Pelagicore Application Manager.
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

#pragma once

#include <QString>
#include <QStringList>
#include <QVariantMap>
#include <QtAppManCommon/global.h>

QT_BEGIN_NAMESPACE_AM

class Intent
{
    Q_GADGET
    Q_PROPERTY(bool valid READ (operator bool))
    Q_PROPERTY(QString intentId READ intentId)
    Q_PROPERTY(QString applicationId READ applicationId)
    Q_PROPERTY(QtAM::Intent::Visibility visibility READ visibility)
    Q_PROPERTY(QStringList requiredCapabilities READ requiredCapabilities)
    Q_PROPERTY(QVariantMap parameterMatch READ parameterMatch)

public:
    enum Visibility {
        Public,
        Hidden,
        Private
    };
    Q_ENUM(Visibility)

    Intent();
    Intent(const Intent &other);

    QString intentId() const;
    Visibility visibility() const;
    QStringList requiredCapabilities() const;
    QVariantMap parameterMatch() const;

    QString applicationId() const;
    QString backgroundServiceId() const;

    bool checkParameterMatch(const QVariantMap &parameters) const;

    explicit operator bool() const;
    bool operator ==(const Intent &other) const;

private:
    Intent(const QString &intentId, const QString &applicationId, const QString &backgroundHandlerId,
           const QStringList &capabilities, Intent::Visibility visibility,
           const QVariantMap &parameterMatch = QVariantMap());

    QString m_intentId;
    Visibility m_visibility = Private;
    QStringList m_requiredCapabilities;
    QVariantMap m_parameterMatch;

    QString m_applicationId;
    QString m_backgroundHandlerId;

    friend class IntentServer;
};

QT_END_NAMESPACE_AM

Q_DECLARE_METATYPE(QT_PREPEND_NAMESPACE_AM(Intent))