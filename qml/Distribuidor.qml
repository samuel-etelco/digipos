import Felgo 3.0
 import QtQuick 2.0


   Page {
     id: distribuidorPage

     title : "Digital Shop Distribuidor"

     // property with json data
     //property var jsonData: [ { "cCP": "07300", "cCalle": "manizales", "cCiudad": "CDMX", "cColonia": "Lindavista", "cName": "ESTELA GUTIERREZ", "cNumExt": "33", "cNumInt": "", "cPassword": "estela", "cUser": "estela", "dTimeStamp": "2020-11-09T23:16:45.000Z", "idDistribuidor": 2, "idseller": 5, "nIsActive": 1, "sellerType": "2" } ]
     property var jsonData: []

     Component.onCompleted: {

         loadJsonData()
     }


     onVisibleChanged: {

         if ( visible)
         {
             if ( jsonData.length === 0  && dataModel.body !== null)
             {
                 loadJsonData()
             }
         }

     }



     // list model for json data
     JsonListModel {
       id: jsonModel
       source: distribuidorPage.jsonData
       //keyField: "id"
     }

     // list view
     AppListView {
       anchors.fill: parent
       model: jsonModel
       delegate: SimpleRow {
         text: buildText()

         detailText: buildDetailText() ;

         onSelected: {

         }


         function buildText()
         {
             var sType = "" ;

              console.log(model.sellerType)

             console.log( "sellerType = " +  model.sellerType )

             if ( model.sellerType === 2 )
             {
                 sType = "Punto de Venta"
             }
             else
             {
                 sType = "SubDistribuidor"
             }

             console.log("buildText = " + sType)
             return sType ;
         }


         function buildDetailText()
         {



             var retVal = "Nombre     : " +model.cName +"\n" ;
                 retVal +="iD             : " + model.idseller + "\n" ;
                 retVal +="Calle         : " + model.cCalle + "\n" ;
                 retVal +="Num Ext    : " + model.cNumExt + "\n" ;
                 retVal +="Num Int    : " +  model.cNumInt + "\n"  ;
                 retVal +="Colonia     : " +  model.cColonia + "\n"  ;
                 retVal +="Cp            : " +  model.cCP + "\n"  ;
                 retVal +="Ciudad      : " +  model.cCiudad + "\n"  ;


             console.log("buildDetail = " + retVal)


             return retVal ;

         }


       }

       // transition animation for adding items
       add: Transition {
         NumberAnimation {
           property: "opacity";
           from: 0;
           to: 1;
           duration: 1000
           easing.type: Easing.OutQuad;
         }
       }
     }

     // Button to add a new entry
/*
     AppButton {
       anchors.horizontalCenter: parent.horizontalCenter
       anchors.bottom: parent.bottom

       text: "Add Entry"
       onClicked: {
         var newItem = {
           "id": jsonModel.count + 1,
           "title": "Entry "+(jsonModel.count + 1)
         }
         page.jsonData.push(newItem)

         // manually emit signal that jsonData property changed
         // JsonListModel thus synchronizes the list with the new jsonData
         page.jsonDataChanged()
       }
     }
*/
     function loadJsonData()
     {

         console.log( "Llamando a loadJsonData()")




         var theUrl = "https://mxgsesoftware.com/pos/getdistribuidor/" + dataModel.body.idseller   ;

         console.log( "theUrl = " + theUrl ) ;


         HttpRequest
                .get(theUrl)
                .timeout(6000)
                .then(function(res) {
                  console.log(res.status);
                  console.log(JSON.stringify(res.header, null, 4));
                  console.log(JSON.stringify(res.body, null, 4));


                 distribuidorPage.jsonData =  res.body ;

                 //nativeUtils.displayMessageBox("Llego la respuesta", "", 1)

                 //inventoryPage.jsonData = res.body




                })
                .catch(function(err) {
                  console.log(err.message)
                  console.log(err.response)

                  nativeUtils.displayMessageBox("Error al solicitar distribuidores", "", 1)

                });


     }


   } // Page

