import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        
        
        title: const Text(
          "LocalBiz",
          style: TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.help_center_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ajuda ainda não implementada"))
              );
          }, 
          )
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                const SizedBox(height: 20,),

                const Text(
                  "Entrar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height: 8,),

                const Text(
                  "Bem-vindo de volta ao seu comércio local",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "E-mail/Empresa",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),

                const Text(
                  "Senha",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Esqueci minha senha",
                      style: TextStyle(
                        color: Color(0xFF64748B)
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 52,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64748B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),

                    onPressed: () {},

                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Não tenho conta, ",
                    ),

                    GestureDetector(
                      onTap: () {},

                      child: const Text(
                        "cadastrar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B)
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),

                      child: Text(
                        "OU ENTRE COM",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 52,

                  child: OutlinedButton(

                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    
                    onPressed: () {},

                    child: const Text(
                      "Google",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50,),

                const Text(
                  "© 2024 LocalBiz. Todos os direitos reservados.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11
                  ),
                )
                
              ],
            )
          ),
        ),
      )
    );
  }
}