import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/distance-matrix.dart';
import 'package:planvisitas_grupohbf/models/objetivovisita/objetivovisita-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plansemanal-upsert-model.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/google-maps.service.dart';
import 'package:planvisitas_grupohbf/services/objetivovisita/objetivovisita.service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EnviarPlanPage extends StatefulWidget {
  final List<PlanSemanalUpsertModel> visitas;
  final DateTime fecha;
  EnviarPlanPage({this.visitas, this.fecha});

  @override
  _EnviarPlanPageState createState() => _EnviarPlanPageState();
}

class _EnviarPlanPageState extends State<EnviarPlanPage> {
  String dropdownValue = 'One';
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController dateinput = TextEditingController();

  List<ObjetivoVisitaModel> _objetivos = [];

  List<TextEditingController> textEditingControllers = [];

  ObjetivoVisitaService objetivoService;
  @override
  void initState() {
    widget.visitas.forEach((element) {
      var textEditingController = TextEditingController(text: element.Hora);
      textEditingControllers.add(textEditingController);
    });
    super.initState();

    objetivoService = ObjetivoVisitaService();
    objetivoService.listarObjetivos().then((value) => {
          setState(() {
            _objetivos = value.Listado;
          })
        });
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
      content: Text("Desea confirmar la visita?"),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {},
            )
          ],
          title: Text('Confirmar plan'),
          backgroundColor: const Color(0xFF74CCBB),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.visitas.length,
          itemBuilder: (context, i) {
            return Card(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                leading: const Icon(Icons.check),
                title: Text(widget.visitas[i].Cliente_RazonSocial),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.visitas[i].Sucursal_Direccion),
                    Text(
                        "${new DateFormat('dd/MM/yyyy').format(widget.visitas[i].PlanSemanal_Horario.toLocal())}")
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Container(
                      width: 120,
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: textEditingControllers[i],
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today, color: Colors.black),
                            labelText: "Fecha",
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                            )),
                        readOnly: true,
                        onTap: () async {
                          final TimeOfDay timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            initialEntryMode: TimePickerEntryMode.dial,
                          );
                          if (timeOfDay != null && timeOfDay != selectedTime) {
                            setState(() {
                              selectedTime = timeOfDay;
                              String formattedDateDesde =
                                  selectedTime.format(context);
                              textEditingControllers[i].text =
                                  formattedDateDesde;
                              var time = widget.visitas[i].PlanSemanal_Horario;
                              time = new DateTime(
                                  time.year,
                                  time.month,
                                  time.day,
                                  timeOfDay.hour,
                                  timeOfDay.minute,
                                  time.second,
                                  time.millisecond,
                                  time.microsecond);
                              widget.visitas[i].PlanSemanal_Horario = time;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
                      width: 200,
                      child: _objetivos.length == 0
                          ? Text("...")
                          : DropdownButton<ObjetivoVisitaModel>(
                              isExpanded: true,
                              value: _objetivos
                                  .where((element) =>
                                      element.ObjetivoVisita_Id ==
                                      widget.visitas[i].ObjetivoVisita_Id)
                                  .first,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                              onChanged: (ObjetivoVisitaModel newValue) {
                                setState(() {
                                  widget.visitas[i].ObjetivoVisita_Id =
                                      newValue.ObjetivoVisita_Id;
                                });
                              },
                              items: _objetivos
                                  .map<DropdownMenuItem<ObjetivoVisitaModel>>(
                                      (ObjetivoVisitaModel value) {
                                return DropdownMenuItem<ObjetivoVisitaModel>(
                                  value: value,
                                  child: Text(value.ObjetivoVisita_Descripcion),
                                );
                              }).toList(),
                            ),
                    ),
                  )
                ],
              )
            ]));
          },
        ));
  }
}
