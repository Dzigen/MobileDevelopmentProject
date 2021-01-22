import QtQuick 2.0

Item {
    property bool pressedButleft: true
        property bool pressedButcenter: false
        property bool pressedButright: false


        signal signal1()
        signal signal2()
        signal signal3()

        onPressedButcenterChanged: {
            centerBut.color="white"
            month.color="red"

        }

        onPressedButleftChanged: {
            leftBut.color="white"
            leftBut1.color="white"
            year.color="red"
        }


        onPressedButrightChanged: {
            rightBut.color="white"
            rightBut1.color="white"
            day.color="red"
        }

        Rectangle{
            id:firstArea
            anchors.fill:parent
            color: "black"

            Rectangle{
                anchors.right: centerBut.left
                anchors.top: centerBut.top
                height: parent.height
                width: parent.width/3
                color: "black"


                Rectangle{
                    id: leftBut1
                    radius: parent.height
                    anchors.horizontalCenter: leftBut.left
                    anchors.top: parent.top
                    height: parent.height
                    width: parent.height
                    color: "red"
                }
                Rectangle{
                    id: leftBut
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: parent.height
                    width: (parent.width -parent.width/3)
                    color: "red"
                }

                Text {
                    id: year
                    anchors.centerIn: parent
                    text: qsTr("Год")
                    color: "white"
                }

                MouseArea{
                    id: leftArea
                    hoverEnabled: true
                    anchors.fill: parent
                    onContainsMouseChanged: {
                        if(pressedButleft!==true){
                            if(containsMouse===true){
                                leftBut.color= "#ffb6c1"
                                leftBut1.color= "#ffb6c1"

                            }else{
                                leftBut.color="white"
                                leftBut1.color="white"
                            }
                        }
                    }
                    onReleased: {
                        pressedButleft=true
                        leftBut.color="red"
                        leftBut1.color="red"
                        year.color= "white"

                        pressedButcenter=false
                        pressedButright=false

                        signal1()
                    }
                }
            }

            Rectangle{
                id: centerBut
                anchors.centerIn: parent
                height: parent.height
                width: parent.width/3
                color: "white"

                Text {
                    anchors.centerIn: parent
                    id: month
                    text: qsTr("Месяц")
                    color: "red"
                }

                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent
                    onContainsMouseChanged: {
                        if(pressedButcenter!==true){
                            if(containsMouse===true){
                                centerBut.color= "#ffb6c1"
                            }else{
                                centerBut.color="white"
                            }
                        }
                    }
                    onReleased: {
                        pressedButcenter=true
                        centerBut.color="red"
                        month.color= "white"

                        pressedButleft=false
                        pressedButright=false

                        signal2()
                    }
                }

            }

            Rectangle{
                anchors.left: centerBut.right
                anchors.top: centerBut.top
                height: parent.height
                width: parent.width/3
                color: "black"


                Rectangle{
                    id: rightBut1
                    radius: parent.height
                    anchors.horizontalCenter: rightBut.right
                    anchors.top: parent.top
                    height: parent.height
                    width: parent.height
                    color: "white"
                }
                Rectangle{
                    id: rightBut
                    anchors.left: parent.left
                    anchors.top: parent.top
                    height: parent.height
                    width: (parent.width -parent.width/3)
                    color: "white"
                }

                Text {
                    id: day
                    anchors.centerIn: parent
                    text: qsTr("День")
                    color: "red"
                }

                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent
                    onContainsMouseChanged: {
                        if(pressedButright!==true){
                            if(containsMouse===true){
                                rightBut.color= "#ffb6c1"
                                rightBut1.color= "#ffb6c1"

                            }else{
                                rightBut.color="white"
                                rightBut1.color="white"
                            }
                        }
                    }
                    onReleased: {
                        pressedButright=true
                        rightBut.color="red"
                        rightBut1.color="red"
                        day.color= "white"


                        pressedButcenter=false
                        pressedButleft=false

                        signal3()
                    }
                }
            }

        }
}
