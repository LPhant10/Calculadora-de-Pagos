import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de Pagos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  @override
  _CalculadoraScreenState createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final TextEditingController jugadoresController = TextEditingController();
  final TextEditingController canchaController = TextEditingController();
  final TextEditingController apuestaController = TextEditingController();
  
  String resultado = "";

  void calcularPago({bool empate = true, int ganadores = 0}) {
    int totalJugadores = int.tryParse(jugadoresController.text) ?? 0;
    double precioCancha = double.tryParse(canchaController.text) ?? 0.0;
    double apuesta = double.tryParse(apuestaController.text) ?? 0.0;

    if (totalJugadores > 0) {
      double costoPorJugador = precioCancha / totalJugadores;
      
      if (empate) {
        setState(() {
          resultado = "Cada jugador paga (cancha): S/ ${costoPorJugador.toStringAsFixed(2)}";
        });
      } else {
        int perdedores = totalJugadores - ganadores;
        double pagoPerdedores = costoPorJugador + apuesta;
        double pagoGanadores = costoPorJugador;
        double gananciaGanadores = (apuesta * perdedores / ganadores) - costoPorJugador;
        if (gananciaGanadores < 0) {
          pagoGanadores = gananciaGanadores.abs();
          gananciaGanadores = 0;
        }
        
        setState(() {
          resultado = "Total jugadores: $totalJugadores\n"
                      "Pago por jugador(cancha): S/ ${costoPorJugador.toStringAsFixed(2)}\n"
                      "Jugadores perdedores pagan: S/ ${pagoPerdedores.toStringAsFixed(2)}\n"
                      "Jugadores ganadores pagan: S/ ${pagoGanadores.toStringAsFixed(2)}\n"
                      "Jugadores ganadores ganan: S/ ${gananciaGanadores.toStringAsFixed(2)}";
        });
      }
    } else {
      setState(() {
        resultado = "Por favor, ingrese valores válidos";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora de Pagos by LPhant')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: jugadoresController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cantidad de jugadores'),
            ),
            TextField(
              controller: canchaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Precio de la cancha'),
            ),
            TextField(
              controller: apuestaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cantidad de apuesta por jugador'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => calcularPago(empate: true),
                  child: Text('Empate'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController ganadoresController = TextEditingController();
                        return AlertDialog(
                          title: Text("Ingrese cantidad de ganadores"),
                          content: TextField(
                            controller: ganadoresController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Cantidad de ganadores"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                int ganadores = int.tryParse(ganadoresController.text) ?? 0;
                                int totalJugadores = int.tryParse(jugadoresController.text) ?? 0;
                                if (ganadores > 0 && ganadores < totalJugadores) {
                                  calcularPago(empate: false, ganadores: ganadores);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Aceptar"),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Gana un equipo'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              resultado,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
