import QtQuick 2.0
import Felgo 3.0

Item {

    id: item

    property alias dispatcher: logicConnection.target

    property var  body: null

    property int indexOrder : -1

    property  var observaCalifica: null

    property int numEvidencias : 0

    property var  producto: null


    Connections {
      id: logicConnection

      onSetBody : {
          body = theBody
      }

      onSetPedido : {
          indexOrder = iOrder
      }

      onSetObservaCalifica : {
          observaCalifica = obscal
      }

      onSetEvidence :
      {
          numEvidencias ++ ;
      }

      onSetProducto :
      {
          producto = p ;
      }


    }

    function getFormatDate()
    {
        var date = new Date();
        var dateStr =
            date.getFullYear() + "-" +
            ("00" + (date.getMonth() + 1)).slice(-2) + "-" +
            ("00" + date.getDate()).slice(-2) + " " +
            ("00" + date.getHours()).slice(-2) + ":" +
            ("00" + date.getMinutes()).slice(-2) + ":" +
            ("00" + date.getSeconds()).slice(-2);
            console.log(dateStr);

        return dateStr ;
    }





}

