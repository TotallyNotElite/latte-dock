/*
*  Copyright 2018 Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.latte 0.1 as Latte

Item{
    id: main
    anchors.fill: parent
    clip: true

    property int roundness: 0
    property color backgroundColor

    property bool topBorder: false
    property bool leftBorder: false
    property bool bottomBorder: false
    property bool rightBorder: false

    property int noOfBorders: {
        var i = 0;

        if (topBorder) {
            i = i + 1;
        }
        if (leftBorder) {
            i = i + 1;
        }
        if (rightBorder) {
            i = i + 1;
        }
        if (bottomBorder) {
            i = i + 1;
        }

        return i;
    }

    readonly property bool drawWithoutRoundness: noOfBorders === 1 || !Latte.WindowSystem.compositingActive

    Binding{
        target: main
        property: "topBorder"
        when: dock
        value: {
            return ((dock && (dock.enabledBorders & PlasmaCore.FrameSvg.TopBorder)) > 0);
        }
    }

    Binding{
        target: main
        property: "leftBorder"
        when: dock
        value: {
            return ((dock && (dock.enabledBorders & PlasmaCore.FrameSvg.LeftBorder)) > 0);
        }
    }

    Binding{
        target: main
        property: "bottomBorder"
        when: dock
        value: {
            return ((dock && (dock.enabledBorders & PlasmaCore.FrameSvg.BottomBorder)) > 0);
        }
    }

    Binding{
        target: main
        property: "rightBorder"
        when: dock
        value: {
            return ((dock && (dock.enabledBorders & PlasmaCore.FrameSvg.RightBorder)) > 0);
        }
    }

    Rectangle{
        id: painter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: {
            if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
                if (drawWithoutRoundness || noOfBorders === 3) {
                    return parent.width;
                } else if (noOfBorders === 2) {
                    return parent.width + roundness;
                }
            } else if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                if (drawWithoutRoundness) {
                    return parent.width;
                } else if (noOfBorders === 2 || noOfBorders === 3) {
                    return parent.width + roundness;
                }
            }
        }


        height: {
            if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
                if (drawWithoutRoundness) {
                    return parent.height;
                } else if (noOfBorders === 2 || noOfBorders === 3) {
                    return parent.height + roundness;
                }
            } else if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
                if (drawWithoutRoundness || noOfBorders === 3) {
                    return parent.height;
                } else if (noOfBorders === 2) {
                    return parent.height + roundness;
                }
            }
        }

        radius: drawWithoutRoundness ? 0 : roundness
        color: parent.backgroundColor
        border.width: 0; border.color: "transparent"

        readonly property int centerStep: roundness / 2

        states: [
            State {
                name: "horizontal"
                when: (plasmoid.formFactor === PlasmaCore.Types.Horizontal)

                PropertyChanges{
                    target: painter
                    anchors.horizontalCenterOffset: {
                        if (drawWithoutRoundness || noOfBorders === 3) {
                            return 0;
                        } else if (noOfBorders === 2) {
                            if (leftBorder) {
                                return centerStep;
                            } else if (rightBorder) {
                                return -centerStep;
                            }
                        }

                        return 0;
                    }
                    anchors.verticalCenterOffset: {
                        if (drawWithoutRoundness) {
                            return 0;
                        } else {
                            //top edge and bottom edge
                            return plasmoid.location === PlasmaCore.Types.TopEdge ? -centerStep : centerStep;
                        }
                    }
                }
            },
            State {
                name: "vertical"
                when: (plasmoid.formFactor === PlasmaCore.Types.Vertical)

                PropertyChanges{
                    target: painter
                    anchors.verticalCenterOffset: {
                        if (drawWithoutRoundness || noOfBorders === 3) {
                            return 0;
                        } else if (noOfBorders === 2) {
                            if (bottomBorder) {
                                return -centerStep;
                            } else if (topBorder) {
                                return centerStep;
                            }
                        }
                    }
                    anchors.horizontalCenterOffset: {
                        if (drawWithoutRoundness) {
                            return 0;
                        } else {
                            //left edge and right edge
                            return plasmoid.location === PlasmaCore.Types.LeftEdge ? -centerStep : centerStep;
                        }
                    }
                }
            }
        ]
    }

}
