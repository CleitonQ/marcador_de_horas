import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:horas_v3/l10n/app_localizations.dart';
import 'package:horas_v3/helpers/hour_helpers.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../components/menu.dart';
import 'package:horas_v3/models/hour.dart';
import 'package:horas_v3/models/language_provider.dart';
import 'package:horas_v3/l10n/l10n.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Hour> listHours = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Agora armazenamos só o total formatado, sem o rótulo (que será traduzido na UI)
  String totalFormatted = '';

  @override
  void initState() {
    super.initState();
    setuptFCM();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context); // (mantido se você usa em outro lugar)

    return Scaffold(
      drawer: Menu(user: widget.user),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              l.horas,
              style: const TextStyle(fontSize: 18),
            ),
            Container(
              height: 20,
              width: 1,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            Text(
              '${l.total}: $totalFormatted',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ClockWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
        tooltip: l.addButton,
      ),
      body: (listHours.isEmpty)
          ? Center(
        child: Text(
          l.emptyStateMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      )
          : ListView(
        padding: const EdgeInsets.only(left: 4, right: 4),
        children: List.generate(
          listHours.length,
              (index) {
            Hour model = listHours[index];
            return Dismissible(
              key: ValueKey<Hour>(model),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 12),
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                remove(model);
              },
              child: Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      onLongPress: () {
                        showFormModal(model: model);
                      },
                      onTap: () {},
                      leading: const Icon(
                        Icons.list_alt_rounded,
                        size: 56,
                      ),
                      title: Text(
                        '${l.dateLabel}: ${model.data}  ${l.timeLabel}: ${HourHelper.minutesTohours(model.minutos)}',
                      ),
                      subtitle: Text(model.descricao ?? ''),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Modal de adicionar/editar horas, todo traduzido
  showFormModal({Hour? model}) {
    final l = AppLocalizations.of(context)!;

    String title = l.addDialogTitle;
    String confirmationButton = l.saveButton;
    String skipButton = l.cancel;

    TextEditingController dataController = TextEditingController();
    final dataMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');
    TextEditingController minutosController = TextEditingController();
    final minutosMaskFormatter = MaskTextInputFormatter(mask: '##:##');
    TextEditingController descricaoController = TextEditingController();

    // Define data atual
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    dataController.text = currentDate;

    if (model != null) {
      title = l.editDialogTitle;
      dataController.text = model.data;
      minutosController.text = HourHelper.minutesTohours(model.minutos);
      if (model.descricao != null) {
        descricaoController.text = model.descricao!;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(32),
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView(
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                TextFormField(
                  controller: dataController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText: l.dateHint, // '01/01/2025'
                    labelText: l.dateLabel, // 'Data'
                  ),
                  inputFormatters: [dataMaskFormatter],
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                      setState(() {
                        dataController.text = formattedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: minutosController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: l.workedHoursHint, // '00:00'
                    labelText: l.workedHoursLabel, // 'Horas trabalhadas'
                  ),
                  inputFormatters: [minutosMaskFormatter],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descricaoController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: l.descriptionHint, // 'Lembrete do que você fez'
                    labelText: l.descriptionLabel, // 'Descrição'
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(skipButton),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Hour hour = Hour(
                          id: const Uuid().v1(),
                          data: dataController.text,
                          minutos: HourHelper.hoursToMinutos(minutosController.text),
                        );

                        if ((descricaoController.text).trim().isNotEmpty) {
                          hour.descricao = descricaoController.text.trim();
                        }

                        if (model != null) {
                          hour.id = model.id;
                        }

                        firestore.collection(widget.user.uid).doc(hour.id).set(hour.toMap());
                        refresh();
                        Navigator.pop(context);
                      },
                      child: Text(confirmationButton),
                    ),
                  ],
                ),
                const SizedBox(height: 180),
              ],
            ),
          ),
        );
      },
    );
  }

  void remove(Hour model) {
    firestore.collection(widget.user.uid).doc(model.id).delete();
    refresh();
  }

  Future<void> refresh() async {
    double total = 0;
    List<Hour> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(widget.user.uid).get();
    for (var doc in snapshot.docs) {
      temp.add(Hour.fromMap(doc.data()));
      total += doc.data()['minutos'];
    }

    Duration horas = Duration(minutes: total.toInt());

    setState(() {
      listHours = temp;
      totalFormatted =
      '${horas.inHours}h:${horas.inMinutes.remainder(60).toString().padLeft(2, '0')}';
    });
  }

  setuptFCM() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('### já funciona Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late String formattedTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time),
        const SizedBox(width: 8),
        Text(formattedTime),
      ],
    );
  }
}
