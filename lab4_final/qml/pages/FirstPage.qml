import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1

Page{

    allowedOrientations: Orientation.All

    function getYear(offset){
        var today = new Date();
        var year = today.getFullYear();
        return (year + offset)
    }

    function blankDays(month, year){
        var days= new Date(year, month).getDay()
        return days === 0 ? 6 : days-1
    }

    function daysInMonth (month, year) {
        return 32 - new Date(year,month,32).getDate()
    }

    function getName(idx){
        const monthNames = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь",
                            "Июль", "Август", "Сентабрь", "Октябрь", "Ноябрь", "Декабрь"];
        return monthNames[idx]
    }

    property int maxYear: getYear(2)
    property int minYear: getYear(-6)

    property int index: 6

    property int year: getYear(0)
    property int month: new Date().getMonth()
    property int day: new Date().getDate()

    property int curYear: getYear(0)
    property int curMonth: new Date().getMonth()
    property int curDay: new Date().getDate()

    property bool flag: true

    /*Календарь по годам*/
    ListView {
        id: listView1
        anchors.top: row.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        cacheBuffer: 4

        delegate: Item {
            id: item
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.width*4

            Rectangle {
                anchors.fill: parent

                /*Год календаря*/
                Text {
                    id: name
                    text: idshnik
                    font.pixelSize: 50
                    font.weight:"Black"
                    color: clr
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width/14
                }

                /*Месяцы текущего года*/
                Grid{
                    anchors.top: name.bottom
                    anchors.topMargin: 30
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    columns: 2
                    spacing: 2

                    Repeater {
                        id:repeater

                        model: 12

                        Rectangle {
                            id: areas
                            width: parent.width/2; height: width*1.25
                            border.width: 1
                            color: "yellow"

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {month=index; box.centerButPressed();}
                            }

                            Text {
                                id: monthName
                                font.weight:"Bold"
                                text: getName(index)
                                font.pointSize: 25
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                            }

                            /*Обозначения дней недели*/
                            Grid {
                                id: weeksLetters
                                columns: 7
                                spacing: parent.width/10
                                anchors.top: monthName.bottom
                                anchors.topMargin: 40
                                anchors.horizontalCenter: parent.horizontalCenter

                                Repeater{
                                    model:7

                                    Rectangle{
                                        width: 10
                                        height: 10
                                        color: "yellow"

                                        function signWeek(){
                                            const letters=["П","В","С","Ч","П","С","В"]
                                            return letters[index]
                                        }

                                        Text {
                                            id: dayOftheWeek
                                            text: signWeek()
                                            anchors.centerIn: parent
                                        }
                                    }
                                }
                            }

                            /*Сетка дней текущего месяца*/
                            Grid{
                                id:gd
                                columns: 7
                                spacing: parent.width/20
                                anchors.top: weeksLetters.bottom
                                anchors.topMargin: 40
                                anchors.horizontalCenter: parent.horizontalCenter

                                Repeater{
                                    id:days

                                    property int blank: blankDays(index,parseInt(name.text,10))
                                    property int month: index

                                    model: daysInMonth(index,parseInt(name.text,10)) + blankDays(index,parseInt(name.text,10))

                                    Rectangle{
                                        width: 30
                                        height: 30

                                        function curDate(){

                                            if(index+1>days.blank){
                                                var date=new Date();
                                                var year=date.getFullYear();
                                                var month=date.getMonth();
                                                var day=date.getDate();

                                                if (year===parseInt(name.text,10) && days.month===month && index+1-days.blank===day){
                                                    return "red"
                                                }else{
                                                    return "yellow"
                                                }

                                            }else{
                                                return "yellow"
                                            }
                                        }

                                        color: curDate()

                                        Text {
                                            anchors.centerIn: parent
                                            color: "black"
                                            text: index+1>days.blank ? index+1-days.blank : ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        model: ListModel {
            id: listModel
        }

        function changeIndex(){
            positionViewAtIndex(5, ListView.Beginning)
        }

        function checkYear(index){
            if(index!==-1){
                var prevYear=year
                var indx=0
                year=listModel.get(index).idshnik
                if(year-prevYear>0){
                    indx=index-1;
                }else if(year-prevYear<0){
                    indx=index+1
                }else{
                    return
                }

                if(prevYear===curYear)
                    listModel.set(indx,{clr:"red"})
                else
                    listModel.set(indx,{clr:"black"})

                listModel.set(index,{clr:"white"})
            }

            return
        }

        /*Реализация "бесконечного скрола" ленты календаря*/
        onContentYChanged: {
            var index=indexAt(contentX,contentY)
            checkYear(index)

            if(index>(count-3) ){
                maxYear++
                listModel.append({idshnik:maxYear, clr: maxYear==curYear ? "red" : "black"})
                listModel.remove(0)
                minYear++
            }else if(index===4 ){
                changeIndex()
                flag=false;
                minYear--
                listModel.insert(0,{idshnik:Math.abs(minYear),clr: maxYear==curYear ? "red" : "black"})
                listModel.remove(count-1)
                maxYear--
            }
        }

        Component.onCompleted: {
            for(var i=0;i<9;i++){
                listModel.append({idshnik:minYear+i,clr:"black"})
            }

            listModel.set(6,{clr:"white"})
            positionViewAtIndex(6, ListView.Beginning)
        }
    }

    /*Календарь по месяцам*/
    Rectangle{
        id:gridBack
        color: "white"
        anchors.top: weeks.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: false

        GridView {
            id: grid
            anchors.fill: parent
            property int nameMax: -1
            property int nameMin: 1
            signal signal4()

            height: parent.height
            cellWidth: width / 7;
            cellHeight: cellWidth;

            model: ListModel {
                id: listmodel2
            }

            delegate : Rectangle {
                width: grid.cellWidth
                height: grid.cellHeight
                border.color: "black"
                color: color1

                Rectangle{
                    anchors.top: parent.top
                    anchors.topMargin: parent.border.width
                    anchors.right: parent.right
                    anchors.rightMargin: parent.border.width
                    width: parent.width/3
                    height: width

                    color: color2
                    Text {
                        anchors.centerIn: parent
                        id: t
                        color: "black"
                        text: number1
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {if(index+1>blankDays(month,year)){box.rightButPressed();day=(index+1-blankDays(month,year));} }
                }
            }

            /*Формируем сетку дней для текущего месяца*/
            onSignal4:{
                listmodel2.clear()
                var days=daysInMonth(month,year)
                var blanks=blankDays(month,year)

                for(var i=0; i<(days+blanks);i++){
                    nameMax++
                    listmodel2.append({color1:"yellow",
                                          color2:year==curYear && month==curMonth && (i+1-blanks)==curDay ? "red" : "yellow",
                                          number1: i+1>blanks ? (i+1-blanks).toString() : ""
                                      })
                }
            }
        }
    }

    /*Календарь по дням*/
    DayPage{
        id:daypage
        anchors.top: row.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        visible: false
    }

    /*Табличка с днями недели*/
    Grid{
        id:weeks
        columns: 7
        height: row.height/2
        width: parent.width
        anchors.top: row.verticalCenter
        anchors.topMargin: row.height/3
        visible: false

        Repeater{
            model:7

            Rectangle{
                width: parent.width/7
                color: "black"
                height: parent.height

                function signWeek(){
                    const letters=["Пн","Вт","Ср","Чт","Пн","Сб","Вс"]
                    return letters[index]
                }

                function specificIndex(){
                    return index===6 ? 0 : index+1
                }

                function checkCurDate(){
                    return year===curYear && month===curMonth && day===curDay ? true : false
                }

                function checkCurDay(){
                    return daypage.visible==true && new Date(year,month,day).getDay()===specificIndex() ? true : false
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height/15
                    anchors.right: parent.right
                    color: checkCurDay() && checkCurDate() ? "red" : "white"
                    text: checkCurDay() ? day+","+signWeek() : signWeek()
                }
            }
        }
    }

    /*Верхнее меню*/
    Rectangle {
        id:row
        anchors.top: parent.top
        width: parent.width
        height: parent.height/8
        color: "black"

        /*Текущий год и месяц*/
        Column{
            spacing: 10

            anchors.left: parent.left
            anchors.leftMargin: parent.width/15
            anchors.top: parent.top
            anchors.topMargin: parent.height/4
            Text{
                text: year


                font.pixelSize: 50
                font.weight: "Black"
                color: year==curYear ? "red" : "white"
            }

            Text {
                id: mthName
                font.pixelSize: 30
                font.weight: "Bold"
                text: getName(month)
                color: month==curMonth && year==curYear ? "red" : "white"
                visible: false
            }
        }

        /*Переключатель между видами календаря*/
        Box{
            id:box
            anchors.centerIn: parent
            width: parent.width/2
            height: parent.height/2

            onSignal1: {gridBack.visible=false; listView1.visible=true; mthName.visible=false; daypage.visible=false; weeks.visible=false}
            onSignal2: {grid.signal4();gridBack.visible=true; mthName.visible=true; listView1.visible=false; daypage.visible=false; weeks.visible=true}
            onSignal3: {gridBack.visible=false; listView1.visible=false; mthName.visible=true; daypage.visible=true; weeks.visible=true}
        }
    }
}
