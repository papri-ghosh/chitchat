import 'package:chitchat/Pages/gemini/aiModel.dart';
import 'package:chitchat/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class UiPage extends StatefulWidget {
  const UiPage({super.key});

  @override
  State<UiPage> createState() => _UiPageState();
}

class _UiPageState extends State<UiPage> {
  TextEditingController promptController = TextEditingController();
  static const apikey = "AIzaSyCaGU-FlBLRNUuZW9BamPK6cm_Rg0nzffY";
  final model = GenerativeModel(model: "gemini-pro", apiKey: apikey);
  final List<ModelMessage> prompt = [];
  Future<void> sendMessage() async {
    final message = promptController.text;

    setState(() {
      promptController.clear();
      prompt.add(
          ModelMessage(isPrompt: true, message: message, time: DateTime.now()));
    });

    // Check if the user is asking for the current date
    if (message.toLowerCase().contains("date") ||
        message.toLowerCase().contains("today")) {
      // Respond with today's date
      final today = DateFormat('MMMM dd, yyyy').format(DateTime.now());
      setState(() {
        prompt.add(ModelMessage(
            isPrompt: false,
            message: "Today's date is $today",
            time: DateTime.now()));
      });
    } else {
      try {
        // Otherwise, proceed with generating a response from the model
        final content = [Content.text(message)];
        final response = await model.generateContent(content);

        setState(() {
          prompt.add(ModelMessage(
              isPrompt: false,
              message: response.text ?? "No response",
              time: DateTime.now()));
        });
      } catch (e) {
        // Handle the exception by showing a message to the user
        setState(() {
          prompt.add(ModelMessage(
              isPrompt: false,
              message: "Error: Unable to generate response. Please try again.",
              time: DateTime.now()));
        });
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dBackgroundColor,
    // appBar: AppBar(backgroundColor: dBackgroundColor),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: prompt.length,
            itemBuilder: (context, index) {
              final message = prompt[index];
              return userPrompt(
                  isprompt: message.isPrompt,
                  message: message.message,
                  date: DateFormat('hh:mm a').format(message.time));
            },
          )),
          Padding(
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                    flex: 20,
                    child: TextField(
                      controller: promptController, 
                      style: TextStyle(color: Colors.white, fontSize: 20),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),

                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.transparent), // No border when active
                                ),
                          hintText: "Enter Your Message"),
                          
                    )
                    ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: const CircleAvatar(
                    radius: 29,
                    backgroundColor: dPrimaryColor,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container userPrompt(
      {required final bool isprompt,
      required String message,
      required String date}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ).copyWith(left: isprompt ? 80 : 15, right: isprompt ? 15 : 80),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: isprompt ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: isprompt ? Radius.circular(20) : Radius.zero,
              bottomRight: isprompt ? Radius.zero : Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //for prompt and respond
          Text(
            message,
            style: TextStyle(
                fontWeight: isprompt ? FontWeight.bold : FontWeight.normal,
                fontSize: 18,
                color: isprompt ? Colors.white : Colors.black),
          ),

          //for prompt and respond time
          Text(
            date,
            style: TextStyle(
                fontSize: 18, color: isprompt ? Colors.white : Colors.black),
          )
        ],
      ),
    );
  }
}
