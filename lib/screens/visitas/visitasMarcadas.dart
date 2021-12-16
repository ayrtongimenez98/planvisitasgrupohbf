import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaMarcada.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';

class VisitasMarcadasPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VisitasMarcadasPageState();
  }
}

class _VisitasMarcadasPageState extends State<VisitasMarcadasPage>
    with WidgetsBindingObserver {
  VisitasService visitasService;

  List<VisitaModel> _visitas = [];
  bool loading = false;
  @override
  void initState() {
    loading = true;
    visitasService = VisitasService();
    visitasService.traerVisitasDelDia().then((value) {
      setState(() {
        _visitas = value.Listado;
        loading = false;
      });
    });
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {},
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confimar"),
      content: Text("Desea confirmar visita?"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF74CCBB),
              ),
            )
          : Column(children: [
              Divider(color: Colors.grey, height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _visitas.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        if (!_visitas[index]
                                .Visita_Ubicacion_Salida
                                ?.trim()
                                ?.isEmpty ??
                            true) {
                        } else {
                          var plan = new VisitaUpsertModel(
                              Ciudad: _visitas[index].Ciudad,
                              Cliente: _visitas[index].Cliente,
                              Cliente_Cod: _visitas[index].CodCliente,
                              Direccion: _visitas[index].Direccion,
                              Estado_Id: 1,
                              Motivo_Id: 1,
                              Sucursal_Id: _visitas[index].Sucursal_Id,
                              Vendedor_Id: 0,
                              Visita_fecha: _visitas[index].Visita_fecha,
                              Visita_Hora_Entrada: new DateTime.now(),
                              Visita_Hora_Salida: new DateTime.now(),
                              Visita_Id: _visitas[index].Visita_Id,
                              Visita_Observacion: "",
                              Visita_Ubicacion_Entrada:
                                  _visitas[index].Visita_Ubicacion_Entrada,
                              Visita_Ubicacion_Salida: "");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VisitaMarcadaViewPage(
                                    VisitaMarcada: plan,
                                    VisitaMarcadaId: plan.Visita_Id,
                                  )));
                        }
                      },
                      child: Card(
                        borderOnForeground: true,
                        clipBehavior: Clip.hardEdge,
                        color: Colors.white,
                        child: Container(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        "${new DateFormat('dd/MM/yyyy').format(_visitas[index].Visita_fecha.toLocal())}",
                                        style: TextStyle(fontSize: 20)),
                                    Text(
                                        "${_visitas[index].Visita_Hora_Entrada}",
                                        style: TextStyle(fontSize: 20))
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15, bottom: 15),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.map),
                                    Flexible(
                                      child: Padding(
                                        child: Text(_visitas[index].Direccion),
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.format_list_bulleted),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(_visitas[index].Cliente),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: !_visitas[index]
                                            .Visita_Ubicacion_Salida
                                            ?.trim()
                                            ?.isEmpty ??
                                        true
                                    ? Text("")
                                    : ButtonBar(
                                        alignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          FlatButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Icon(Icons.location_on),
                                                Text("  Marcar salida")
                                              ],
                                            ),
                                            onPressed: () {
                                              var plan = new VisitaUpsertModel(
                                                  Ciudad:
                                                      _visitas[index].Ciudad,
                                                  Cliente:
                                                      _visitas[index].Cliente,
                                                  Cliente_Cod: _visitas[index]
                                                      .CodCliente,
                                                  Direccion:
                                                      _visitas[index].Direccion,
                                                  Estado_Id: 1,
                                                  Motivo_Id: 1,
                                                  Sucursal_Id: _visitas[index]
                                                      .Sucursal_Id,
                                                  Vendedor_Id: 0,
                                                  Visita_fecha: _visitas[index]
                                                      .Visita_fecha,
                                                  Visita_Hora_Entrada:
                                                      new DateTime.now(),
                                                  Visita_Hora_Salida:
                                                      new DateTime.now(),
                                                  Visita_Id:
                                                      _visitas[index].Visita_Id,
                                                  Visita_Observacion: "",
                                                  Visita_Ubicacion_Entrada: "",
                                                  Visita_Ubicacion_Salida: "");
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VisitaMarcadaViewPage(
                                                            VisitaMarcada: plan,
                                                            VisitaMarcadaId:
                                                                plan.Visita_Id,
                                                          )));
                                            },
                                            color: Colors.white,
                                            textColor: Colors.black,
                                          ),
                                        ],
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
    );
  }
}

class _orderBloc {}
