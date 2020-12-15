import QtQuick 2.0
import Felgo 3.0
import QtQuick.Layouts 1.12

FlickablePage {
    id: item

    title: qsTr("Digital Shop ... Configuración")


    property bool proceed :false
    property int  option: 0


    property bool loadDelay: false


    rightBarItem: NavigationBarRow {
      ActivityIndicatorBarItem {
        visible: true

        animating: HttpNetworkActivityIndicator.enabled
        showItem: showItemAlways
      }

    }


    Timer {
        id : myTimer

        interval: 1500;  repeat: false
        onTriggered: {
            console.log( "timeout()")

            loadDelay = false
        }
    }


    Component.onCompleted: {
        console.log( "Oready ... cargando")

        HttpNetworkActivityIndicator.activationDelay = 0
        HttpNetworkActivityIndicator.completionDelay = 2000


        loadDelay = true ;
        myTimer.start()

      //myProcesadas = page

    }

    onVisibleChanged: {

        if ( visible)
        {
            console.log( "Cargando Ready2")

            loadDelay = true
            myTimer.start()
        }

    }



    ColumnLayout{
        spacing: 100


        anchors.centerIn: parent

       AppButton {
/*
           minimumHeight: 75
           minimumWidth: 150
*/
           radius : 20

           //anchors.horizontalCenter: parent.horizontalCenter
           text: "        Recargar         "

           onClicked: {

                proceed = true
                option = 0 ;
                nativeUtils.displayMessageBox("Desea efectuar una recarga de datos???", "=>", 2)


           }

       }

       AppButton {
/*
           minimumHeight: 75
           minimumWidth: 150
*/
           radius : 20

           //anchors.horizontalCenter: parent.horizontalCenter
           text: "Cargar Evidencias"

           onClicked: {

                proceed = true
                option = 1
                nativeUtils.displayMessageBox("Desea subir datos pendientes a la nube???", "=>", 2)

           }

       }


       AppButton {

           radius : 20

           //anchors.horizontalCenter: parent.horizontalCenter
           text: "Pedidos en Proceso"

           onClicked: {

               navigationStack.push(myPedidoUpdate)

                //proceed = true
                //option = 1
                //nativeUtils.displayMessageBox("Desea subir datos pendientes a la nube???", "=>", 2)

           }

       }





    }

   Connections  {
       target: nativeUtils

       onMessageBoxFinished : {


           if ( accepted === true && option === 0 && proceed === true )
           {

               if ( myInventory !== null )
               {
                   myInventory.loadJsonData()

                   console.log( "Si contiene AProcesar") ;
               }
/*
               if ( myProcesadas !== null )
               {
                    myProcesadas.loadJsonData()
               }

               if ( proceed === false )
               {
                   return ;
               }
*/
               proceed = false ;

               //loadDelay = true
               //myTimer.start()


               nativeUtils.displayMessageBox("Los datos se han recargado", "", 1)

               return ;

           }

           if ( accepted === true && option ===1 && proceed === true )
           {
               proceed = false

               if( dataModel.pendingCount === 0 )
               {
                   nativeUtils.displayMessageBox("No se tienen evidencias pendientes", "", 1)

                   return ;
               }


               dataModel.getFirst(saveImages , endImages) ;
               // Aqui iniciamos el proceso


               return ;
           }

       }

   }

   function firstImages()
   {

       dataModel.getFirst(saveImages , endImages) ;

   }

   function endImages(str)
   {
       console.log("Se llego al final de la carga de evidencias")

       nativeUtils.displayMessageBox(str,"",1) ;
   }

   function saveImages(myObj)
   {


       return ;

/*
       HttpRequest
              .post("https://azul40.com/home/wkuqdsjq/app/upimage")
              .set('Content-Type', 'application/json')
              .send(myObj)
              .timeout(8000)
              .then(function(res) {
                console.log(res.status);
                console.log(JSON.stringify(res.header, null, 4));
                console.log(JSON.stringify(res.body, null, 4));


                  logic.setNumEvidencias()


                  //nativeUtils.displayMessageBox("Su evidencia ha sido enviada", "ok", 1)

                  //navigationStack.pop()

                  dataModel.removeEvidence(myObj.id,firstImages)

              })
              .catch(function(err) {
                console.log(err.message)
                console.log(err.response)

                  endImages("No se enviaron todas las evidencias pendientes...") ;


                  //nativeUtils.displayMessageBox("No se pudo enviar evidencia\nSe enviara en la siguiente reconexión "  , err.message , 1)


              });
*/
   }

   Component {

       id : myPedidoUpdate

       PedidoUpdate{}
   }


}
