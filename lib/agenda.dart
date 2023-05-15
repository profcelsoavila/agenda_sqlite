import 'package:flutter/material.dart';
import 'contact_dao.dart';
import 'contact.dart';

//Classe agenda
class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  //Instancia o bejto DAO dos Contatos
  final ContactDao dao = ContactDao();

  //lista de contatos
  List<Contact> contacts = [];

  // Controladores dos TextFields
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  //método connstrutor
  _AgendaState() {
    /*conecta-se com o banco de dados. Como é uma operação assíncrona,
    irá executar o método load somente após retornar value*/
    dao.connect().then((value) {
      load();
    });
  }

  //método para carregar todos os registros. value será a lista de contatos
  //retornada
  load() {
    dao.list().then((value) {
      setState(() {
        contacts = value;
        name.text = "";
        phone.text = "";
      });
    });
  }

  //Método build que gera a tela do aplicativo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda"),
      ),
      body: Column(
        children: [
          //TextFiels para nome e telefone
          fieldName(),
          fieldPhone(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonSave(), //botão salvar
              buttonDel(), //botão excluir
              buttonClear(), // botão limpar
            ],
          ),
          listView(), //chama o método que cria uma listview com
          //os contatos cadastrados
        ],
      ),
    );
  }

  //campo de texto para o nome
  fieldName() {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Nome',
      ),
      controller: name,
    );
  }

  //campo de texto para o telefone
  fieldPhone() {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Telefone',
      ),
      controller: phone,
    );
  }

  //botão salvar
  buttonSave() {
    return ElevatedButton(
      child: const Text('Gravar'),
      onPressed: () {
        //testa se um nome fi preenchido
        if (name.text.trim() != '') {
          //cria um objeto contact e o insere no banco de dados
          var c = Contact(
            name: name.text,
            phone: phone.text,
          );
          dao.insert(c).then((value) {
            load();
          });
        }
      },
    );
  }

//botão excluir
  buttonDel() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red, // foreground
      ),
      child: const Text('Excluir'),
      onPressed: () {
        //executará load somente quando o método assíncrono terminar
        dao.delete(name.text.trim()).then((value) {
          load();
        });
      },
    );
  }

  //botão limpar
  buttonClear() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.green, // background
        backgroundColor: Colors.white, // foreground
      ),
      child: const Text('Limpar'),
      onPressed: () {
        setState(() {
          name.text = "";
          phone.text = "";
        });
      },
    );
  }

  //listview para mostrar os nomes e telefones cadastrados

  listView() {
    return Expanded(
      child: ListView.builder(
        //shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          //cria um lista com título e subtítulo
          return ListTile(
            title: Text(
              contacts[index].name,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(contacts[index].phone),
            //ao clicar sobre um contato da lista, exibe seu
            //nome e telefone
            onTap: () {
              setState(() {
                name.text = contacts[index].name;
                phone.text = contacts[index].phone;
              });
            },
          );
        },
      ),
    );
  }
}
