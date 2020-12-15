import QtQuick 2.0
import Felgo 3.0

FlickablePage {

    id: item

    property var jsonData: []

    property int localIndex : 0

    property bool proceed : false


    title: qsTr("Digital Shop Pedidos Proceso")


    rightBarItem: NavigationBarRow {
      ActivityIndicatorBarItem {
        visible: true
        animating: HttpNetworkActivityIndicator.enabled
        showItem: showItemAlways
      }

    }


    Component.onCompleted: {
        HttpNetworkActivityIndicator.activationDelay = 0
        HttpNetworkActivityIndicator.completionDelay = 2000

      loadJsonData()

    }


    JsonListModel {
      id: jsonModel
      source: jsonData
      keyField: "id"
    }

    ListPage {
      title: "Seleccione una Orden"


      SearchBar {
        id: searchBar
        target: myPedidoiew
        pullEnabled: true
        showClearButton: true
        placeHolderText: "Buscar"
        //showDivider:true
        onAccepted: {
        }
      }


      AppListView {

          id : myPedidoview


        model: jsonModel

        delegate: SimpleRow {

            id : myDelegate

            text : model.cName

            detailText: buildDetail()
            //icon: IconType.mobilephone

            onSelected: {
                //pageLoader.source = "AProcesarData.qml"

                console.log(index)


                localIndex = index

                if ( jsonData[index].estatus === "SOLICITADO")
                {
                    proceed = true ;
                    nativeUtils.displayMessageBox("Desea cancelar este pedido ", "", 2)

                }



            }


            function buildDetail()
            {
                var text = "Sku       : " +model.sku +"\n" ;
                    text +="Cantidad : " +model.nQuantity + "\n" ;
                    text +="Fecha    : " + model.dTimeStamp + "\n" ;
                    text +="Estatus     : " +  model.estatus + "\n"  ;

                return text ;

            }


        }


        Connections {

            target: nativeUtils

            // this signal has the parameter accepted, telling if the Ok button was clicked
            onMessageBoxFinished: {
              if(accepted)
              {
                  if ( proceed === false)
                  {
                      return ;
                  }

                  // Do something
                  console.log( "Vamos a cancelar pedido") ;

                  var pedido = {

                  idPedidos :  jsonData[ item.localIndex].idpedidos ,
                  idSellerAut :  dataModel.body.idseller , // body.idseller
                  idStatusNuevo : 5 , // 5
                  cComentario : "Cancelado por cliente" ,
                  dTimeStamp : dataModel.getFormatDate()

                  }

                  proceed = false ;
                  updateStatus( pedido )
              }
            }
        }


      }
    }



    function updateStatus( pedido )
    {

        console.log( JSON.stringify(pedido))

        HttpRequest
               .post("https://mxgsesoftware.com/pos/setpedidoaut")
               .set('Content-Type', 'application/json')
               .send( pedido)
               .timeout(8000)
               .then(function(res) {
                 console.log(res.status);
                 console.log(JSON.stringify(res.header, null, 4));
                 //console.log(JSON.stringify(res.body, null, 4));



                   nativeUtils.displayMessageBox("Se ha cancelado el pedido", "ok", 1)


                   loadJsonData()




                   //root.navigationStack.push(thisCamera)



               })
               .catch(function(err) {
                 console.log(err.message)
                 console.log(err.response)
                   nativeUtils.displayMessageBox("Error al enviar al cancelar pedido"  , err.message , 1)

                   altaButton.enabled = true

               });


    }

    function loadJsonData()
    {

        var theUrl = "https://mxgsesoftware.com/pos/orderstatus/" + dataModel.body.idseller   ;

        console.log( "theUrl = " + theUrl ) ;


        HttpRequest
               .get(theUrl)
               .timeout(6000)
               .then(function(res) {
                 console.log(res.status);
                 console.log(JSON.stringify(res.header, null, 4));
                 console.log(JSON.stringify(res.body, null, 4));


                jsonData = res.body ;


                //nativeUtils.displayMessageBox("Llego la respuesta", "", 1)

                //inventoryPage.jsonData = res.body




               })
               .catch(function(err) {
                 console.log(err.message)
                 console.log(err.response)

                 nativeUtils.displayMessageBox("Error al solicitar el inventario", "", 1)

               });


    }

}
