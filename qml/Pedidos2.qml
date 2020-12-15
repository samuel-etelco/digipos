import QtQuick 2.0
import Felgo 3.0

Page {

    id: item

    title: qsTr("Digital Shop ... Pedidos")


    property var jsonData: []



    Component.onCompleted: {

        console.log( "Pedidos")


        loadJsonData()

        //jsonModel = myInventory.jsonData

    }


    JsonListModel {
      id: jsonModel
      source: jsonData
      keyField: "id"
    }


    ListPage {
      title: "Seleccione un Producto para Pedido"
/*

      SearchBar {
        id: searchBar
        target: myListView
        pullEnabled: true
        showClearButton: true
        placeHolderText: "Buscar"
        //showDivider:true
        onAccepted: {
          console.log("search accepted: "+text)

          var theArray = getMatchArray( jsonData , text )
          //listView.model = 2 // update result

          if ( theArray.legnth === 0 )
          {
              text = "" ;

              return ;
          }

          var theNewArray = [] ;

          for( var i = 0 ; i < theArray.length ; i++ )
          {
              theNewArray.push( jsonData[theArray[i]] ) ;
          }

          logic.setDataFilter( theNewArray ) ;

            //console.log( "onAccepted" + jsonData[0].cDescripcion) ;

          page.navigationStack.push(myFiltrado) ;

        }
      }

*/
      AppListView {

          id : myListView


          //spacing: 10
        model: jsonModel

        delegate: SimpleRow {

            text : model.cDescripcion

            detailText: buildDetail()
            //icon: IconType.mobilephone

            onSelected: {
                //pageLoader.source = "AProcesarData.qml"

                console.log(index)

                logic.setProducto(jsonData[index])


                page.navigationStack.push(myComponent) ;



            }


            function buildDetail()
            {
                var text = "Sku       : " +model.sku +"\n" ;
                    //text +="Cantidad : " +model.nQuantity + "\n" ;
                    //text +="Precio    : " + model.nPrice + "\n" ;
                    //text +="Color     : " +  model.cColor + "\n"  ;

                return text ;

            }


        }


      }
    }


    Component{

        id : myComponent

        PedidosEntry{}

    }

    function loadJsonData()
    {
        console.log( "Llamando a loadJsonData()")




        var theUrl = "https://mxgsesoftware.com/pos/getproductos"  ;

        console.log( "theUrl = " + theUrl ) ;


        HttpRequest
               .get(theUrl)
               .timeout(6000)
               .then(function(res) {
                 console.log(res.status);
                 console.log(JSON.stringify(res.header, null, 4));
                 console.log(JSON.stringify(res.body, null, 4));


                //nativeUtils.displayMessageBox("Llego la respuesta", "", 1)

                jsonData = res.body




               })
               .catch(function(err) {
                 console.log(err.message)
                 console.log(err.response)

                 nativeUtils.displayMessageBox("Error al solicitar el Productos", "", 1)

               });

    }




}
