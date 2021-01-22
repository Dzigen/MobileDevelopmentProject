import QtQuick 2.0
import Nemo.Notifications 1.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1

Item {

    Rectangle{
        id:firstArea
        anchors.fill:parent
        color: "yellow"


        Rectangle{
            id:clock
            anchors.centerIn: parent
            color: "black"
            width: parent.width/2
            height: width
            radius: width
            TimePicker {
                anchors.fill: parent
                hour: 13
                minute: 30
            }
        }
    }
}
