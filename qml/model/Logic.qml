import QtQuick 2.0
import Felgo 3.0

Item {

    id: item

    signal setUserSelected( string idSel , string userSel , string passwordSel )

    signal setBody( var theBody )

    signal setPedido( int iOrder )

    signal setObservaCalifica( var obscal)

    signal setEvidence()

    signal setProducto( var p)

}
