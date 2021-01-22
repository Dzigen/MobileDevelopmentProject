import QtQuick 2.0

Item {

    Rectangle{
        id:firstArea
        anchors.fill:parent
        color: "white"

        /**
         *Заглушка.
         *Планируется выводить информацию о погоде по текущему дню.
         */
        Rectangle{
            id:weather
            anchors.top: daysScroll.bottom
            height:200
            width: parent.width
            color: "blue"

            Text {
                id: t
                text: qsTr("Погода")
                color: "white"
            }
        }

        /**
         *Заглушка.
         *Планируется реализовать функцию для отметки будущих мероприятий в календаре.
         */
        Rectangle{
            id:events
            anchors.top: weather.bottom
            anchors.topMargin: 50
            height:100
            width: parent.width
            color: "black"

            Text {
                id: t1
                text: qsTr("События")
                color: "white"
            }
        }

        /**
         *Заглушка.
         *Планируется реализовать возможность записи текстовой информации по каждому дню.
         */
        Rectangle{
            anchors.top: events.bottom
            anchors.topMargin: 50
            height:100
            width: parent.width
            color: "black"

            Text {
                id: t2
                text: qsTr("Записи")
                color: "white"
            }
        }

        /**
         *Заглушка.
         *Планируется реализовать способ двежения по датам в календаре по дням
         */
        Rectangle{
            id:daysScroll
            color: "green"
            anchors.top: parent.top
            width: parent.width
            height: 30

        }

    }
}
