import QtQuick 2.0
import Felgo 3.0

import QtMultimedia 5.9


import QtPositioning 5.12

import barcode 1.0
import barcodeFilter 1.0


Page {

    id: cameraPage




    property var  coordinate : NULL
    property bool  afterFoto: false
    property string  theTag: ""
    property int count : 0

    title : "Digital Shop Evidence"


    //enabled : false

    rightBarItem: NavigationBarRow {
      ActivityIndicatorBarItem {
        visible: true
        animating: HttpNetworkActivityIndicator.enabled
        showItem: showItemAlways
      }

    }

    function displayCamera()
    {
        console.log( "displayCamera")
        //nativeUtils.displayCameraPicker("test")
        //camera.start()

        var media = QtMultimedia.availableCameras ;

        for( var i = 0 ; i < media.length ; i++ )
        {
            console.log( "media = " + media[i].displayName)
        }


        //camera.imageCapture.capture();
    }


    Image{
        id: imageToDecode
        visible: false
    }


    Timer {

        id : theTimer ;

        interval: 15000; running: true; repeat: false
        onTriggered: {
            camera.stop()


            nativeUtils.displayMessageBox("No se pudo detectar su codigo", "ok", 1)

           navigationStack.pop()

        }
    }



    Camera {
        id: camera

        captureMode:  Camera.CaptureStillImage



        focus {
            focusMode: CameraFocus.FocusContinuous
            focusPointMode: CameraFocus.FocusPointAuto
        }

        //orientation: 0

        viewfinder.minimumFrameRate: 5
        viewfinder.maximumFrameRate: 6

        onCameraStatusChanged:
        {

            console.log( "Status changed " + cameraStatus + " " +  Camera.ActiveStatus + " " + errorString) ;

            if ( cameraStatus === Camera.ActiveStatus )
            {
                camera.imageCapture.capture();
            }
        }

        imageCapture {
                    onImageCaptured: {
                        console.log( "Capturando imagen")
                        imageToDecode.source = preview  // Show the preview in an Image
                    }
                }


    }





    QZXingFilter {

        id : decoder2 // Para proceso con video

        //decoder.enabledDecoders:  QZXing.DecoderFormat_QR_CODE  | QZXing.DecoderFormat_EAN_13 | QZXing.DecoderFormat_CODE_128 | QZXing.DecoderFormat_DATA_MATRIX | QZXing.DecoderFormat_RSS_EXPANDED

        //decoder.tryHarderType: QZXing.TryHarderBehaviour_ThoroughScanning | QZXing.TryHarderBehaviour_Rotate

        //decoder.imageSourceFilter:  QZXing.SourceFilter_ImageNormal //| QZXing.SourceFilter_ImageInverted


        decoder {
            //enabledDecoders: QZXing.DecoderFormat_EAN_13 | QZXing.DecoderFormat_CODE_39 | QZXing.DecoderFormat_QR_CODE

            enabledDecoders:  QZXing.DecoderFormat_QR_CODE  | QZXing.DecoderFormat_EAN_13 | QZXing.DecoderFormat_CODE_128 | QZXing.DecoderFormat_DATA_MATRIX | QZXing.DecoderFormat_RSS_EXPANDED


            onTagFound: {
                console.log(tag + " | " + decoder.foundedFormat() + " | " + decoder.charSet());

                theTimer.stop()

                camera.stop() ;

                theTag = tag ;


                var myTime = dataModel.getFormatDate()

                var idDist = 0 ;
                var idVend = 0 ;

                if ( dataModel.body.isPos === 1 ) // Se trata de un punto de venta
                {
                    idVend = dataModel.body.idseller
                    idDist = dataModel.body.idseller

                }
                else
                {
                    idVend = dataModel.body.idseller
                    idDist = dataModel.body.idseller
                }


                var myValue = {
                    idDistribuidor: 0,
                    idVendedorPos: idVend,
                    observaciones: dataModel.observaCalifica.observaciones,
                    tag : theTag ,
                    califica : dataModel.observaCalifica.califica,
                    image:  '{}',
                    cLongitud : coordinate.longitude,
                    cLatitud : coordinate.latitude ,
                    dTimeStamp: myTime
                };

                sendEvidence(myValue) ;
            }

            tryHarder: false
        }


        onDecodingStarted: console.log( "Inicia decodificacion")


        property int framesDecoded: 0
        property real timePerFrameDecode: 0

        onDecodingFinished:
        {
           timePerFrameDecode = (decodeTime + framesDecoded * timePerFrameDecode) / (framesDecoded + 1);
           framesDecoded++;
           if(succeeded)
            console.log("frame finished: " + succeeded, decodeTime, timePerFrameDecode, framesDecoded);
        }



    }


    QZXing{
        id: decoder


        enabledDecoders:  QZXing.DecoderFormat_QR_CODE  | QZXing.DecoderFormat_EAN_13 | QZXing.DecoderFormat_CODE_128 | QZXing.DecoderFormat_DATA_MATRIX | QZXing.DecoderFormat_RSS_EXPANDED

        tryHarderType: QZXing.TryHarderBehaviour_ThoroughScanning | QZXing.TryHarderBehaviour_Rotate


        imageSourceFilter: QZXing.SourceFilter_ImageNormal //| QZXing.SourceFilter_ImageInverted


        onDecodingStarted: console.log("Decoding of image started...")

        onTagFound: {
            //dialog.text = tag
            //dialog.open();

            theTag = tag ;

            console.log( "tag = " + tag ) ;
        }

        onError: {

            console.log( "Se detecto un error " + msg ) ;

            theTag = "No" ;
        }

        onDecodingFinished: console.log("Decoding finished " + (succeeded==true ? "successfully" :    "unsuccessfully") )


    }


//
    onVisibleChanged: {

        console.log( "onVisibleChanged") ;

        if ( visible /* && afterFoto === false */)
        {
            console.log( "A tomar la foto")
            //nativeUtils.displayCameraPicker("test")
        }

    }


    Component.onCompleted: {
        console.log( "Antes de enviar el mensaje")

        HttpNetworkActivityIndicator.activationDelay = 0
        HttpNetworkActivityIndicator.completionDelay = 1000

        //nativeUtils.displayCameraPicker("test")
        displayCamera() ;
    }



    PositionSource {
        id: src
        updateInterval: 5000
        active: true

        onPositionChanged: {

            var coord = src.position.coordinate;

            coordinate = coord ;

            console.log("Coordinate:", coord.longitude, coord.latitude);

            if (src.supportedPositioningMethods ===
                                PositionSource.NoPositioningMethods) {


                console.log( "No soporta los metodos")
            }
        }
    }



    NavigationStack {

      Page {
/*
        AppImage {
          id: image
          anchors.fill: parent
          // important to automatically rotate the image taken from the camera
          autoTransform: true
          fillMode: Image.PreserveAspectFit
        }

*/
        VideoOutput {
            source: camera

            autoOrientation: true
            fillMode: VideoOutput.Stretch
            filters: [ decoder2 ]
            anchors.fill: parent
            focus: true

        }

/*
        AppButton {
          anchors.centerIn: parent
          text: "Tomar Foto"
          onClicked: {
            nativeUtils.displayCameraPicker("test")
          }
        }
*/

        Connections {
          target: nativeUtils
          onCameraPickerFinished: {

            console.log( "path = " +  path + " observaciones = " + dataModel.observaCalifica.observaciones )

            afterFoto = true ;


            if(accepted) {
                image.source = path

                imageToDecode.source = path ;


                decoder.decodeImageQML(imageToDecode);

                console.log( "Ya pasamos imageToDecode") ;


                var reader = HttpImageUtils.createReader(path)

                reader.setScaledSize(600, 600, Image.PreserveAspectFit);

                reader.read() ;

                var myJson = reader.toJSON() ;

                console.log(myJson.substr(0,100))


                //app.backNavigationEnabled = false

                var myTime = dataModel.getFormatDate()

                var idDist = 0 ;
                var idVend = 0 ;

                if ( dataModel.body.isPos === 1 ) // Se trata de un punto de venta
                {
                    idVend = dataModel.body.idseller
                    idDist = dataModel.body.idseller

                }
                else
                {
                    idVend = dataModel.body.idseller
                    idDist = dataModel.body.idseller
                }


                console.log( JSON.stringify(dataModel.body) )
                console.log( JSON.stringify(dataModel.observaCalifica) )

                console.log( "Antes de values")
                var myValue = {
                    idDistribuidor: 0,
                    idVendedorPos: idVend,
                    observaciones: dataModel.observaCalifica.observaciones,
                    tag : theTag ,
                    califica : dataModel.observaCalifica.califica,
                    image:  myJson,
                    cLongitud : coordinate.longitude,
                    cLatitud : coordinate.latitude ,
                    dTimeStamp: myTime
                };

                console.log( "Despues de values")

                //console.log( JSON.stringify(myValue) )

                 nativeUtils.displayMessageBox("Su evidencia ha sido enviada", "ok", 1)

                navigationStack.pop()

                return ;



                HttpRequest
                       .post("https://mxgsesoftware.com/home/zcxqxhso/app/upposimage")
                       .set('Content-Type', 'application/json')
                       .send( myValue )
                       .timeout(8000)
                       .then(function(res) {
                         console.log(res.status);
                         console.log(JSON.stringify(res.header, null, 4));
                         console.log(JSON.stringify(res.body, null, 4));


                           //logic.setNumEvidencias()

                           logic.setEvidence()


                           nativeUtils.displayMessageBox("Su evidencia ha sido enviada", "ok", 1)

                           //app.backNavigationEnabled = true


                           //nativeUtils.displayCameraPicker("test")



                           navigationStack.pop() // Ojo

                           //navigationStack.popAllExceptFirstAndPush(oProcesadas)



                       })
                       .catch(function(err) {
                         console.log(err.message)
                         console.log(err.response)

                           // Guardamos la evidencia en forma persistente

                           //var myId = dataModel.pendingEvidence.length + 1


                           //var myObj = { image : image.source , longitud : coordinate.longitude, latitude : coordinate.latitude , califica : dataModel.califica , id : dataModel.servicio , lectura : dataModel.lecturaObs.lectura , observaciones : dataModel.observaciones , dTimeStamp :myTime  } ;


                           //logic.setNumEvidencias()

                           //dataModel.savePending(myObj) ; // Mandamos guardar servicios
                           //app.backNavigationEnabled = true


                           navigationStack.pop()


                           //nativeUtils.displayMessageBox("No se pudo enviar evidencia\nSe enviara en la siguiente reconexión "  , err.message , 1)


                       });



            }
            else
            {
                // No se acepto

                //app.backNavigationEnabled = true
                navigationStack.pop()

            }
          }
        }
      }
    }

    function sendEvidence( myValue )
    {
        HttpRequest
               .post("https://mxgsesoftware.com/home/zcxqxhso/app/upposimage")
               .set('Content-Type', 'application/json')
               .send( myValue )
               .timeout(8000)
               .then(function(res) {
                 console.log(res.status);
                 console.log(JSON.stringify(res.header, null, 4));
                 console.log(JSON.stringify(res.body, null, 4));


                   //logic.setNumEvidencias()

                   logic.setEvidence()

                   nativeUtils.displayMessageBox("Su evidencia ha sido enviada", "ok", 1)




                   navigationStack.pop() // Ojo


               })
               .catch(function(err) {
                 console.log(err.message)
                 console.log(err.response)


                   nativeUtils.displayMessageBox("No se pudo enviar evidencia\nNo Hay Conexión "  , err.message , 1)

                   navigationStack.pop()
               });


    }



}
