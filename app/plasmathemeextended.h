/*
 * Copyright 2018  Michail Vourlakos <mvourlakos@gmail.com>
 *
 * This file is part of Latte-Dock
 *
 * Latte-Dock is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * Latte-Dock is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#ifndef PLASMATHEMEEXTENDED_H
#define PLASMATHEMEEXTENDED_H

#include <QObject>

#include <schemecolors.h>

#include <array>

#include <QTemporaryDir>

#include <KConfigGroup>
#include <KSharedConfig>

#include <Plasma/Theme>

namespace Latte {

class DockCorona;

class PlasmaThemeExtended: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int bottomEdgeRoundness READ bottomEdgeRoundness NOTIFY roundnessChanged)
    Q_PROPERTY(int leftEdgeRoundness READ leftEdgeRoundness NOTIFY roundnessChanged)
    Q_PROPERTY(int topEdgeRoundness READ topEdgeRoundness NOTIFY roundnessChanged)
    Q_PROPERTY(int rightEdgeRoundness READ rightEdgeRoundness NOTIFY roundnessChanged)

    Q_PROPERTY(SchemeColors *lightTheme READ lightTheme NOTIFY themesChanged)
    Q_PROPERTY(SchemeColors *darkTheme READ darkTheme NOTIFY themesChanged)

public:
    PlasmaThemeExtended(KSharedConfig::Ptr config, QObject *parent);
    ~PlasmaThemeExtended() override;;

    int bottomEdgeRoundness() const;
    int leftEdgeRoundness() const;
    int topEdgeRoundness() const;
    int rightEdgeRoundness() const;

    int userThemeRoundness() const;
    void setUserThemeRoundness(int roundness);

    SchemeColors *lightTheme() const;
    SchemeColors *darkTheme() const;

    void load();

signals:
    void roundnessChanged();
    void themesChanged();

private slots:
    void loadConfig();
    void saveConfig();
    void loadThemeLightness();

private:
    void loadThemePaths();
    void loadRoundness();

    void setNormalSchemeFile(const QString &file);
    void updateReversedScheme();
    void updateReversedSchemeValues();

    bool themeHasExtendedInfo() const;

private:
    bool m_isLightTheme{false};
    bool m_themeHasExtendedInfo{false};

    int m_bottomEdgeRoundness{0};
    int m_leftEdgeRoundness{0};
    int m_topEdgeRoundness{0};
    int m_rightEdgeRoundness{0};
    int m_userRoundness{0};

    QString m_themePath;
    QString m_normalSchemePath;
    QString m_reversedSchemePath;

    std::array<QMetaObject::Connection, 2> m_kdeConnections;

    QTemporaryDir m_extendedThemeDir;
    KConfigGroup m_themeGroup;
    Plasma::Theme m_theme;

    DockCorona *m_corona{nullptr};
    SchemeColors *m_normalScheme{nullptr};
    SchemeColors *m_reversedScheme{nullptr};
};

}

#endif
