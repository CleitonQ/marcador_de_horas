import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:horas_v3/l10n/app_localizations.dart'; // Para acessar as traduções do app
import 'package:horas_v3/helpers/hour_helpers.dart'; // Helper para manipulação de horas
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Para formatar inputs
import 'package:uuid/uuid.dart'; // Para gerar IDs únicos para cada registro
import 'package:firebase_auth/firebase_auth.dart'; // Importando Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../components/menu.dart';
import 'package:horas_v3/models/hour.dart';
import 'package:horas_v3/models/language_provider.dart'; // Importando o LanguageProvider
import 'package:horas_v3/main.dart'; // Importando MyApp para acessar o setLocale
import 'package:horas_v3/l10n/l10n.dart';  // Importa o arquivo centralizado de localizações

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Hour> listHours = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String total1 = 'Total';

  @override
  void initState() {
    super.initState();
    setuptFCM();  // Função definida acima
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    // Pegando o idioma atual do provider
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      drawer: Menu(user: widget.user),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.horas,  // Usando a tradução para o título
              style: TextStyle(fontSize: 18),
            ),
            // Traço visual entre os textos
            Container(
              height: 20, // Altura do traço
              width: 1, // Espessura do traço
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, // Cor do traço dinâmica
              margin: EdgeInsets.symmetric(horizontal: 8), // Espaço entre o traço e os textos
            ),
            Text(
              "$total1", // Exibe o valor da variável total1
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Row(
              children: [
                Icon(Icons.language), // Ícone de idioma
                SizedBox(width: 8),
                Text(
                  languageProvider.locale.languageCode.toUpperCase(), // Exibe o código do idioma (pt, en)
                ),
              ],
            ),
            onPressed: () {
              // Alternar entre idiomas
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
                items: [
                  PopupMenuItem(
                    value: Locale('en', 'US'),
                    child: Text('English'),
                  ),
                  PopupMenuItem(
                    value: Locale('pt', 'BR'),
                    child: Text('Português'),
                  ),
                ],
              ).then((locale) {
                if (locale != null) {
                  languageProvider.setLocale(locale); // Mudar o idioma usando o provider
                  refresh(); // Atualizar os dados com o novo idioma
                }
              });
            },
          ),
        ],
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal(); // Abre o modal para adicionar uma nova hora
        },
        child: const Icon(Icons.add),
      ),
      body: (listHours.isEmpty)
          ? Center(
        child: Text(
          AppLocalizations.of(context)!.changeLanguageButton, // Exibindo a tradução da mensagem
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
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
                          "Data: ${model.data} hora: ${HourHelper.minutesTohours(model.minutos)}"),
                      subtitle: Text(model.descricao!),
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

  // Função para exibir o modal de adicionar/editar horas
  showFormModal({Hour? model}) {
    String title = "Adicionar";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    TextEditingController dataController = TextEditingController();
    final dataMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');
    TextEditingController minutosController = TextEditingController();
    final minutosMaskFormatter = MaskTextInputFormatter(mask: '##:##');
    TextEditingController descricaoController = TextEditingController();

    if (model != null) {
      title = "Editando";
      dataController.text = model.data;
      minutosController.text = HourHelper.minutesTohours(model.minutos);
      if (model.descricao != null) {
        descricaoController.text = model.descricao!;
      }
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32),
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: dataController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  hintText: '01/01/2025',
                  labelText: 'Data',
                ),
                inputFormatters: [dataMaskFormatter],
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: minutosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: '00:00', labelText: 'Horas trabalhadas'),
                inputFormatters: [minutosMaskFormatter],
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: descricaoController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: 'Lembrete do que você fez',
                    labelText: 'Descrição'),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      skipButton,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Hour hour = Hour(
                          id: const Uuid().v1(),
                          data: dataController.text,
                          minutos: HourHelper.hoursToMinutos(
                            minutosController.text,
                          ));

                      if (descricaoController.text != "") {
                        hour.descricao = descricaoController.text;
                      }

                      if (model != null) {
                        hour.id = model.id;
                      }

                      firestore
                          .collection(widget.user.uid)
                          .doc(hour.id)
                          .set(hour.toMap());

                      refresh();

                      Navigator.pop(context);
                    },
                    child: Text(confirmationButton),
                  ),
                ],
              ),
              const SizedBox(
                height: 180,
              )
            ],
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
      total1 = 'Total: ${horas.inHours.toString()}h:${horas.inMinutes.remainder(60).toString().padLeft(2, '0')}';
    });
  }

  // Função de configuração do Firebase Cloud Messaging (FCM)
  setuptFCM() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicitar permissão para enviar notificações
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Verifica se a permissão foi concedida
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Escuta as mensagens enquanto o app está em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('### já funciona Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
