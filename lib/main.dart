import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Comparador de Investimentos",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controladores para o Investimento 1
  final TextEditingController capital1Controller = TextEditingController();
  final TextEditingController aplicacaoMensal1Controller = TextEditingController();
  final TextEditingController periodoMeses1Controller = TextEditingController();
  final TextEditingController taxaMes1Controller = TextEditingController();

  // Controladores para o Investimento 2
  final TextEditingController capital2Controller = TextEditingController();
  final TextEditingController aplicacaoMensal2Controller = TextEditingController();
  final TextEditingController periodoMeses2Controller = TextEditingController();
  final TextEditingController taxaMes2Controller = TextEditingController();

  void calcularEComparar() {
    // Função para calcular os resultados de cada investimento
    double calcularMontanteFinal(
      double capital,
      double aplicacaoMensal,
      int meses,
      double taxaJuros,
      List<String> detalhes,
    ) {
      double montante = capital;
      for (int i = 1; i <= meses; i++) {
        double rendimentoMensal = montante * taxaJuros;
        montante += rendimentoMensal + aplicacaoMensal;
        detalhes.add(
          "Mês $i: R\$ ${montante.toStringAsFixed(2)} (Rendimento = R\$ ${rendimentoMensal.toStringAsFixed(2)})",
        );
      }
      return montante;
    }

    // Verifica se os campos estão preenchidos
    if (capital1Controller.text.isEmpty ||
        aplicacaoMensal1Controller.text.isEmpty ||
        periodoMeses1Controller.text.isEmpty ||
        taxaMes1Controller.text.isEmpty ||
        capital2Controller.text.isEmpty ||
        aplicacaoMensal2Controller.text.isEmpty ||
        periodoMeses2Controller.text.isEmpty ||
        taxaMes2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    // Converte os valores de entrada
    double capital1 = double.parse(capital1Controller.text);
    double aplicacaoMensal1 = double.parse(aplicacaoMensal1Controller.text);
    int meses1 = int.parse(periodoMeses1Controller.text);
    double taxaJuros1 = double.parse(taxaMes1Controller.text) / 100;

    double capital2 = double.parse(capital2Controller.text);
    double aplicacaoMensal2 = double.parse(aplicacaoMensal2Controller.text);
    int meses2 = int.parse(periodoMeses2Controller.text);
    double taxaJuros2 = double.parse(taxaMes2Controller.text) / 100;

    // Calcula os resultados para cada investimento
    List<String> detalhes1 = [];
    List<String> detalhes2 = [];
    double montanteFinal1 =
        calcularMontanteFinal(capital1, aplicacaoMensal1, meses1, taxaJuros1, detalhes1);
    double montanteFinal2 =
        calcularMontanteFinal(capital2, aplicacaoMensal2, meses2, taxaJuros2, detalhes2);

    // Navega para a página de resultados, passando os dados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoPage(
          montanteFinal1: montanteFinal1,
          detalhes1: detalhes1,
          montanteFinal2: montanteFinal2,
          detalhes2: detalhes2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparador de Investimentos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Investimento 1',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _campoTexto(
              controller: capital1Controller,
              label: 'Investimento inicial',
            ),
            _campoTexto(
              controller: aplicacaoMensal1Controller,
              label: 'Aplicação Mensal',
            ),
            _campoTexto(
              controller: periodoMeses1Controller,
              label: 'Período em meses',
            ),
            _campoTexto(
              controller: taxaMes1Controller,
              label: 'Taxa de juros mensal (%)',
            ),
            const SizedBox(height: 16),
            const Text(
              'Investimento 2',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _campoTexto(
              controller: capital2Controller,
              label: 'Investimento inicial',
            ),
            _campoTexto(
              controller: aplicacaoMensal2Controller,
              label: 'Aplicação Mensal',
            ),
            _campoTexto(
              controller: periodoMeses2Controller,
              label: 'Período em meses',
            ),
            _campoTexto(
              controller: taxaMes2Controller,
              label: 'Taxa de juros mensal (%)',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularEComparar,
              child: const Text('Comparar Investimentos'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto({required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ResultadoPage extends StatelessWidget {
  final double montanteFinal1;
  final List<String> detalhes1;
  final double montanteFinal2;
  final List<String> detalhes2;

  const ResultadoPage({
    Key? key,
    required this.montanteFinal1,
    required this.detalhes1,
    required this.montanteFinal2,
    required this.detalhes2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparação de Investimentos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Investimento 1',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text('Mês')),
                DataColumn(label: Text('Montante')),
                DataColumn(label: Text('Rendimento')),
              ],
              rows: _gerarLinhasTabela(detalhes1),
            ),
            const Divider(),
            const Text(
              'Investimento 2',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text('Mês')),
                DataColumn(label: Text('Montante')),
                DataColumn(label: Text('Rendimento')),
              ],
              rows: _gerarLinhasTabela(detalhes2),
            ),
            const Divider(),
            Text(
              'Resumo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Montante Final do Investimento 1: R\$ ${montanteFinal1.toStringAsFixed(2)}',
            ),
            Text(
              'Montante Final do Investimento 2: R\$ ${montanteFinal2.toStringAsFixed(2)}',
            ),
          ],
        ),
      ),
    );
  }

  // Função para gerar as linhas da tabela
  List<DataRow> _gerarLinhasTabela(List<String> detalhes) {
    return detalhes.map((detalhe) {
      // Quebra o texto no formato esperado: "Mês X: Montante (Rendimento = Y)"
      final RegExp regex = RegExp(r'Mês (\d+): R\$ ([\d.,]+) \(Rendimento = R\$ ([\d.,]+)\)');
      final match = regex.firstMatch(detalhe);

      if (match != null) {
        final mes = match.group(1) ?? '';
        final montante = match.group(2) ?? '';
        final rendimento = match.group(3) ?? '';

        return DataRow(cells: [
          DataCell(Text(mes)),
          DataCell(Text('R\$ $montante')),
          DataCell(Text('R\$ $rendimento')),
        ]);
      }

      return DataRow(cells: [
        DataCell(Text('Erro')),
        DataCell(Text('Erro')),
        DataCell(Text('Erro')),
      ]);
    }).toList();
  }
}
